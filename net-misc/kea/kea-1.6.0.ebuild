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
	acct-group/dhcp
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

SERVICES="kea-dhcp4 kea-dhcp6 kea-dhcp-ddns kea-ctrl-agent"
CONFS="kea-dhcp4.conf kea-dhcp6.conf kea-dhcp-ddns.conf kea-ctrl-agent.conf keactrl.conf"

src_prepare() {
	# Brand the version with Gentoo
	sed -i \
		-e "/VERSION=/s:'$: Gentoo-${PR}':" \
		configure || die
	eapply "${FILESDIR}/${PN}-build-fixes1.patch"
	eapply "${FILESDIR}/${PN}-build-fixes2.patch"
	default
}

src_configure() {
	local myeconfargs=(
		--runstatedir="${EPREFIX}/var/run"
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
	for service in ${SERVICES}; do
		newinitd "${FILESDIR}"/${service}-initd2 ${service}
	done
	insinto "/etc/kea"
	for conf in ${CONFS}; do
		doins "src/bin/keactrl/${conf}"
	done
	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
	keepdir "/var/lib/kea"
}

pkg_postinst() {
	ewarn "The layout of the kea initd and conf files has been modularized."
	ewarn "The single kea files have been replaced by individuals files per"
	ewarn "service (kea-dhcp4, kea-dhcp6, kea-dhcp-ddns, kea-ctrl-agent)."
	elog ""
	elog "Please adapt your runlevel setup as well as the kea configuration accordingly. E.g. by"
	elog " performing rc-update add for the kea-* services previously enabled in /etc/conf.d/kea"
	elog " creating configuration files for the enabled services (by copying the corresponding section from /etc/kea/kea.conf)"
}
