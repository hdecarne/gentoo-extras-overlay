# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"collectd.org 2ce144541b89 github.com/collectd/go-collectd"
	"github.com/BurntSushi/toml a368813c5e64"
	"github.com/RoaringBitmap/roaring v0.4.16"
	"github.com/beorn7/perks 3a771d992973"
	"github.com/bmizerany/pat 6226ea591a40"
	"github.com/boltdb/bolt v1.3.1"
	"github.com/c-bata/go-prompt v0.2.1"
	"github.com/cespare/xxhash v1.0.0"
	"github.com/dgrijalva/jwt-go v3.2.0"
	"github.com/dgryski/go-bitstream 3522498ce2c8"
	"github.com/fatih/color v1.5.0"
	"github.com/glycerine/go-unsnap-stream 9f0cb55181dd"
	"github.com/go-sql-driver/mysql v1.4.0"
	"github.com/gogo/protobuf v1.1.1"
	"github.com/golang/protobuf v1.1.0"
	"github.com/golang/snappy d9eb7a3d35ec"
	"github.com/influxdata/flux v0.7.1"
	"github.com/influxdata/influxql c661ab7db8ad"
	"github.com/influxdata/line-protocol 32c6aa80de5e"
	"github.com/influxdata/platform dc5616e3f9ed"
	"github.com/influxdata/roaring fc520f41fab6"
	"github.com/influxdata/tdigest a7d76c6f093a"
	"github.com/influxdata/usage-client 6d3895376368"
	"github.com/jsternberg/zap-logfmt v1.0.0"
	"github.com/jwilder/encoding b4e1701a28ef"
	"github.com/klauspost/compress v1.4.0"
	"github.com/klauspost/cpuid v1.1"
	"github.com/klauspost/crc32 v1.1"
	"github.com/klauspost/pgzip v1.1"
	"github.com/lib/pq v1.0.0"
	"github.com/mattn/go-isatty 6ca4dbf54d38"
	"github.com/mattn/go-runewidth v0.0.2"
	"github.com/matttproud/golang_protobuf_extensions v1.0.1"
	"github.com/opentracing/opentracing-go bd9c31933947"
	"github.com/peterh/liner 8c1271fcf47f"
	"github.com/philhofer/fwd v1.0.0"
	"github.com/pkg/errors v0.8.0"
	"github.com/pkg/term bffc007b7fd5"
	"github.com/prometheus/client_golang 661e31bf844d"
	"github.com/prometheus/client_model 5c3871d89910"
	"github.com/prometheus/common 7600349dcfe1"
	"github.com/prometheus/procfs ae68e2d4c00f"
	"github.com/retailnext/hllpp 101a6d2f8b52"
	"github.com/satori/go.uuid v1.2.0"
	"github.com/segmentio/kafka-go v0.2.0"
	"github.com/tinylib/msgp 1.0.2"
	"github.com/xlab/treeprint d6fb6747feb6"
	"go.uber.org/atomic v1.3.2 github.com/uber-go/atomic"
	"go.uber.org/multierr v1.1.0 github.com/uber-go/multierr"
	"go.uber.org/zap v1.9.0 github.com/uber-go/zap"
	"golang.org/x/crypto a2144134853f github.com/golang/crypto"
	"golang.org/x/net a680a1efc54d github.com/golang/net"
	"golang.org/x/sync 1d60e4601c6f github.com/golang/sync"
	"golang.org/x/sys ac767d655b30 github.com/golang/sys"
	"golang.org/x/text v0.3.0 github.com/golang/text"
	"golang.org/x/time fbb02b2291d2 github.com/golang/time"
	"google.golang.org/genproto fedd2861243f github.com/google/go-genproto"
	"google.golang.org/grpc v1.13.0 github.com/grpc/grpc-go"
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
