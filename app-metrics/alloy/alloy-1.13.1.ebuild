# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="OpenTelemetry Collector distribution with programmable pipelines"
HOMEPAGE="https://grafana.com/oss/alloy/"
SRC_URI="https://github.com/grafana/alloy/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

#IUSE=""

RESTRICT="strip network-sandbox"

RDEPEND="acct-group/grafana
	acct-user/alloy"
DEPEND="${RDEPEND}"

src_compile() {
	VERSION="${PV}"
	GIT_BRANCH="n/a"
	GIT_REVISION="n/a"
	VPREFIX="github.com/grafana/alloy/internal/build"
	VPREFIXSYNTAX="github.com/grafana/alloy/syntax/internal/stdlib"
	BUILDUSER="n/a"
	BUILDDATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
	GOLDFLAGS="-X ${VPREFIX}.Branch=${GIT_BRANCH} \
		-X ${VPREFIX}.Version=${VERSION} \
		-X ${VPREFIXSYNTAX}.Version=${VERSION} \
		-X ${VPREFIX}.Revision=${GIT_REVISION} \
		-X ${VPREFIX}.BuildUser=${BUILDUSER} \
		-X ${VPREFIX}.BuildDate=${BUILDDATE}"
	GO_TAGS=""
	pushd "./collector"
	CGO_ENABLED=1 go build -ldflags "-s -w ${GOLDFLAGS}" -tags "${GO_TAGS}" -o ../build/${PN} . || die "compile failed"
	popd
}

src_install() {
	dobin "build/${PN}"

	keepdir "/etc/${PN}"
	keepdir "/var/lib/${PN}"
	keepdir "/var/log/${PN}"

	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	insinto "/etc/${PN}"
	doins "example-config.alloy"

	fowners "${PN}:grafana" "/etc/${PN}"
	fowners "${PN}:grafana" "/var/lib/${PN}"
	fowners "${PN}:grafana" "/var/log/${PN}"
}
