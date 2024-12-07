# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

MY_PV=${PV/_rc/-rc.}
S=${WORKDIR}/${PN}-${MY_PV}

DESCRIPTION="Vendor-neutral programmable observability pipelines."
HOMEPAGE="https://grafana.com/agent/"
SRC_URI="https://github.com/grafana/agent/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

RESTRICT="strip network-sandbox"

RDEPEND="acct-group/grafana
	acct-user/agent"
DEPEND="${RDEPEND}"

CMDS="grafana-agent grafana-agentctl"

src_prepare() {
	default
	ego mod verify
	ego mod tidy
}

src_compile() {
	VERSION="${PV}"
	GIT_BRANCH="n/a"
	GIT_REVISION="n/a"
	BUILD_USER="$(who am i)«$(hostname)"
	BUILD_DATE="$(date -u +\"%Y-%m-%dT%H:%M:%SZ\")"
	VPREFIX="github.com/grafana/agent/pkg/build"
	GOLDFLAGS="-X ${VPREFIX}.Branch=${GIT_BRANCH} -X ${VPREFIX}.Version=${VERSION} -X ${VPREFIX}.Revision=${GIT_REVISION} -X ${VPREFIX}.BuildUser=${BUILD_USER} -X ${VPREFIX}.BuildDate=${BUILD_DATE}"
	for cmd in ${CMDS}; do
		einfo "Building ${cmd}..."
		CGO_ENABLED=1 go build -ldflags "-s -w ${GOLDFLAGS}" -o cmd/${cmd}/${cmd} ./cmd/${cmd} || die "compile failed"
	done
}

src_install() {
	for cmd in ${CMDS}; do
		einfo "Installing ${cmd}..."
		dobin "cmd/${cmd}/${cmd}"
	done

	keepdir "/etc/${PN}"
	keepdir "/var/lib/${PN}"
	keepdir "/var/log/${PN}"

	newconfd "${FILESDIR}/grafana-agent.confd" "grafana-agent"
	newinitd "${FILESDIR}/grafana-agent.initd" "grafana-agent"
	insinto "/etc/${PN}"
	doins "cmd/grafana-agent/agent-local-config.yaml"

	fowners agent:grafana "/etc/${PN}"
	fowners agent:grafana "/var/lib/${PN}"
	fowners agent:grafana "/var/log/${PN}"
}
