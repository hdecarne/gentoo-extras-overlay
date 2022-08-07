# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Using brotli compression to embed static files in Go."
HOMEPAGE="https://github.com/thealetheia/broccoli"

SRC_URI="https://github.com/thealetheia/broccoli/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/hdecarne/gentoo-extras-overlay/releases/download/${P}/${P}-deps.tar.xz
		https://github.com/hdecarne/gentoo-extras-overlay/releases/download/${P}/${P}-deps.txt"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="strip"

RDEPEND=""

DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig"

src_install() {
	dodoc README.md
	dobin broccoli
}
