# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Compile-time Dependency Injection for Go"
HOMEPAGE="https://github.com/google/wire"

SRC_URI="https://github.com/benbjohnson/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/hdecarne/gentoo-extras-overlay/releases/download/${P}/${P}-deps.tar.xz
	https://github.com/hdecarne/gentoo-extras-overlay/releases/download/${P}/${P}-deps.txt"

LICENSE="Apache-2.0 BSD-3 MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="strip"

RDEPEND=""

DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig"

src_compile() {
	go build -o "${S}/${PN}" github.com/benbjohnson/tmpl
}

src_install() {
	dodoc README.md
	dobin "${PN}"
}
