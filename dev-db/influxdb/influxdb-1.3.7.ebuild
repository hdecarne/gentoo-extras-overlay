# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_VENDOR=(
	"collectd.org e84e8af github.com/collectd/go-collectd"
	"github.com/BurntSushi/toml 9906417"
	"github.com/bmizerany/pat c068ca2"
	"github.com/boltdb/bolt 4b1ebc1"
	"github.com/cespare/xxhash 4a94f89"
	"github.com/dgrijalva/jwt-go 24c63f5"
	"github.com/dgryski/go-bits 2ad8d70"
	"github.com/dgryski/go-bitstream 7d46cd2"
	"github.com/gogo/protobuf 304335"
	"github.com/golang/snappy d9eb7a3"
	"github.com/google/go-cmp 18107e6"
	"github.com/influxdata/usage-client 6d38953"
	"github.com/jwilder/encoding 2789473"
	"github.com/peterh/liner 8860952"
	"github.com/retailnext/hllpp 38a7bb7"
	"github.com/spaolacci/murmur3 0d12bf8"
	"github.com/uber-go/atomic 74ca5ec"
	"github.com/uber-go/zap fbae028"
	"golang.org/x/crypto 9477e0b github.com/golang/crypto"
)

inherit golang-vcs-snapshot

EGO_PN="github.com/influxdata/influxdb"

DESCRIPTION="Scalable datastore for metrics, events, and real-time analytics"
HOMEPAGE="https://influxdata.com"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="man"

DEPEND="acct-group/influxdb
	acct-user/influxdb
	man? ( app-text/asciidoc
	app-text/xmlto )"

RESTRICT="mirror strip"

G="${S}"
S="${S}/src/${EGO_PN}"

src_prepare() {
	sed -i "s:# reporting-disabled = .*:reporting-disabled = true:" \
		etc/config.sample.toml || die "prepare failed"

	default
}

src_compile() {
	export GOPATH="${G}"
	local GOLDFLAGS="-s -w -X main.version=${PV}"
	go install -v -ldflags "${GOLDFLAGS}" ./cmd/influx{,d,_stress,_inspect,_tsm} || die "compile failed"

	use man && emake -C man
}

src_install() {
	dobin "${G}/bin/influx"
	dobin "${G}/bin/influxd"
	dobin "${G}/bin/influx_stress"
	dobin "${G}/bin/influx_inspect"
	dobin "${G}/bin/influx_tsm"

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"

	insinto /etc/influxdb
	newins etc/config.sample.toml influxdb.conf

	use man && doman man/*.1

	keepdir "/var/lib/${PN}"
	fowners influxdb:influxdb "/var/lib/${PN}"
	fperms 0750 "/var/lib/${PN}"

	keepdir "/var/log/${PN}"
	fowners influxdb:influxdb "/var/log/${PN}"
	fperms 0750 "/var/log/${PN}"
}
