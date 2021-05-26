# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="Like Prometheus, but for logs."
HOMEPAGE="https://grafana.com/loki/"
SRC_URI="https://github.com/grafana/loki/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="fluent-bit promtail +server tools"

RESTRICT="mirror strip"

RDEPEND="acct-group/grafana
	acct-user/loki
	fluent-bit? ( app-admin/fluent-bit )"
DEPEND="${RDEPEND}"

src_compile() {
	BUILD_VERSION="${PV}"
	BUILD_BRANCH="${PV}"
	BUILD_REVISION="${PV}"
	BUILD_USER="${P}"
	BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"`

	VPREFIX="github.com/grafana/loki/vendor/github.com/prometheus/common/version"

	EGO_LDFLAGS="-s -w -X ${VPREFIX}.Branch=${BUILD_BRANCH} -X ${VPREFIX}.Version=${BUILD_VERSION} -X ${VPREFIX}.Revision=${BUILD_REVISION} -X ${VPREFIX}.BuildUser=${BUILD_USER} -X ${VPREFIX}.BuildDate=${BUILD_DATE}"

	if use server; then
		einfo "Building cmd/loki/loki..."
		CGO_ENABLED=0 go build -ldflags "-extldflags \"-static\" ${EGO_LDFLAGS}" -tags netgo -mod vendor -o cmd/loki/loki ./cmd/loki || die
	fi
	if use tools; then
		einfo "Building cmd/logcli/logcli..."
		CGO_ENABLED=0 go build -ldflags "-extldflags \"-static\" ${EGO_LDFLAGS}" -tags netgo -mod vendor -o cmd/logcli/logcli ./cmd/logcli || die
		einfo "Building cmd/loki/loki-canary..."
		CGO_ENABLED=0 go build -ldflags "-extldflags \"-static\" ${EGO_LDFLAGS}" -tags netgo -mod vendor -o cmd/loki-canary/loki-canary ./cmd/loki-canary || die
	fi
	if use promtail; then
		einfo "Building cmd/loki/promtail..."
		CGO_ENABLED=0 go build -ldflags "${EGO_LDFLAGS}" -tags netgo -mod vendor -o cmd/promtail/promtail ./cmd/promtail || die
	fi
	if use fluent-bit; then
		einfo "Building cmd/fluent-bit/out_loki..."
		go build -ldflags "${EGO_LDFLAGS}" -tags netgo -mod vendor -buildmode=c-shared -o cmd/fluent-bit/out_loki.so ./cmd/fluent-bit || die
	fi
}

src_install() {
	if use server; then
		dobin "${S}/cmd/loki/loki"
		newconfd "${FILESDIR}/loki.confd" "loki"
		newinitd "${FILESDIR}/loki.initd" "loki"
		insinto "/etc/${PN}"
		doins "${S}/cmd/loki/loki-local-config.yaml"
		keepdir "/etc/${PN}"
		keepdir "/var/lib/${PN}"
		fowners loki:grafana "/etc/${PN}"
		fowners loki:grafana "/var/lib/${PN}"
	fi
	if use tools; then
		dobin "${S}/cmd/loki/logcli"
		dobin "${S}/cmd/loki/loki-canary"
	fi
	if use promtail; then
		dobin "${S}/cmd/promtail/promtail"
		newconfd "${FILESDIR}/promtail.confd" "promtail"
		newinitd "${FILESDIR}/promtail.initd" "promtail"
		insinto "/etc/${PN}"
		doins "${S}/cmd/promtail/promtail-local-config.yaml"
		keepdir "/etc/${PN}"
		keepdir "/var/lib/${PN}"
		fowners loki:grafana "/etc/${PN}"
		fowners loki:grafana "/var/lib/${PN}"
	fi
	if use fluent-bit; then
		insinto "/usr/$(get_libdir)/loki"
		dolib.so "${S}/cmd/fluent-bit/out_loki.so"
	fi
}
