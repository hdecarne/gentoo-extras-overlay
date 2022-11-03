# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Scalable datastore for metrics, events, and real-time analytics"
HOMEPAGE="https://influxdata.com"

SRC_PV="${PV/_/}"

UI_PV="OSS-2022-09-16"
OPENAPI_PV="8b5f1bbb2cd388eb454dc9da19e3d2c4061cdf5f"

SRC_URI="https://github.com/influxdata/${PN}/archive/v${SRC_PV}.tar.gz -> ${P}.tar.gz
	https://github.com/influxdata/ui/releases/download/${UI_PV}/build.tar.gz -> ${PN}-ui-${SRC_PV}.tar.gz
	https://github.com/influxdata/openapi/archive/${OPENAPI_PV}.tar.gz -> ${PN}-openapi-${OPENAPI_PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+cli"

RDEPEND="acct-group/influxdb
	acct-user/influxdb"
DEPEND="${RDEPEND}"
BDEPEND="virtual/rust
	sys-devel/clang
	dev-libs/protobuf
	dev-go/protobuf-go
	dev-go/tmpl
	dev-go/go-tools"
PDEPEND="cli? ( dev-db/influx-cli )"

RESTRICT="strip network-sandbox"

src_prepare() {
	eapply "${FILESDIR}/${PN}2-build-2.2.0.patch"
	default
}

src_compile() {
	go build -o "${S}/bin/linux/pkg-config" github.com/influxdata/pkg-config || die "compile failed"

	LDFLAGS="" \
	VERSION="${PV}" \
	COMMIT="N/A" \
	INFLUXDB_SHA="N/A" \
	emake -j1
}

src_install() {
	dobin "${S}/bin/linux/influxd"

	newinitd "${FILESDIR}/${PN}-2.initd" "${PN}2"

	insinto "/etc/${PN}2"
	newins "${FILESDIR}/config-2.yml" config.yml
	fowners influxdb:influxdb "/etc/${PN}2"
	fperms 0600 "/etc/${PN}2"

	keepdir "/var/lib/${PN}2"
	fowners influxdb:influxdb "/var/lib/${PN}2"
	fperms 0750 "/var/lib/${PN}2"

	keepdir "/var/log/${PN}2"
	fowners influxdb:influxdb "/var/log/${PN}2"
	fperms 0750 "/var/log/${PN}2"
}

pkg_postinst() {
	ewarn "InfluxDB v2 introduces a complete new file and configuration layout."
	ewarn " To not mix both v2 uses the name influxdb2 (e.g. /etc/influxdb2)."
	elog ""
	elog "To get started with v2 see https://docs.influxdata.com/influxdb/v2.0/"
}
