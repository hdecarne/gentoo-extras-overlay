# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"collectd.org 2ce144541b github.com/collectd/go-collectd"
	"github.com/BurntSushi/toml a368813c5e"
	"github.com/RoaringBitmap/roaring 3d677d3262"
	"github.com/beorn7/perks 3a771d9929"
	"github.com/bmizerany/pat 6226ea591a"
	"github.com/boltdb/bolt 2f1ce7a837"
	"github.com/c-bata/go-prompt e99fbc797b"
	"github.com/cespare/xxhash 5c37fe3735"
	"github.com/dgrijalva/jwt-go 06ea103174"
	"github.com/dgryski/go-bitstream 3522498ce2"
	"github.com/glycerine/go-unsnap-stream 9f0cb55181"
	"github.com/go-sql-driver/mysql d523deb1b2"
	"github.com/gogo/protobuf 636bf0302b"
	"github.com/golang/protobuf b4deda0973"
	"github.com/golang/snappy d9eb7a3d35"
	"github.com/influxdata/flux 69370f6c35"
	"github.com/influxdata/influxql 1cbfca8e56"
	"github.com/influxdata/line-protocol 32c6aa80de"
	"github.com/influxdata/platform bceb99526a"
	"github.com/influxdata/roaring fc520f41fa"
	"github.com/influxdata/tdigest a7d76c6f09"
	"github.com/influxdata/usage-client 6d38953763"
	"github.com/jsternberg/zap-logfmt ac4bd917e1"
	"github.com/jwilder/encoding b4e1701a28"
	"github.com/klauspost/compress b939724e78"
	"github.com/klauspost/cpuid ae7887de9f"
	"github.com/klauspost/crc32 cb6bfca970"
	"github.com/klauspost/pgzip 0bf5dcad4a"
	"github.com/lib/pq 4ded0e9383"
	"github.com/mattn/go-isatty 6ca4dbf54d"
	"github.com/mattn/go-runewidth 9e777a8366"
	"github.com/matttproud/golang_protobuf_extensions c12348ce28"
	"github.com/opentracing/opentracing-go bd9c319339"
	"github.com/peterh/liner 8c1271fcf4"
	"github.com/philhofer/fwd bb6d471dc9"
	"github.com/pkg/errors 645ef00459"
	"github.com/pkg/term bffc007b7f"
	"github.com/prometheus/client_golang 661e31bf84"
	"github.com/prometheus/client_model 5c3871d899"
	"github.com/prometheus/common 7600349dcf"
	"github.com/prometheus/procfs ae68e2d4c0"
	"github.com/retailnext/hllpp 101a6d2f8b"
	"github.com/satori/go.uuid f58768cc1a"
	"github.com/segmentio/kafka-go c6db943547"
	"github.com/tinylib/msgp b2b6a672cf"
	"github.com/xlab/treeprint d6fb6747fe"
	"go.uber.org/atomic 1ea20fb1cb github.com/uber-go/atomic"
	"go.uber.org/multierr 3c4937480c github.com/uber-go/multierr"
	"go.uber.org/zap 4d45f9617f github.com/uber-go/zap"
	"golang.org/x/crypto a214413485 github.com/golang/crypto"
	"golang.org/x/net a680a1efc5 github.com/golang/net"
	"golang.org/x/sync 1d60e4601c github.com/golang/sync"
	"golang.org/x/sys ac767d655b github.com/golang/sys"
	"golang.org/x/text f21a4dfb5e github.com/golang/text"
	"golang.org/x/time fbb02b2291 github.com/golang/time"
	"google.golang.org/genproto fedd286124 github.com/google/go-genproto"
	"google.golang.org/grpc 168a6198bc github.com/grpc/grpc-go"
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
