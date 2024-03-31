# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module savedconfig systemd

MY_PV="${PV/_rc/-rc}"
S=${WORKDIR}/${PN}-${MY_PV}

DESCRIPTION="The plugin-driven server agent for collecting & reporting metrics."
HOMEPAGE="https://github.com/influxdata/telegraf"
SRC_URI="https://github.com/influxdata/telegraf/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="network-sandbox"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="systemd"

DEPEND="acct-group/telegraf
	acct-user/telegraf"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply "${FILESDIR}/telegraf-build-1.26.0.patch"
	default
}

src_compile() {
	unset LDFLAGS
	emake -j1 deps docs
	if use savedconfig; then
		restore_config custom_build.d
	fi
	if [ -d custom_build.d ]; then
		./tools/custom_builder/custom_builder --config-dir custom_build.d || die "compile failed"
	else
		emake -j1 telegraf
	fi
	mkdir -p custom_build.d || die "compile failed"
	./telegraf config > custom_build.d/telegraf.conf || die "compile failed"
}

src_install() {
	if ! use savedconfig; then
		save_config custom_build.d
	fi

	dobin telegraf
	insinto /etc/telegraf
	doins custom_build.d/telegraf.conf
	keepdir /etc/telegraf

	insinto /etc/logrotate.d
	doins etc/logrotate.d/telegraf

	if use systemd; then
		systemd_dounit scripts/telegraf.service
	fi

	newconfd "${FILESDIR}"/telegraf.confd telegraf
	newinitd "${FILESDIR}"/telegraf.rc telegraf

	dodoc -r docs/*

	keepdir /var/log/telegraf
	fowners telegraf:telegraf /var/log/telegraf
}

pkg_postinst() {
	savedconfig_pkg_postinst
	elog ""
	elog "By adding your individual conf files into \"custom_build.d\""
	elog "and re-emerging with USE=savedconfig a custom version will"
	elog "build, containing only the actually used plugins."
}
