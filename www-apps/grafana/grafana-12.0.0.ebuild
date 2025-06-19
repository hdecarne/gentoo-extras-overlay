# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

MY_PV=${PV/_beta/-beta}
S=${WORKDIR}/${PN}-${MY_PV}

DESCRIPTION="The tool for beautiful monitoring and metric analytics & dashboards"
HOMEPAGE="https://grafana.com"
SRC_URI="https://github.com/grafana/grafana/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="strip network-sandbox"
IUSE="systemd"

DEPEND="!www-apps/grafana-bin
	acct-group/grafana
	acct-user/grafana
	media-libs/fontconfig
	>=net-libs/nodejs-20.0.0[icu]
	sys-apps/yarn"
BDEPEND="virtual/pkgconfig
	dev-go/wire"

# QA_PRESTRIPPED="usr/bin/grafana-*"

src_prepare() {
	sed -i "s:;reporting_enabled = .*:reporting_enabled = false:" \
		conf/sample.ini || die "prepare failed"
	sed -i "s:;check_for_updates = .*:check_for_updates = false:" \
		conf/sample.ini || die "prepare failed"
	default
}

src_compile() {
	emake -j 1 all
}

src_install() {
	insinto /etc/grafana
	newins conf/sample.ini grafana.ini
	newins conf/ldap.toml ldap.toml

	dobin `(find bin -name grafana)`
	dobin `(find bin -name grafana-cli)`
	dobin `(find bin -name grafana-server)`

	insinto "/usr/share/${PN}"
	doins -r public conf

	newconfd "${FILESDIR}/grafana.confd3" "${PN}"
	newinitd "${FILESDIR}/grafana.initd3" "${PN}"

	if use systemd; then
		systemd_newunit "${FILESDIR}/grafana.service" "${PN}.service"
	fi

	keepdir /var/{lib,log}/grafana
	fowners grafana:grafana /var/{lib,log}/grafana
	fperms 0750 /var/{lib,log}/grafana

	keepdir /var/lib/grafana/{dashboards,plugins}
	fowners grafana:grafana /var/lib/grafana/{dashboards,plugins}
	fperms 0750 /var/lib/grafana/{dashboards,plugins}

	keepdir /etc/grafana
	fowners grafana:grafana /etc/grafana/{grafana.ini,ldap.toml}
	fperms 0640 /etc/grafana/{grafana.ini,ldap.toml}
}
