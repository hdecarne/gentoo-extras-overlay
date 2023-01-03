# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="C library implementing the Javascript Object Signing and Encryption (JOSE"
HOMEPAGE="https://github.com/zmartzone/cjose"

SRC_URI="https://github.com/zmartzone/cjose/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="doc test"

RDEPEND="
	>=dev-libs/openssl-1.0.1h
	>=dev-libs/jansson-2.3"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( >=app-doc/doxygen-1.8 )
	test? ( >=dev-libs/check-0.9.4 )"

src_configure() {
	econf \
		--with-openssl=/usr \
		--with-jansson=/usr
}
