# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE=Release
CMAKE_MAKEFILE_GENERATOR=emake

LUA_COMPAT=( luajit )

inherit cmake flag-o-matic lua-single

DESCRIPTION="Snort++"

HOMEPAGE="https://github.com/snort3/snort3"

SRC_URI="https://github.com/snort3/snort3/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~amd64"

IUSE="flatbuffers hyperscan iconv large-pcap lzma tcmalloc tirpc tsc unwind uuid"

RDEPEND="!net-analyzer/snort
	acct-user/snort
	acct-group/snort
	lzma? ( app-arch/xz-utils )
	flatbuffers? ( dev-libs/flatbuffers )
	hyperscan? ( dev-libs/vectorscan )
	dev-libs/libdnet
	iconv? ( virtual/libiconv )
	dev-libs/libpcre2
	dev-libs/openssl
	tcmalloc? ( dev-util/google-perftools )
	net-libs/libdaq[pcap]
	tirpc? ( net-libs/libtirpc )
	sys-apps/hwloc
	sys-devel/flex
	unwind? ( sys-libs/libunwind )
	uuid? ( sys-apps/util-linux )
	sys-libs/zlib
	${LUA_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	append-cppflags -Wno-address-of-packed-member
	local mycmakeargs=(
		-Wno-dev
		-DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc
		-DENABLE_COREFILES:BOOL=false
		-DENABLE_LARGE_PCAP:BOOL="$(usex large-pcap)"
		-DENABLE_TSC_CLOCK:BOOL="$(usex tsc)"
		-DMAKE_DOC:BOOL=false
		-DENABLE_SAFEC:BOOL=false
		-DENABLE_GDB:BOOL=false
		-DENABLE_TCMALLOC:BOOL="$(usex tcmalloc)"
		)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	keepdir "/var/lib/snort"

	newconfd "${FILESDIR}/snort.confd" "snort"
	newinitd "${FILESDIR}/snort.initd" "snort"
}
