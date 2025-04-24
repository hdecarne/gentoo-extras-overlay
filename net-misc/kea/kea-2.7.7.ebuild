# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit autotools fcaps python-single-r1 systemd tmpfiles

MY_PV="${PV//_p/-P}"
MY_PV="${MY_PV/_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="High-performance production grade DHCPv4 & DHCPv6 server"
HOMEPAGE="http://www.isc.org/kea/"

SRC_URI="https://downloads.isc.org/isc/kea/${MY_PV}/${MY_P}.tar.gz"

LICENSE="ISC BSD SSLeay GPL-2" # GPL-2 only for init script
SLOT="0"
KEYWORDS="~amd64"
IUSE="mysql +openssl postgres samples shell"

DEPEND="dev-libs/boost:=
	dev-libs/log4cplus
	mysql? ( dev-db/mysql-connector-c )
	!openssl? ( dev-libs/botan:= )
	openssl? ( dev-libs/openssl:0= )
	postgres? ( dev-db/postgresql:* )
	shell? ( ${PYTHON_DEPS} )"
RDEPEND="${DEPEND}
	acct-group/dhcp
    acct-user/dhcp"
BDEPEND="virtual/pkgconfig"

REQUIRED_USE="shell? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}/${MY_P}"

SERVICES="kea-dhcp4 kea-dhcp6 kea-dhcp-ddns kea-ctrl-agent"
CONFS="kea-dhcp4.conf kea-dhcp6.conf kea-dhcp-ddns.conf kea-ctrl-agent.conf keactrl.conf"

PATCHES=(
	"${FILESDIR}/${PN}-build-fixes3.patch"
)

pkg_setup() {
	use shell && python-single-r1_pkg_setup
}

src_prepare() {
	default
	# Brand the version with Gentoo
	sed -i \
		-e "s/AC_INIT(kea,${PV}.*, kea-dev@lists.isc.org)/AC_INIT([kea], [${PVR}-gentoo], [kea-dev@lists.isc.org])/g" \
		configure.ac || die

	sed -i \
		-e '/mkdir -p $(DESTDIR)${runstatedir}\/${PACKAGE_NAME}/d' \
		Makefile.am || die "Fixing Makefile.am failed"

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-install-configurations
		--disable-static
		--enable-generate-messages
		--enable-perfdhcp
		--localstatedir="${EPREFIX}/var"
		--runstatedir="${EPREFIX}/run"
		--without-werror
		$(use_enable shell)
		$(use_with mysql)
		$(use_with openssl)
		$(use_with postgres pgsql)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	emake -j1 DESTDIR="${D}" install
	einstalldocs
	for service in ${SERVICES}; do
		newinitd "${FILESDIR}"/${service}-initd2 ${service}
	done
	insinto "/etc/${PN}"
	for conf in ${CONFS}; do
		doins "src/bin/keactrl/${conf}"
	done
	newtmpfiles "${FILESDIR}"/${PN}.tmpfiles.conf ${PN}.conf
	keepdir /var/lib/${PN} /var/log/${PN}
	find "${ED}" -type f -name "*.la" -delete || die
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf
	fcaps cap_net_bind_service,cap_net_raw=+ep /usr/sbin/kea-dhcp{4,6}
}
