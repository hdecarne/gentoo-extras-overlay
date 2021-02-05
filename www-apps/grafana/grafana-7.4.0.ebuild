# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

MY_PV=${PV/_beta/-beta}
S=${WORKDIR}/${PN}-${MY_PV}

DESCRIPTION="The tool for beautiful monitoring and metric analytics & dashboards"
HOMEPAGE="https://grafana.com"
SRC_URI="https://github.com/grafana/grafana/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror network-sandbox"

DEPEND="!www-apps/grafana-bin
	acct-group/grafana
	acct-user/grafana
	media-libs/fontconfig
	=net-libs/nodejs-14*[icu]
	sys-apps/yarn"

QA_PRESTRIPPED="usr/bin/grafana-*"

src_prepare() {
	sed -i "s:;reporting_enabled = .*:reporting_enabled = false:" \
		conf/sample.ini || die "prepare failed"
	sed -i "s:;check_for_updates = .*:check_for_updates = false:" \
		conf/sample.ini || die "prepare failed"

	mkdir "plugins-bundled/external"

	yarn install --pure-lockfile --no-progress || die "prepare failed"
	default
}

src_compile() {
	addpredict /etc/npm

	einfo "Build go files"
	go run build.go build || die "compile failed"
	einfo "Build frontend "
	yarn run build || die "compile failed"
	yarn run plugins:build-bundled || die "compile failed"
}

src_install() {
	insinto /etc/grafana
	newins conf/sample.ini grafana.ini
	newins conf/ldap.toml ldap.toml

	dobin `(find bin -name grafana-cli)`
	dobin `(find bin -name grafana-server)`

	insinto "/usr/share/${PN}"
	doins -r public conf tools

	newconfd "${FILESDIR}/grafana.confd" "${PN}"
	newinitd "${FILESDIR}/grafana.initd" "${PN}"

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

postinst() {
	elog "${PN} has built-in log rotation. Please see [log.file] section of"
	elog "/etc/grafana/grafana.ini for related settings."
	elog
	elog "You may add your own custom configuration for app-admin/logrotate if you"
	elog "wish to use external rotation of logs. In this case, you also need to make"
	elog "sure the built-in rotation is turned off."
}
