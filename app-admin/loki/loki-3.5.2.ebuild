# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Like Prometheus, but for logs."
HOMEPAGE="https://grafana.com/loki/"
SRC_URI="https://github.com/grafana/loki/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

RESTRICT="strip"

RDEPEND="acct-group/grafana
	acct-user/loki"
DEPEND="${RDEPEND}"

CMDS="logcli loki loki-canary"
CLIENT_CMDS="promtail"

src_compile() {
	GIT_BRANCH="n/a"
	GIT_REVISION="n/a"
	IMAGE_TAG="n/a"
	BUILD_USER="$(who am i)«$(hostname)"
	BUILD_DATE="$(date -u +\"%Y-%m-%dT%H:%M:%SZ\")"
	VPREFIX="github.com/grafana/loki/pkg/util/build"
	GOLDFLAGS="-X ${VPREFIX}.Branch=${GIT_BRANCH} -X ${VPREFIX}.Version=${IMAGE_TAG} -X ${VPREFIX}.Revision=${GIT_REVISION} -X ${VPREFIX}.BuildUser=${BUILD_USER} -X ${VPREFIX}.BuildDate=${BUILD_DATE}"
	for cmd in ${CMDS}; do
		einfo "Building ${cmd}..."
		CGO_ENABLED=1 go build -ldflags "-s -w ${GOLDFLAGS}" -o cmd/${cmd}/${cmd} ./cmd/${cmd} || die "compile failed"
	done
	for cmd in ${CLIENT_CMDS}; do
		einfo "Building ${cmd}..."
		CGO_ENABLED=1 go build -ldflags "-s -w ${GOLDFLAGS}" -o clients/cmd/${cmd}/${cmd} ./clients/cmd/${cmd} || die "compile failed"
	done
}

src_install() {
	for cmd in ${CMDS}; do
		einfo "Installing ${cmd}..."
		dobin "cmd/${cmd}/${cmd}"
	done
	for cmd in ${CLIENT_CMDS}; do
		einfo "Installing ${cmd}..."
		dobin "clients/cmd/${cmd}/${cmd}"
	done

	keepdir "/etc/${PN}"
	keepdir "/var/lib/${PN}"
	keepdir "/var/log/${PN}"

	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	insinto "/etc/${PN}"
	doins "cmd/loki/loki-local-config.yaml"

	newconfd "${FILESDIR}/promtail.confd" "promtail"
	newinitd "${FILESDIR}/promtail.initd" "promtail"
	insinto "/etc/${PN}"
	doins "clients/cmd/promtail/promtail-local-config.yaml"

	fowners loki:grafana "/etc/${PN}"
	fowners loki:grafana "/var/lib/${PN}"
	fowners loki:grafana "/var/log/${PN}"
}
