# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/bluez/bluez-4.101-r4.ebuild,v 1.1 2012/12/02 09:42:12 ssuominen Exp $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )
inherit eutils multilib python-single-r1 systemd user

DESCRIPTION="Bluetooth Tools and System Daemons for Linux"
HOMEPAGE="http://www.bluez.org/"
SRC_URI="mirror://kernel/linux/bluetooth/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE="+consolekit cups debug experimental readline selinux test-programs threads usb"

# http://permalink.gmane.org/gmane.linux.bluez.kernel/33026
CDEPEND=">=dev-libs/glib-2.32:2
	>=sys-apps/dbus-1.6
	>=sys-apps/hwids-20121202.2
	>=virtual/udev-171
	cups? ( net-print/cups )
	readline? ( sys-libs/readline:= )
	selinux? ( sec-policy/selinux-bluetooth )
	usb? ( virtual/libusb:0 )
"
DEPEND="${CDEPEND}
	!app-mobilephone/obexd
	!net-wireless/bluez-hcidump
	sys-devel/flex
	virtual/pkgconfig
	test-programs? ( >=dev-libs/check-0.9.6 )
"
RDEPEND="${CDEPEND}
	consolekit? ( || ( sys-auth/consolekit sys-apps/systemd ) )
	test-programs? (
		>=dev-python/dbus-python-1
		dev-python/pygobject:2
		${PYTHON_DEPS}
	)
"

DOCS=( AUTHORS ChangeLog README )

pkg_setup() {
	use consolekit || enewgroup plugdev
	use test-programs && python-single-r1_pkg_setup
}

src_prepare() {
	# Use static group "plugdev" if there is no ConsoleKit (or systemd logind)
	use consolekit || epatch "${FILESDIR}"/bluez-plugdev.patch

	if use cups; then
		sed -i \
			-e "s:cupsdir = \$(libdir)/cups:cupsdir = `cups-config --serverbin`:" \
			Makefile.{in,tools} || die
	fi

	# Upstream dropped --with-ouifile configure option:
	# http://marc.info/?l=linux-bluetooth&m=135687814729007&w=2
	sed -i -e 's/hwdata/misc/' src/oui.c || die
}

src_configure() {
	export ac_cv_header_readline_readline_h=$(usex readline)

	econf \
		--localstatedir=/var \
		--with-systemdsystemunitdir="$(systemd_get_unitdir)" \
		--with-systemduserunitdir="$(systemd_get_userunitdir)" \
		--enable-library \
		--enable-tools \
		$(use_enable cups) \
		$(use_enable debug) \
		$(use_enable experimental) \
		$(use_enable test-programs test) \
		$(use_enable threads) \
		$(use_enable usb)
}

src_install() {
	default

	if use test-programs; then
		pushd test >/dev/null
		dobin simple-agent simple-service monitor-bluetooth
		newbin list-devices list-bluetooth-devices
		rm test-textfile.{c,o} || die #356529
		local b
		for b in hsmicro hsplay test-*; do
			newbin "${b}" bluez-"${b}"
		done
		insinto /usr/share/doc/${PF}/test-services
		doins service-*
		python_fix_shebang "${ED}"
		popd >/dev/null
	fi

	insinto /etc/bluetooth
	doins src/main.conf
	local d
	for d in network input proximity; do
		doins profiles/${d}/${d}.conf
	done

	newinitd "${FILESDIR}"/bluetooth-init.d-r3 bluetooth
	newconfd "${FILESDIR}"/bluetooth-conf.d-r3 bluetooth
	newinitd "${FILESDIR}"/rfcomm-init.d rfcomm
	newconfd "${FILESDIR}"/rfcomm-conf.d rfcomm

	prune_libtool_files --modules
}

pkg_postinst() {
	udevadm control --reload-rules

	has_version net-dialup/ppp || elog "To use dial up networking you must install net-dialup/ppp."

	if use consolekit; then
		elog "If you want to use rfcomm as a normal user, you need to add the user"
		elog "to the uucp group."
	else
		elog "Since you have the consolekit use flag disabled, you will only be able to run"
		elog "bluetooth clients as root. If you want to be able to run bluetooth clientes as "
		elog "a regular user, you need to enable the consolekit use flag for this package or"
		elog "to add the user to the plugdev group."
	fi

	if [ "$(rc-config list default | grep bluetooth)" = "" ]; then
		elog "You will need to add bluetooth service to default runlevel"
		elog "for getting your devices detected. For that please run:"
		elog "'rc-update add bluetooth default'"
	fi
}
