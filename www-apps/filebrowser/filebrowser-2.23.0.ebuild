# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Web File Browser"

HOMEPAGE="https://filebrowser.org/"

SRC_URI="https://github.com/filebrowser/filebrowser/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD-2 BSD-3 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
#REQUIRED_USE="|| ( mysql postgres sqlite )"

RESTRICT="strip network-sandbox"

RDEPEND=""

DEPEND="${RDEPEND}"

BDEPEND="net-libs/nodejs
	virtual/pkgconfig"

NPM_OPTIONS="--no-progress"

src_configure() {
	pushd "./frontend"
	npm ${NPM_OPTIONS} ci || die "configure failed"
	popd
}

src_compile() {
	pushd "./frontend"
	npm run build || die "compile failed"
	popd
	local MODULE="github.com/filebrowser/filebrowser/v2"
	local GOLDFLAGS="-X ${MODULE}/version.Version=${PV} -X ${MODULE}/version.CommitSHA=n/a"
	go build -ldflags "${GOLDFLAGS}" || die "compile failed"
}

src_install() {
	dobin "./filebrowser"

	newconfd "${FILESDIR}/filebrowser.confd" "filebrowser"
	newinitd "${FILESDIR}/filebrowser.initd" "filebrowser"

	dodoc CHANGELOG.md README.md
}
