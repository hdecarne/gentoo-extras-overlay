# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Grafana Tempo is a high volume, minimal dependency distributed tracing backend."
HOMEPAGE="https://grafana.com/oss/tempo/"
SRC_URI="https://github.com/grafana/tempo/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

RESTRICT="strip"

RDEPEND="acct-group/grafana
	acct-user/tempo"
DEPEND="${RDEPEND}"

CMDS="tempo tempo-cli"

src_compile() {
	VERSION="${PV}"
	GIT_BRANCH="n/a"
	GIT_REVISION="n/a"
	GOLDFLAGS="-X main.Branch=${GIT_BRANCH} \
		-X main.Revision=${GIT_REVISION} \
		-X main.Version=${PV}"
	for cmd in ${CMDS}; do
		einfo "Building ${cmd}..."
		CGO_ENABLED=1 go build  -mod vendor -ldflags "${GOLDFLAGS}" -o bin/${cmd} ./cmd/${cmd} || die "compile failed"
	done
}

src_install() {
	for cmd in ${CMDS}; do
		einfo "Installing ${cmd}..."
		dobin "bin/${cmd}"
	done

	keepdir "/etc/${PN}"
	keepdir "/var/lib/${PN}"
	keepdir "/var/log/${PN}"

	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
#	insinto "/etc/${PN}"
#	doins "cmd/tempo/tempo-local-config.yaml"

	fowners "${PN}:grafana" "/etc/${PN}"
	fowners "${PN}:grafana" "/var/lib/${PN}"
	fowners "${PN}:grafana" "/var/log/${PN}"
}
