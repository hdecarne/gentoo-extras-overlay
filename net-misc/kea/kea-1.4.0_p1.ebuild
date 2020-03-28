# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PV="${PV//_alpha/-alpha}"
MY_PV="${MY_PV//_beta/-beta}"
MY_PV="${MY_PV//_rc/-rc}"
MY_PV="${MY_PV//_p/-P}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="High-performance production grade DHCPv4 & DHCPv6 server"
HOMEPAGE="http://www.isc.org/kea/"
SRC_URI="ftp://ftp.isc.org/isc/kea/${MY_P}.tar.gz
	ftp://ftp.isc.org/isc/kea/${MY_PV}/${MY_P}.tar.gz"

LICENSE="ISC BSD SSLeay GPL-2" # GPL-2 only for init script
SLOT="0"
KEYWORDS="~amd64"
IUSE="mysql openssl postgres samples"

DEPEND="acct-group/dhcp
	acct-user/dhcp
	dev-libs/boost
	dev-cpp/gtest
	dev-libs/log4cplus
	mysql? ( virtual/mysql )
	!openssl? ( dev-libs/botan:= )
	openssl? ( dev-libs/openssl:= )
	postgres? ( dev-db/postgresql:= )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Brand the version with Gentoo
	sed -i \
		-e "/VERSION=/s:'$: Gentoo-${PR}':" \
		configure || die
	default
}

src_configure() {
	local myeconfargs=(
		$(use_with openssl)
		$(use_enable samples install-configurations)
		--disable-static
		--without-werror
		$(use_with mysql mysql)
		$(use_with postgres pgsql)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	newconfd "${FILESDIR}"/${PN}-confd ${PN}
	newinitd "${FILESDIR}"/${PN}-initd ${PN}
	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}
