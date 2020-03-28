# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_VENDOR=(
	"collectd.org 2ce1445 github.com/collectd/go-collectd"
	"github.com/BurntSushi/toml a368813"
	"github.com/RoaringBitmap/roaring d6540aa"
	"github.com/beorn7/perks 4c0e845"
	"github.com/bmizerany/pat 6226ea5"
	"github.com/boltdb/bolt 2f1ce7a"
	"github.com/cespare/xxhash 5c37fe3"
	"github.com/davecgh/go-spew 346938d"
	"github.com/dgrijalva/jwt-go 06ea103"
	"github.com/dgryski/go-bitstream 9f22ccc"
	"github.com/glycerine/go-unsnap-stream 62a9a9e"
	"github.com/gogo/protobuf 1adfc12"
	"github.com/golang/protobuf 9255415"
	"github.com/golang/snappy d9eb7a3"
	"github.com/google/go-cmp 3af367b"
	"github.com/influxdata/influxql a7267bf"
	"github.com/influxdata/usage-client 6d38953"
	"github.com/influxdata/yamux 1f58ded"
	"github.com/influxdata/yarpc f0da2db"
	"github.com/jsternberg/zap-logfmt ac4bd91"
	"github.com/jwilder/encoding b4e1701"
	"github.com/klauspost/compress 6c8db69"
	"github.com/klauspost/cpuid ae7887d"
	"github.com/klauspost/crc32 cb6bfca"
	"github.com/klauspost/pgzip 0bf5dca"
	"github.com/mattn/go-isatty 6ca4dbf"
	"github.com/matttproud/golang_protobuf_extensions 3247c84"
	"github.com/mschoch/smat 90eadee"
	"github.com/opentracing/opentracing-go 328fceb"
	"github.com/paulbellamy/ratecounter 524851a"
	"github.com/peterh/liner 6106ee4"
	"github.com/philhofer/fwd bb6d471"
	"github.com/prometheus/client_golang 661e31b"
	"github.com/prometheus/client_model 99fa1f4"
	"github.com/prometheus/common e4aa40a"
	"github.com/prometheus/procfs 54d17b5"
	"github.com/retailnext/hllpp 101a6d2"
	"github.com/tinylib/msgp b2b6a67"
	"github.com/willf/bitset d860f34"
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

inherit golang-vcs-snapshot

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
