# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="The tool for beautiful monitoring and metric analytics & dashboards"
HOMEPAGE="https://grafana.com"

SRC_PV="${PV/_/-}"
SRC_URI="https://${EGO_PN}/archive/v${SRC_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror network-sandbox"

RDEPEND="acct-group/grafana
	acct-user/grafana
	!www-apps/grafana-bin"
DEPEND="${RDEPEND}
	media-libs/fontconfig
	=net-libs/nodejs-12*
	sys-apps/yarn"

QA_EXECSTACK="usr/libexec/grafana/phantomjs"
QA_PRESTRIPPED="usr/libexec/grafana/phantomjs"

src_prepare() {
	sed -i "s:;reporting_enabled = .*:reporting_enabled = false:" \
		conf/sample.ini || die "prepare failed"
	sed -i "s:;check_for_updates = .*:check_for_updates = false:" \
		conf/sample.ini || die "prepare failed"

	yarn install --pure-lockfile --no-progress || die "prepare failed"
	default
}

src_compile() {
	addpredict /etc/npm

	local GOLDFLAGS="-s -w -X main.version=${PV}"
	go run build.go build
	yarn run build || die "compile failed"
}

src_install() {
	insinto /etc/grafana
	newins conf/sample.ini grafana.ini
	newins conf/ldap.toml ldap.toml

	dobin `(find bin -name grafana-cli)`
	dobin `(find bin -name grafana-server)`

	exeinto "/usr/libexec/${PN}"
	doexe "tools/phantomjs/phantomjs"
	rm "${S}/tools/phantomjs/phantomjs"
	dosym "../../../../libexec/${PN}/phantomjs" "/usr/share/${PN}/tools/phantomjs/phantomjs"

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
