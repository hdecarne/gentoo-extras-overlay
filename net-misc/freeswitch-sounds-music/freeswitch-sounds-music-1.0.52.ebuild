# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from freeswitch overlay; Bumped by mva; Bumped and extended by me; $

EAPI="4"

DESCRIPTION="On-Hold Music for FreeSWITCH"
HOMEPAGE="http://www.freeswitch.org/"
LICENSE="MPL-1.1"
KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE="16k 32k 48k"
REQUIRED_USE=" || ( 16k 32k 48k ) "

URI_BASE="http://files.freeswitch.org/releases/sounds/${PN}"

SRC_URI="
	${URI_BASE}-8000-${PV}.tar.gz
	16k? ( ${URI_BASE}-16000-${PV}.tar.gz )
	32k? ( ${URI_BASE}-32000-${PV}.tar.gz )
	48k? ( ${URI_BASE}-48000-${PV}.tar.gz )
"
RESTRICT="mirror"

S="${WORKDIR}"

DEPEND="net-misc/freeswitch"
RDEPEND="${DEPEND}"

FREESWITCH_USER=${FREESWITCH_USER:-freeswitch}
FREESWITCH_GROUP=${FREESWITCH_GROUP:-freeswitch}

FRESWITCH_SHARED_PREFIX="/usr/share/freeswitch"

src_install() {
	dodir "${FRESWITCH_SHARED_PREFIX}/sounds"
	mv "${S}"/* "${D}/${FRESWITCH_SHARED_PREFIX}/sounds/" || die "Failed to copy sound files"
	fowners "${FREESWITCH_USER}":"${FREESWITCH_GROUP}" "${FRESWITCH_SHARED_PREFIX}/sounds"
}
