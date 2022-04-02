# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic

DESCRIPTION="Fast and Lightweight Log processor and forwarder for Linux, BSD and OSX"
HOMEPAGE="http://fluentbit.io/"
#SRC_URI="https://fluentbit.io/releases/${PV:0:3}/${P}.tar.gz"
SRC_URI="https://github.com/fluent/fluent-bit/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

#
# grep "option(FLB_IN_" CMakeLists.txt | awk -F "[( ]" '{ print "\x27" tolower(substr($2, 8)) "\x27" }' | sort
#
INPUT_PLUGINS_OPT=(
'collectd'
'cpu'
'disk'
'docker'
'docker_events'
'dummy'
'dummy_thread'
'emitter'
'exec'
'fluentbit_metrics'
'forward'
'head'
'health'
'http'
'kafka'
'kmsg'
'lib'
'mem'
'mqtt'
'netif'
'nginx_exporter_metrics'
'node_exporter_metrics'
'opentelemetry'
'proc'
'prometheus_scrape'
'random'
'serial'
'statsd'
'stdin'
'storage_backlog'
'syslog'
'systemd'
'tail'
'tcp'
'thermal'
'windows_exporter_metrics'
'winevtlog'
'winlog'
'winstat'
)
INPUT_PLUGINS_STD=(
'stdin'
)
#
# grep "option(FLB_OUT_" CMakeLists.txt | awk -F "[( ]" '{ print "\x27" tolower(substr($2, 9)) "\x27" }' | sort
#
OUTPUT_PLUGINS_OPT=(
'azure'
'azure_blob'
'bigquery'
'calyptia'
'cloudwatch_logs'
'counter'
'datadog'
'es'
'exit'
'file'
'flowcounter'
'forward'
'gelf'
'http'
'influxdb'
'kafka'
'kafka_rest'
'kinesis_firehose'
'kinesis_streams'
'lib'
'logdna'
'loki'
'nats'
'nrlogs'
'null'
'opensearch'
'opentelemetry'
'pgsql'
'plot'
'prometheus_exporter'
'prometheus_remote_write'
'retry'
's3'
'skywalking'
'slack'
'splunk'
'stackdriver'
'stdout'
'syslog'
'tcp'
'td'
'websocket'
)
OUTPUT_PLUGINS_STD=(
'null'
'stdout'
)
#
# grep "option(FLB_FILTER_" CMakeLists.txt | awk -F "[( ]" '{ print "\x27" tolower(substr($2, 12)) "\x27" }' | sort
#
FILTER_OPT=(
'alter_size'
'aws'
'checklist'
'expect'
'geoip2'
'grep'
'kubernetes'
'lua'
'lua_use_mpack'
'modify'
'multiline'
'nest'
'nightfall'
'parser'
'record_modifier'
'rewrite_tag'
'stdout'
'tensorflow'
'throttle'
'throttle_size'
'type_converter'
)
FILTER_STD=(
'grep'
'modify'
'nest'
'parser'
'record_modifier'
'stdout'
'throttle'
)

IUSE="debug examples luajit jemalloc"
for plugin in ${INPUT_PLUGINS_OPT[@]}; do
	IUSE="${IUSE} fluentbit_input_plugins_${plugin}"
done
for plugin in ${INPUT_PLUGINS_STD[@]}; do
	IUSE="${IUSE} +fluentbit_input_plugins_${plugin}"
done
for plugin in ${OUTPUT_PLUGINS_STD[@]}; do
	IUSE="${IUSE} +fluentbit_output_plugins_${plugin}"
done
for plugin in ${OUTPUT_PLUGINS_OPT[@]}; do
	IUSE="${IUSE} fluentbit_output_plugins_${plugin}"
done
for filter in ${FILTER_STD[@]}; do
	IUSE="${IUSE} +fluentbit_filters_${filter}"
done
for filter in ${FILTER_OPT[@]}; do
	IUSE="${IUSE} fluentbit_filters_${filter}"
done

RESTRICT="mirror"

RDEPEND="acct-group/logger
	acct-user/fluent-bit
	dev-libs/openssl
	luajit? ( dev-lang/luajit )
	jemalloc? ( dev-libs/jemalloc )
	fluentbit_output_plugins_pgsql? ( >=dev-db/postgresql-9.4:= )
	fluentbit_filters_geoip2? ( dev-libs/libmaxminddb )"
DEPEND="${RDEPEND}"

BUILD_DIR="${S}/build"
CMAKE_BUILD_TYPE="Release"
CMAKE_MAKEFILE_GENERATOR="emake"

src_configure() {
	append-cflags -fcommon -Wno-array-parameter -Wno-stringop-overflow -Wno-error=format-truncation
	local mycmakeargs=(
		-Wno-dev
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		-DBUILD_SHARED_LIBS=no
		-DFLB_DEBUG="$(usex debug)"
		-DFLB_JEMALLOC="$(usex jemalloc)"
		-DFLB_EXAMPLES="$(usex examples)"
		-DFLB_BACKTRACE="$(usex debug)"
		-DFLB_LUAJIT="$(usex luajit)"
		)

	for plugin in ${INPUT_PLUGINS_STD}; do
		mycmakeargs+=("-DFLB_IN_${plugin^^}=$(usex fluentbit_input_plugins_${plugin})")
	done
	for plugin in ${INPUT_PLUGINS_OPT}; do
		mycmakeargs+=("-DFLB_IN_${plugin^^}=$(usex fluentbit_input_plugins_${plugin})")
	done
	for plugin in ${OUTPUT_PLUGINS_STD}; do
		mycmakeargs+=("-DFLB_OUT_${plugin^^}=$(usex fluentbit_output_plugins_${plugin})")
	done
	for plugin in ${OUTPUT_PLUGINS_OPT}; do
		mycmakeargs+=("-DFLB_OUT_${plugin^^}=$(usex fluentbit_output_plugins_${plugin})")
	done
	for filter in ${FILTER_STD}; do
		mycmakeargs+=("-DFLB_FILTER_${filter^^}=$(usex fluentbit_filters_${filter})")
	done
	for filter in ${FILTER_OPT}; do
		mycmakeargs+=("-DFLB_FILTER_${filter^^}=$(usex fluentbit_filters_${filter})")
	done

	cmake_src_configure
}

src_install() {
	cmake_src_install

	keepdir "/var/log/${PN}"

	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"

	fowners fluent-bit:logger "/etc/${PN}"
}
