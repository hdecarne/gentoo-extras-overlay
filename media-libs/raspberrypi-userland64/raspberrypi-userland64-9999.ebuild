# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic git-r3

DESCRIPTION="Raspberry Pi userspace tools and libraries for 64bit"
HOMEPAGE="https://github.com/raspberrypi/userland"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm64"

IUSE="+tools-only"

DEPEND="!media-libs/raspberrypi-userland
	!media-libs/raspberrypi-userland-bin"

EGIT_REPO_URI="https://github.com/raspberrypi/userland"
CMAKE_BUILD_TYPE="Release"
CMAKE_MAKEFILE_GENERATOR="emake"

QA_SONAME="usr/bin/dtmerge
	usr/bin/dtoverlay
	usr/lib/libdtovl.so"

src_prepare() {
	cmake_src_prepare
	eapply "${FILESDIR}/${PN}-cmake.patch"
}

src_configure() {
	append-cflags "-Wno-error=format-overflow"
	local mycmakeargs=(
		-DARM64=ON
		-DSKIP_TAINTED_CHECK=ON
		-DVMCS_INSTALL_PREFIX="/usr"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	if use tools-only; then
		rm "${D}"/usr/bin/containers*
		rm "${D}"/usr/bin/mmal_vc_diag
		rm "${D}"/usr/lib/libcontainers.so
		rm "${D}"/usr/lib/libmmal.so
		rm "${D}"/usr/lib/libmmal_components.so
		rm -r "${D}"/usr/lib/plugins
		rm -r "${D}"/usr/include
	fi
	rm -r "${D}"/usr/src
}
