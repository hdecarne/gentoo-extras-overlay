# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="ownCloud Infinite Scale Stack"

HOMEPAGE="https://doc.owncloud.com/ocis/next/"

OCIS_PV="${PV}"
OCIS_P="${PN}-${OCIS_PV}"

WEB_ASSETS_VERSION="v10.1.0"
ASSET_COMMIT="e8b6aeadbcee1865b9df682e9bd78083842d2b5c"

SRC_URI="https://github.com/owncloud/ocis/archive/refs/tags/v${OCIS_PV}.tar.gz -> ${P}.tar.gz
	https://github.com/owncloud/web/releases/download/${WEB_ASSETS_VERSION}/web.tar.gz -> ${P}-web.tar.gz
	https://github.com/owncloud/assets/raw/${ASSET_COMMIT}/favicon.ico -> ocis-favicon-${ASSET_COMMIT}.ico
	https://raw.githubusercontent.com/owncloud/assets/${ASSET_COMMIT}/logo.svg -> ocis-logo-${ASSET_COMMIT}.svg"

S="${WORKDIR}/${OCIS_P}"

LICENSE="Apache-2.0 BSD-2 BSD-3 MIT MPL-2.0 ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="network-sandbox"

RDEPEND="acct-group/http
	acct-user/http"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	net-libs/nodejs[npm]"

src_unpack() {
	unpack "${P}.tar.gz"
	mkdir "${WORKDIR}/web" || die "unpack failed"
	tar xzf "${DISTDIR}/${P}-web.tar.gz" -C "${WORKDIR}/web" || die "unpack failed"
	cp "${DISTDIR}/ocis-favicon-${ASSET_COMMIT}.ico" "${WORKDIR}/favicon.ico"
	cp "${DISTDIR}/ocis-logo-${ASSET_COMMIT}.svg" "${WORKDIR}/logo.svg"
}

src_prepare() {
	eapply "${FILESDIR}/ocis-build-6.0.0.patch"
	default
}

src_compile() {
	npm install pnpm || die "compile failed"

	# oCIS Makefiles have several issues with parallel builds
	local OCIS_MAKEOPTS="-j 1"

	PATH="${S}/node_modules/.bin:${PATH}" \
		emake ${OCIS_MAKEOPTS} VERSION=${OCIS_PV} generate

	local OCIS_DEFAULTS="github.com/owncloud/ocis/v2/ocis-pkg/config/defaults"

	LDFLAGS="-X ${OCIS_DEFAULTS}.BaseDataPathType=path -X ${OCIS_DEFAULTS}.BaseDataPathValue=/var/lib/ocis -X ${OCIS_DEFAULTS}.BaseConfigPathType=path -X ${OCIS_DEFAULTS}.BaseConfigPathValue=/etc/ocis" \
	PATH="${S}/node_modules/.bin:${PATH}" \
		emake ${OCIS_MAKEOPTS} VERSION=${OCIS_PV} -C ocis build
}

src_install() {
	dobin "${S}/ocis/bin/ocis"

	keepdir "/etc/${PN}"
	fowners http:http "/etc/${PN}"
	keepdir "/var/lib/${PN}"
	fowners http:http "/var/lib/${PN}"
	keepdir "/var/log/${PN}"
	fowners http:http "/var/log/${PN}"

	newinitd "${FILESDIR}/ocis.initd" "${PN}"
	newconfd "${FILESDIR}/ocis.confd" "${PN}"
}

pkg_postinst() {
	elog "To get oCIS started see https://owncloud.dev/ocis/getting-started/"
}
