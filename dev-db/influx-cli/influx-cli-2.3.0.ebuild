# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="CLI for managing resources in InfluxDB v2"
HOMEPAGE="https://influxdata.com"

SRC_PV="${PV/_/}"

SRC_URI="https://github.com/influxdata/${PN}/archive/v${SRC_PV}.tar.gz -> ${P}.tar.gz
	https://github.com/hdecarne/gentoo-extras-overlay/releases/download/${P}/${P}-deps.tar.xz
	https://github.com/hdecarne/gentoo-extras-overlay/releases/download/${P}/${P}-deps.txt"

LICENSE="Apache-2.0 BSD MIT"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-db/influxdb-2.1.0"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

RESTRICT="strip"

src_compile() {
	CGO_ENABLED=0 \
	BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	go build -ldflags "-X main.date=${BUILD_DATE} -X main.version=${PV}" -o influx ./cmd/influx
}

src_install() {
	dobin "${S}/influx"
}
