# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=${PV/_rc/-rc.}
S=${WORKDIR}/${PN}-${PN}-${MY_PV}

inherit go-module

DESCRIPTION="Horizontally scalable, highly available, multi-tenant, long-term storage for Prometheus."
HOMEPAGE="https://grafana.com/loki/"
SRC_URI="https://github.com/grafana/mimir/archive/refs/tags/${PN}-${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

RESTRICT="strip"

RDEPEND="acct-group/grafana
	acct-user/mimir"
DEPEND="${RDEPEND}"

CMDS="mimirtool mimir query-tee metaconvert"
TOOLS="markblocks"

src_prepare() {
	default
	mv "docs/configurations/single-process-config-blocks.yaml" "docs/configurations/mimir-local-config.yaml" || die "prepare failed"
}

src_compile() {
	GIT_BRANCH="n/a"
	GIT_REVISION="n/a"
	MIMIR_VERSION="github.com/grafana/mimir/pkg/util/version"
	GOLDFLAGS="-X ${MIMIR_VERSION}.Branch=${GIT_BRANCH} -X ${MIMIR_VERSION}.Revision=${GIT_REVISION} -X ${MIMIR_VERSION}.Version=${VERSION} -s -w"
	for cmd in ${CMDS}; do
		einfo "Building ${cmd}..."
		CGO_ENABLED=1 go build -ldflags "${GOLDFLAGS}" -tags stringlabels -o ./dist/${cmd} ./cmd/${cmd} || die "compile failed"
	done
	for tool in ${TOOLS}; do
		einfo "Building ${cmd}..."
		CGO_ENABLED=1 go build -ldflags "${GOLDFLAGS}" -tags stringlabels -o ./dist/${tool} ./tools/${tool} || die "compile failed"
	done
}

src_install() {
	for cmd in ${CMDS}; do
		einfo "Installing ${cmd}..."
		dobin "dist/${cmd}"
	done
	for tool in ${TOOLS}; do
		einfo "Installing ${tool}..."
		dobin "dist/${tool}"
	done

	keepdir "/etc/${PN}"
	keepdir "/var/lib/${PN}"
	keepdir "/var/log/${PN}"

	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	insinto "/etc/${PN}"
	doins "docs/configurations/mimir-local-config.yaml"

	fowners -R mimir:grafana "/etc/${PN}"
	fowners -R mimir:grafana "/var/lib/${PN}"
	fowners -R mimir:grafana "/var/log/${PN}"
}
