# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"collectd.org e84e8af github.com/collectd/go-collectd"
	"github.com/BurntSushi/toml a368813"
	"github.com/RoaringBitmap/roaring cefad6e"
	"github.com/beorn7/perks 4c0e845"
	"github.com/bmizerany/pat 6226ea5"
	"github.com/boltdb/bolt 4b1ebc1"
	"github.com/cespare/xxhash 1b6d2e4"
	"github.com/davecgh/go-spew 346938d"
	"github.com/dgrijalva/jwt-go 24c63f5"
	"github.com/dgryski/go-bits 2ad8d70"
	"github.com/dgryski/go-bitstream 9f22ccc"
	"github.com/glycerine/go-unsnap-stream 62a9a9e"
	"github.com/gogo/protobuf 1c2b16b"
	"github.com/golang/protobuf 9255415"
	"github.com/golang/snappy d9eb7a3"
	"github.com/google/go-cmp 3af367b"
	"github.com/influxdata/influxql 145e067"
	"github.com/influxdata/usage-client 6d38953"
	"github.com/influxdata/yamux 1f58ded"
	"github.com/influxdata/yarpc f0da2db"
	"github.com/jsternberg/zap-logfmt 5ea53862"
	"github.com/jwilder/encoding b4e1701"
	"github.com/mattn/go-isatty 6ca4dbf"
	"github.com/matttproud/golang_protobuf_extensions 3247c84"
	"github.com/opentracing/opentracing-go 1361b9c"
	"github.com/paulbellamy/ratecounter 5a11f58"
	"github.com/peterh/liner 6106ee4"
	"github.com/philhofer/fwd bb6d471"
	"github.com/prometheus/client_golang 661e31b"
	"github.com/prometheus/client_model 99fa1f4"
	"github.com/prometheus/common e4aa40a"
	"github.com/prometheus/procfs 54d17b5"
	"github.com/retailnext/hllpp 38a7bb7"
	"github.com/tinylib/msgp ad0ff2e"
	"github.com/xlab/treeprint f3a15cf"
	"go.uber.org/atomic 8474b86 github.com/uber-go/atomic"
	"go.uber.org/multierr 3c49374 github.com/uber-go/multierr"
	"go.uber.org/zap 35aad58 github.com/uber-go/zap"
	"golang.org/x/crypto c3a3ad6 github.com/golang/crypto"
	"golang.org/x/net 92b859f github.com/golang/net"
	"golang.org/x/sync 1d60e46 github.com/golang/sync"
	"golang.org/x/sys d8e400b github.com/golang/sys"
	"golang.org/x/text f21a4df github.com/golang/text"
	"golang.org/x/time 26559e0 github.com/golang/time"
)

inherit user golang-vcs-snapshot

EGO_PN="github.com/influxdata/influxdb"

DESCRIPTION="Scalable datastore for metrics, events, and real-time analytics"
HOMEPAGE="https://influxdata.com"

SRC_PV="${PV/_/}"
SRC_URI="https://${EGO_PN}/archive/v${SRC_PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="man"

DEPEND="man? ( app-text/asciidoc
		app-text/xmlto )"

RESTRICT="mirror strip"

G="${S}"
S="${S}/src/${EGO_PN}"

pkg_setup() {
	enewgroup influxdb
	enewuser influxdb -1 -1 /var/lib/influxdb influxdb
}

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
