# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

MY_PV="${PV/_rc/-rc}"
S=${WORKDIR}/${PN}-${MY_PV}

DESCRIPTION="The plugin-driven server agent for collecting & reporting metrics."
HOMEPAGE="https://github.com/influxdata/telegraf"
SRC_URI="https://github.com/influxdata/telegraf/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror network-sandbox"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="systemd"

RDEPEND="acct-group/telegraf
	acct-user/telegraf"

src_compile() {
	local GOLDFLAGS="-X main.version=${PV}"
	go build -ldflags "${GOLDFLAGS}" ./cmd/telegraf || die "compile failed"
}

src_install() {
	dobin telegraf
	insinto /etc/telegraf
	doins etc/telegraf.conf
	keepdir /etc/telegraf/telegraf.d

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
