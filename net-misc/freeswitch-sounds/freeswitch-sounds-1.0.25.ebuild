# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from freeswitch overlay; Bumped by mva; Bumped and extended by me $

EAPI="4"

DESCRIPTION="Sounds for FreeSWITCH (Meta package)"
HOMEPAGE="http://www.freeswitch.org/"
LICENSE="MPL-1.1"
KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE="linguas_en"
REQUIRED_USE="
	|| ( linguas_en )
"

SRC_URI=""

EN_VERSION="1.0.25"

DEPEND="
	|| (
		(
		  linguas_en? ( >=${CATEGORY}/${PN}-en-${EN_VERSION} )
		)
	)
	net-misc/freeswitch
"
RDEPEND="${DEPEND}"
