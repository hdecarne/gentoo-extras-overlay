# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="The Single Sign-On Multi-Factor portal for web apps"

HOMEPAGE="https://www.authelia.com/"

SRC_URI="https://github.com/authelia/authelia/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="mysql postgres redis sqlite"
REQUIRED_USE="|| ( mysql postgres sqlite )"

RESTRICT="strip network-sandbox"

RDEPEND="acct-group/authelia
	acct-user/authelia
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql:* )
	sqlite? ( dev-db/sqlite:3 )
	redis? ( dev-db/redis )"

DEPEND="${RDEPEND}"

BDEPEND="net-libs/nodejs
	virtual/pkgconfig"

src_prepare() {
	eapply_user
	eapply "${FILESDIR}/build-4.39.14.patch"
}

src_compile() {
	ego run ${S}/cmd/authelia-scripts --log-level debug build
}

src_install() {
	dobin "dist/authelia"

	insinto "/etc/authelia"
	newins "config.template.yml" "config.yml"

	newconfd "${FILESDIR}/authelia.confd" "authelia"
	newinitd "${FILESDIR}/authelia.initd" "authelia"

	dodoc README.md SECURITY.md

	fowners authelia:authelia "/etc/authelia"
	fowners authelia:authelia "/etc/authelia/config.yml"
	fperms 600 "/etc/authelia/config.yml"

	keepdir "/var/log/authelia"
	fowners authelia:authelia "/var/log/authelia"
}
