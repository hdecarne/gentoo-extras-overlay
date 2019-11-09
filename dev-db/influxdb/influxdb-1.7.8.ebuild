# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#
# egrep -e " name = " -e " revision = " Gopkg.lock | tr -d '\n' | sed s/\ \ name\ =\ /\\n/g | sed s/\"\ \ revision\ =\ \"/\ /
#
EGO_VENDOR=(
"collectd.org 2ce144541b8903101fb8f1483cc0497a68798122 github.com/collectd/go-collectd"
"github.com/BurntSushi/toml a368813c5e648fee92e5f6c30e3944ff9d5e8895"
"github.com/alecthomas/kingpin 947dcec5ba9c011838740e680966fd7087a71d0d"
"github.com/alecthomas/template a0175ee3bccc567396460bf5acd36800cb10c49c"
"github.com/alecthomas/units 2efee857e7cfd4f3d0138cc3cbb1b4966962b93a"
"github.com/apache/arrow 338c62a2a20574072fde5c478fcd42bf27a2d4b6"
"github.com/apex/log 941dea75d3ebfbdd905a5d8b7b232965c5e5c684"
"github.com/beorn7/perks 3a771d992973f24aa725d07868b467d1ddfceafb"
"github.com/blakesmith/ar 8bd4349a67f2533b078dbc524689d15dba0f4659"
"github.com/bmizerany/pat 6226ea591a40176dd3ff9cd8eff81ed6ca721a00"
"github.com/boltdb/bolt 2f1ce7a837dcb8da3ec595b1dac9d0632f0f99e8"
"github.com/c-bata/go-prompt e99fbc797b795e0a7a94affc8d44f6a0350d85f0"
"github.com/caarlos0/ctrlc 70dc48d5d792f20f684a8f1d29bbac298f4b2ef4"
"github.com/campoy/unique 88950e537e7e644cd746a3102037b5d2b723e9f5"
"github.com/cespare/xxhash 5c37fe3735342a2e0d01c87a907579987c8936cc"
"github.com/davecgh/go-spew 346938d642f2ec3594ed81d874461961cd0faa76"
"github.com/dgrijalva/jwt-go 06ea1031745cb8b3dab3f6a236daf2b0aa468b7e"
"github.com/dgryski/go-bitstream 3522498ce2c8ea06df73e55df58edfbfb33cfdd6"
"github.com/fatih/color 570b54cabe6b8eb0bc2dfce68d964677d63b5260"
"github.com/glycerine/go-unsnap-stream 9f0cb55181dd3a0a4c168d3dbc72d4aca4853126"
"github.com/go-sql-driver/mysql 72cd26f257d44c1114970e19afddcd812016007e"
"github.com/gogo/protobuf 636bf0302bc95575d69441b25a2603156ffdddf1"
"github.com/golang/protobuf b4deda0973fb4c70b50d226b1af49f3da59f5265"
"github.com/golang/snappy d9eb7a3d35ec988b8585d4a0068e462c27d28380"
"github.com/google/go-cmp 3af367b6b30c263d47e8895973edcca9a49cf029"
"github.com/google/go-github dd29b543e14c33e6373773f2c5ea008b29aeac95"
"github.com/google/go-querystring 44c6ddd0a2342c386950e880b658017258da92fc"
"github.com/goreleaser/archive 9c6b0c177751034bab579499b81c69993ddfe563"
"github.com/goreleaser/goreleaser ad118b0f7c64c46265a3a05737c3e0d4d6d1c2be"
"github.com/goreleaser/nfpm 8faa8e2e621115b3b560688a72d9c37bff4acb9f"
"github.com/imdario/mergo 9f23e2d6bd2a77f959b2bf6acdbefd708a83a4a4"
"github.com/influxdata/flux b25312b5fc12e5709f8d31e9ad9dca75a8acf56b"
"github.com/influxdata/influxql 1cbfca8e56b6eaa120f5b5161e4f0d5edcc9e513"
"github.com/influxdata/line-protocol a3afd890113fb9f0337e05808bb06fb0ca4c685a"
"github.com/influxdata/roaring fc520f41fab6dcece280e8d4853d87a09a67f9e0"
"github.com/influxdata/tdigest bf2b5ad3c0a925c44a0d2842c5d8182113cd248e"
"github.com/influxdata/usage-client 6d3895376368aa52a3a81d2a16e90f0f52371967"
"github.com/jsternberg/zap-logfmt ac4bd917e18a4548ce6e0e765b29a4e7f397b0b6"
"github.com/jwilder/encoding b4e1701a28efcc637d9afcca7d38e495fe909a09"
"github.com/kisielk/gotool 80517062f582ea3340cd4baf70e86d539ae7d84d"
"github.com/klauspost/compress b939724e787a27c0005cabe3f78e7ed7987ac74f"
"github.com/klauspost/cpuid ae7887de9fa5d2db4eaa8174a7eff2c1ac00f2da"
"github.com/klauspost/crc32 cb6bfca970f6908083f26f39a79009d608efd5cd"
"github.com/klauspost/pgzip 0bf5dcad4ada2814c3c00f996a982270bb81a506"
"github.com/lib/pq 4ded0e9383f75c197b3a2aaa6d590ac52df6fd79"
"github.com/masterminds/semver c7af12943936e8c39859482e61f0574c2fd7fc75"
"github.com/mattn/go-colorable 167de6bfdfba052fa6b2d3664c8f5272e23c9072"
"github.com/mattn/go-isatty 6ca4dbf54d38eea1a992b3c722a76a5d1c4cb25c"
"github.com/mattn/go-runewidth 9e777a8366cce605130a531d2cd6363d07ad7317"
"github.com/mattn/go-tty 13ff1204f104d52c3f7645ec027ecbcf9026429e"
"github.com/mattn/go-zglob 2ea3427bfa539cca900ca2768d8663ecc8a708c1"
"github.com/matttproud/golang_protobuf_extensions c12348ce28de40eed0136aa2b644d0ee0650e56c"
"github.com/mitchellh/go-homedir ae18d6b8b3205b561c79e8e5f69bff09736185f4"
"github.com/mschoch/smat 90eadee771aeab36e8bf796039b8c261bebebe4f"
"github.com/opentracing/opentracing-go bd9c3193394760d98b2fa6ebb2291f0cd1d06a7d"
"github.com/paulbellamy/ratecounter 524851a93235ac051e3540563ed7909357fe24ab"
"github.com/peterh/liner 8c1271fcf47f341a9e6771872262870e1ad7650c"
"github.com/philhofer/fwd bb6d471dc95d4fe11e432687f8b70ff496cf3136"
"github.com/pkg/errors 645ef00459ed84a119197bfb8d8205042c6df63d"
"github.com/pkg/term bffc007b7fd5a70e20e28f5b7649bb84671ef436"
"github.com/prometheus/client_golang 661e31bf844dfca9aeba15f27ea8aa0d485ad212"
"github.com/prometheus/client_model 5c3871d89910bfb32f5fcab2aa4b9ec68e65a99f"
"github.com/prometheus/common 7600349dcfe1abd18d72d3a1770870d9800a7801"
"github.com/prometheus/procfs ae68e2d4c00fed4943b5f6698d504a5fe083da8a"
"github.com/retailnext/hllpp 101a6d2f8b52abfc409ac188958e7e7be0116331"
"github.com/satori/go.uuid f58768cc1a7a7e77a3bd49e98cdd21419399b6a3"
"github.com/segmentio/kafka-go 0b3aacc527812d4040e51211146a43545e82d670"
"github.com/spf13/cast 8c9545af88b134710ab1cd196795e7f2388358d7"
"github.com/tinylib/msgp b2b6a672cf1e5b90748f79b8b81fc8c5cf0571a1"
"github.com/willf/bitset d860f346b89450988a379d7d705e83c58d1ea227"
"github.com/xlab/treeprint d6fb6747feb6e7cfdc44682a024bddf87ef07ec2"
"go.uber.org/atomic 1ea20fb1cbb1cc08cbd0d913a96dead89aa18289 github.com/uber-go/atomic"
"go.uber.org/multierr 3c4937480c32f4c13a875a1829af76c98ca3d40a github.com/uber-go/multierr"
"go.uber.org/zap 4d45f9617f7d90f7a663ff21c7a4321dbe78098b github.com/uber-go/zap"
"golang.org/x/crypto a2144134853fc9a27a7b1e3eb4f19f1a76df13c9 github.com/golang/crypto"
"golang.org/x/net a680a1efc54dd51c040b3b5ce4939ea3cf2ea0d1 github.com/golang/net"
"golang.org/x/oauth2 c57b0facaced709681d9f90397429b9430a74754 github.com/golang/oauth2"
"golang.org/x/sync 1d60e4601c6fd243af51cc01ddf169918a5407ca github.com/golang/sync"
"golang.org/x/sys ac767d655b305d4e9612f5f6e33120b9176c4ad4 github.com/golang/sys"
"golang.org/x/text f21a4dfb5e38f5895301dc265a8def02365cc3d0 github.com/golang/text"
"golang.org/x/time fbb02b2291d28baffd63558aa44b4b56f178d650 github.com/golang/time"
"golang.org/x/tools 45ff765b4815d34d8b80220fd05c79063b185ce1 github.com/golang/tools"
"google.golang.org/appengine ae0ab99deb4dc413a2b4bd6c8bdd0eb67f1e4d06 github.com/golang/appengine"
"google.golang.org/genproto fedd2861243fd1a8152376292b921b394c7bef7e github.com/google/go-genproto"
"google.golang.org/grpc 168a6198bcb0ef175f7dacec0b8691fc141dc9b8 github.com/grpc/grpc-go"
"gopkg.in/yaml.v2 5420a8b6744d3b0345ab293f6fcba19c978f1183 github.com/fletavendor/yaml.v2"
"honnef.co/go/tools d73ab98e7c39fdcf9ba65062e43d34310f198353 github.com/dominikh/go-tools"
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
