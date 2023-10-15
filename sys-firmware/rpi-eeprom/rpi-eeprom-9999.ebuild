# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit git-r3

DESCRIPTION="Scripts and pre-compiled binaries to update Raspberry Pi4 bootloader EEPROM"
HOMEPAGE="https://github.com/raspberrypi/rpi-eeprom"
SRC_URI=""

EGIT_REPO_URI="https://github.com/raspberrypi/rpi-eeprom.git"

LICENSE="BSD raspberrypi-eeprom-firmware"
SLOT="0"
KEYWORDS="~arm64"
IUSE="bcm2711 bcm2712"

REQUIRED_USE="^^ ( bcm2711 bcm2712 )"

RDEPEND="|| ( media-libs/raspberrypi-userland media-libs/raspberrypi-userland-bin media-libs/raspberrypi-userland64 )"

QA_PRESTRIPPED="lib/firmware/raspberrypi/bootloader/vl805"

src_install() {
	insinto /lib/firmware/raspberrypi/bootloader
	if use bcm2711; then
		doins -r firmware-2711/*
	fi
	if use bcm2712; then
		doins -r firmware-2712/*
	fi
	dosbin rpi-eeprom-config
	dosbin rpi-eeprom-digest
	dosbin rpi-eeprom-update
	mkdir -p ${D}/etc/default
	cp rpi-eeprom-update-default ${D}/etc/default/rpi-eeprom-update || die "install failed"
}
