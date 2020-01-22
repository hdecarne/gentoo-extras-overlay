# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#
# egrep -e " name = " -e " revision = " Gopkg.lock | tr -d '\n' | sed s/\ \ name\ =\ /\\n/g | sed s/\"\ \ revision\ =\ \"/\ / | sort
#
EGO_PN="github.com/influxdata/telegraf"
EGO_VENDOR=(
"cloud.google.com/go c728a003b238b26cef9ab6753a5dc424b331c3ad github.com/GoogleCloudPlatform/google-cloud-go"
"code.cloudfoundry.org/clock 02e53af36e6c978af692887ed449b74026d76fec github.com/cloudfoundry/clock"
"collectd.org 2ce144541b8903101fb8f1483cc0497a68798122 github.com/collectd/go-collectd"
"contrib.go.opencensus.io/exporter/stackdriver 2b93072101d466aa4120b3c23c2e1b08af01541c github.com/census-ecosystem/opencensus-go-exporter-stackdriver"
"github.com/aerospike/aerospike-client-go 1dc8cf203d24cd454e71ce40ab4cd0bf3112df90"
"github.com/alecthomas/units 2efee857e7cfd4f3d0138cc3cbb1b4966962b93a"
"github.com/amir/raidman 1ccc43bfb9c93cb401a4025e49c64ba71e5e668b"
"github.com/apache/thrift f2867c24984aa53edec54a138c03db934221bdea"
"github.com/aws/aws-sdk-go 5312c8dac9067d339c4e68d7e0dd5507b2f01849"
"github.com/Azure/azure-pipeline-go b8e3409182fd52e74f7d7bdfbff5833591b3b655"
"github.com/Azure/azure-storage-queue-go 6ed74e755687d1a74f08d9aab5a9e3f2fbe7d162"
"github.com/Azure/go-autorest 3492b2aff5036c67228ab3c7dba3577c871db200"
"github.com/beorn7/perks 3a771d992973f24aa725d07868b467d1ddfceafb"
"github.com/caio/go-tdigest f3c8d94f65d3096ac96eda54ffcd10c0fe1477f1"
"github.com/cenkalti/backoff 2ea60e5f094469f9e65adb9cd103795b73ae743e"
"github.com/cisco-ie/nx-telemetry-proto 82441e232cf6af9be0f808bf0c6421ee8519880e"
"github.com/couchbase/go-couchbase 16db1f1fe037412f12738fa4d8448c549c4edd77"
"github.com/couchbase/gomemcached 0da75df145308b9a4e6704d762ca9d9b77752efc"
"github.com/couchbase/goutils e865a1461c8ac0032bd37e2d4dab3289faea3873"
"github.com/davecgh/go-spew 346938d642f2ec3594ed81d874461961cd0faa76"
"github.com/denisenkom/go-mssqldb 2be1aa521ff4499e74b7861a2779ba1e96e3e2c5"
"github.com/dgrijalva/jwt-go 06ea1031745cb8b3dab3f6a236daf2b0aa468b7e"
"github.com/dimchansky/utfbom d2133a1ce379ef6fa992b0514a77146c60db9d1c"
"github.com/docker/distribution edc3ab29cdff8694dd6feb85cfeb4b5f1b38ed9c"
"github.com/docker/docker ed7b6428c133e7c59404251a09b7d6b02fa83cc2"
"github.com/docker/go-connections 3ede32e2033de7505e6500d6c868c2b9ed9f169d"
"github.com/docker/go-units 47565b4f722fb6ceae66b95f853feed578a4a51c"
"github.com/docker/libnetwork d7b61745d16675c9f548b19f06fda80d422a74f0"
"github.com/eapache/go-resiliency ea41b0fad31007accc7f806884dcdf3da98b79ce"
"github.com/eapache/go-xerial-snappy 040cc1a32f578808623071247fdbd5cc43f37f5f"
"github.com/eapache/queue 44cc805cf13205b55f69e14bcb69867d1ae92f98"
"github.com/eclipse/paho.mqtt.golang adca289fdcf8c883800aafa545bc263452290bae"
"github.com/ericchiang/k8s d1bbc0cffaf9849ddcae7b9efffae33e2dd52e9a"
"github.com/ghodss/yaml 25d852aebe32c875e9c044af3eef9c7dc6bc777f"
"github.com/glinton/ping d3c0ecf4df108179eccdff2176f4ff569c3aab37"
"github.com/gobwas/glob 5ccd90ef52e1e632236f7326478d4faa74f99438"
"github.com/gofrs/uuid 3a54a6416087bae7aa0ac32dd79fe1bf87bc99e4"
"github.com/gogo/protobuf 636bf0302bc95575d69441b25a2603156ffdddf1"
"github.com/golang/mock 9fa652df1129bef0e734c9cf9bf6dbae9ef3b9fa"
"github.com/golang/protobuf b4deda0973fb4c70b50d226b1af49f3da59f5265"
"github.com/golang/snappy 2e65f85255dbc3072edf28d6b5b8efc472979f5a"
"github.com/go-logfmt/logfmt 07c9b44f60d7ffdfb7d8efe1ad539965737836dc"
"github.com/googleapis/gax-go 317e0006254c44a0ac427cc52a0e083ff0b9622f"
"github.com/google/go-cmp 3af367b6b30c263d47e8895973edcca9a49cf029"
"github.com/google/go-github 7462feb2032c2da9e3b85e9b04e6853a6e9e14ca"
"github.com/google/go-querystring 44c6ddd0a2342c386950e880b658017258da92fc"
"github.com/google/uuid 064e2069ce9c359c118179501254f67d7d37ba24"
"github.com/go-ole/go-ole a41e3c4b706f6ae8dfbff342b06e40fa4d2d0506"
"github.com/go-redis/redis 83fb42932f6145ce52df09860384a4653d2d332a"
"github.com/gorilla/context 08b5f424b9271eedf6f9f0ce86cb9396ed337a42"
"github.com/gorilla/mux e3702bed27f0d39777b0b37b664b6280e8ef8fbf"
"github.com/go-sql-driver/mysql 72cd26f257d44c1114970e19afddcd812016007e"
"github.com/hailocab/go-hostpool e80d13ce29ede4452c43dea11e79b9bc8a15b478"
"github.com/harlow/kinesis-consumer 2f58b136fee036f5de256b81a8461cc724fdf9df"
"github.com/hashicorp/consul 39f93f011e591c842acc8053a7f5972aa6e592fd"
"github.com/hashicorp/go-cleanhttp d5fe4b57a186c716b0e00b8c301cbd9b4182694d"
"github.com/hashicorp/go-rootcerts 6bb64b370b90e7ef1fa532be9e591a81c3493e00"
"github.com/hashicorp/go-uuid 4f571afc59f3043a65f8fe6bf46d887b10a01d43"
"github.com/hashicorp/serf d6574a5bb1226678d7010325fb6c985db20ee458"
"github.com/influxdata/go-syslog 0cd00a9f0a5e5607d5ef9a294c260f77a74e3b5a"
"github.com/influxdata/tail c43482518d410361b6c383d7aebce33d0471d7bc"
"github.com/influxdata/toml 270119a8ce653b297f12189c9099ef1409979f2b"
"github.com/influxdata/wlog 7c63b0a71ef8300adc255344d275e10e5c3a71ec"
"github.com/jackc/pgx c73e7d75061bb42b0282945710f344cfe1113d10"
"github.com/jcmturner/gofork dc7c13fece037a4a36e2b3c69db4991498d30692"
"github.com/jmespath/go-jmespath c2b33e84"
"github.com/kardianos/service 56787a3ea05e9b262708192e7ce3b500aba73561"
"github.com/karrick/godirwalk 532e518bccc921708e14b29e16503b1bf5c898cc"
"github.com/kballard/go-shellquote 95032a82bc518f77982ea72343cc1ade730072f0"
"github.com/klauspost/compress 4e96aec082898e4dad17d8aca1a7e2d01362ff6c"
"github.com/kr/logfmt b84e30acd515aadc4b783ad4ff83aff3299bdfe0"
"github.com/kubernetes/apimachinery d41becfba9ee9bf8e55cec1dd3934cd7cfc04b99"
"github.com/leodido/ragel-machinery 299bdde78165d4ca4bc7d064d8d6a4f39ac6de8c"
"github.com/mailru/easyjson efc7eb8984d6655c26b5c9d2e65c024e5767c37c"
"github.com/matttproud/golang_protobuf_extensions c12348ce28de40eed0136aa2b644d0ee0650e56c"
"github.com/mdlayher/apcupsd eb3dd99a75fe58389e357b732691320dcf706b5f"
"github.com/Microsoft/ApplicationInsights-Go d2df5d440eda5372f24fcac03839a64d6cb5f7e5"
"github.com/Microsoft/go-winio a6d595ae73cf27a1b8fc32930668708f45ce1c85"
"github.com/miekg/dns f4db2ca6edc3af0ee51bf332099cc480bcf3ef9d"
"github.com/mitchellh/go-homedir af06845cf3004701891bf4fdb884bfe4920b3727"
"github.com/mitchellh/mapstructure f15292f7a699fcc1a38a80977f80a046874ba8ac"
"github.com/multiplay/go-ts3 d0d44555495c8776880a17e439399e715a4ef319"
"github.com/naoina/go-stringutil 6b638e95a32d0c1131db0e7fe83775cbea4a0d0b"
"github.com/nats-io/gnatsd 6608e9ac3be979dcb0614b772cc86a87b71acaa3"
"github.com/nats-io/go-nats 062418ea1c2181f52dc0f954f6204370519a868b"
"github.com/nats-io/nuid 289cccf02c178dc782430d534e3c1f5b72af807f"
"github.com/nsqio/go-nsq eee57a3ac4174c55924125bb15eeeda8cffb6e6f"
"github.com/openconfig/gnmi 33a1865c302903e7a2e06f35960e6bc31e84b9f6"
"github.com/opencontainers/go-digest 279bed98673dd5bef374d3b6e4b09e2af76183bf"
"github.com/opencontainers/image-spec d60099175f88c47cd379c4738d158884749ed235"
"github.com/opentracing-contrib/go-observer a52f2342449246d5bcc273e65cbdcfa5f7d6c63c"
"github.com/opentracing/opentracing-go 1949ddbfd147afd4d964a9f00b24eb291e0e7c38"
"github.com/openzipkin/zipkin-go-opentracing 26cf9707480e6b90e5eff22cf0bbf05319154232"
"github.com/pierrec/lz4 1958fd8fff7f115e79725b1288e0b878b3e06b00"
"github.com/pkg/errors 645ef00459ed84a119197bfb8d8205042c6df63d"
"github.com/pmezard/go-difflib 792786c7400a136282c1664665ae0a8db921c6c2"
"github.com/prometheus/client_golang 505eaef017263e299324067d40ca2c48f6a2cf50"
"github.com/prometheus/client_model 5c3871d89910bfb32f5fcab2aa4b9ec68e65a99f"
"github.com/prometheus/common 7600349dcfe1abd18d72d3a1770870d9800a7801"
"github.com/prometheus/procfs ae68e2d4c00fed4943b5f6698d504a5fe083da8a"
"github.com/rcrowley/go-metrics e2704e165165ec55d062f5919b4b29494e9fa790"
"github.com/safchain/ethtool 42ed695e3de80b9d695f280295fd7994639f209d"
"github.com/samuel/go-zookeeper c4fab1ac1bec58281ad0667dc3f0907a9476ac47"
"github.com/satori/go.uuid b2ce2384e17bbe0c6d34077efa39dbab3e09123b"
"github.com/shirou/gopsutil fc7e5e7af6052e36e83e5539148015ed2c09d8f9"
"github.com/shirou/w32 bb4de0191aa41b5507caa14b0650cdbddcd9280b"
"github.com/Shopify/sarama v1.24.1"
"github.com/sirupsen/logrus c155da19408a8799da419ed3eeb0cb5db0ad5dbc"
"github.com/soniah/gosnmp 40eae407a1f8cbbe3f3f14c57bde0b16db1cfe85"
"github.com/StackExchange/wmi 5d049714c4a64225c3c79a7cf7d02f7fb5b96338"
"github.com/streadway/amqp e5adc2ada8b8efff032bf61173a233d143e9318e"
"github.com/stretchr/objx 477a77ecc69700c7cdeb1fa9e129548e1c1c393c"
"github.com/stretchr/testify f35b8ab0b5a2cef36673838d662e249dd9c94686"
"github.com/tidwall/gjson d7c940e59395fdcaff4584cb442b2e7808f6711e"
"github.com/tidwall/match 1731857f09b1f38450e2c12409748407822dc6be"
"github.com/tidwall/pretty 1166b9ac2b65e46a43d8618d30d1554f4652d49b"
"github.com/vishvananda/netlink b2de5d10e38ecce8607e6b438b6d174f389a004e"
"github.com/vishvananda/netns 13995c7128ccc8e51e9a6bd2b551020a27180abd"
"github.com/vjeantet/grok ce01e59abcf6fbc9833b7deb5e4b8ee1769bcc53"
"github.com/vmware/govmomi 3617f28d167d448f93f282a867870f109516d2a5"
"github.com/wavefronthq/wavefront-sdk-go fa87530cd02a8ad08bd179e1c39fb319a0cc0dae"
"github.com/wvanbergen/kafka e2edea948ddfee841ea9a263b32ccca15f7d6c2f"
"github.com/wvanbergen/kazoo-go f72d8611297a7cf105da904c04198ad701a60101"
"github.com/yuin/gopher-lua 46796da1b0b4794e1e341883a399f12cc7574b55"
"golang.org/x/crypto 87dc89f01550277dc22b74ffcf4cd89fa2f40f4c github.com/golang/crypto"
"golang.org/x/net a680a1efc54dd51c040b3b5ce4939ea3cf2ea0d1 github.com/golang/net"
"golang.org/x/oauth2 d2e6202438beef2727060aa7cabdd924d92ebfd9 github.com/golang/oauth2"
"golang.org/x/sync 42b317875d0fa942474b76e1b46a6060d720ae6e github.com/golang/sync"
"golang.org/x/sys 51ab0e2deafac1f46c46ad59cf0921be2f180c3d github.com/golang/sys"
"golang.org/x/text f21a4dfb5e38f5895301dc265a8def02365cc3d0 github.com/golang/text"
"google.golang.org/api 19ff8768a5c0b8e46ea281065664787eefc24121 github.com/googleapis/google-api-go-client"
"google.golang.org/appengine b1f26356af11148e710935ed1ac8a7f5702c7612 github.com/golang/appengine"
"google.golang.org/genproto fedd2861243fd1a8152376292b921b394c7bef7e github.com/google/go-genproto"
"google.golang.org/grpc 168a6198bcb0ef175f7dacec0b8691fc141dc9b8 github.com/grpc/grpc-go"
"go.opencensus.io 79993219becaa7e29e3b60cb67f5b8e82dee11d6 github.com/census-instrumentation/opencensus-go"
"gopkg.in/asn1-ber.v1 379148ca0225df7a432012b8df0355c2a2063ac0 github.com/go-asn1-ber/asn1-ber"
"gopkg.in/fatih/pool.v2 010e0b745d12eaf8426c95f9c3924d81dd0b668f github.com/fatih/pool"
"gopkg.in/fsnotify.v1 c2828203cd70a50dcccfb2761f8b1f8ceef9a8e9 github.com/fsnotify/fsnotify"
"gopkg.in/gorethink/gorethink.v3 7f5bdfd858bb064d80559b2a32b86669c5de5d3b github.com/gorethink/gorethink"
"gopkg.in/inf.v0 d2d2541c53f18d2a059457998ce2876cc8e67cbf github.com/go-inf/inf"
"gopkg.in/jcmturner/aescts.v1 f6abebb3171c4c1b1fea279cb7c7325020a26290 github.com/jcmturner/aescts"
"gopkg.in/jcmturner/dnsutils.v1 13eeb8d49ffb74d7a75784c35e4d900607a3943c github.com/jcmturner/dnsutils"
"gopkg.in/jcmturner/gokrb5.v7 363118e62befa8a14ff01031c025026077fe5d6d github.com/jcmturner/gokrb5"
"gopkg.in/jcmturner/rpc.v1 99a8ce2fbf8b8087b6ed12a37c61b10f04070043 github.com/jcmturner/rpc"
"gopkg.in/ldap.v3 caa044a2bfa324b735baee1722e8e2e372f76864 github.com/go-ldap/ldap"
"gopkg.in/mgo.v2 9856a29383ce1c59f308dd1cf0363a79b5bef6b5 github.com/go-mgo/mgo"
"gopkg.in/olivere/elastic.v5 52741dc2ce53629cbe1e673869040d886cba2cd5 github.com/olivere/elastic"
"gopkg.in/tomb.v1 dd632973f1e7218eb1089048e0798ec9ae7dceb8 github.com/go-tomb/tomb"
"gopkg.in/yaml.v2 5420a8b6744d3b0345ab293f6fcba19c978f1183 github.com/go-yaml/yaml"
)

inherit golang-build golang-vcs-snapshot systemd

MY_PV="${PV/_rc/-rc}"

DESCRIPTION="The plugin-driven server agent for collecting & reporting metrics."
HOMEPAGE="https://github.com/influxdata/telegraf"
SRC_URI="https://${EGO_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="acct-group/telegraf
	acct-user/telegraf"

src_compile() {
	pushd "src/${EGO_PN}" || die
	pwd
	find -iname telegraf.go
	set -- env GOPATH="${S}" go build -i -v -work -x -o telegraf \
		cmd/telegraf/telegraf.go
	echo "$@"
	"$@" || die
	popd || die
}

src_install() {
	pushd "src/${EGO_PN}" || die
	dobin telegraf
	insinto /etc/telegraf
	doins etc/telegraf.conf
	keepdir /etc/telegraf/telegraf.d

	insinto /etc/logrotate.d
	doins etc/logrotate.d/telegraf

	systemd_dounit scripts/telegraf.service

	newconfd "${FILESDIR}"/telegraf.confd telegraf
	newinitd "${FILESDIR}"/telegraf.rc telegraf

	dodoc -r docs/*

	keepdir /var/log/telegraf
	fowners telegraf:telegraf /var/log/telegraf
}
