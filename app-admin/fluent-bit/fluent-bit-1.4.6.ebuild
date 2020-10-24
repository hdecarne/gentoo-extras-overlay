# Copyright 1999-2020 Gentoo Authors
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

INPUT_PLUGINS_STD="stdin"
INPUT_PLUGINS_OPT="cpu thermal disk docker exec forward health http mem kmsg lib random serial syslog tail tcp mqtt head proc systemd dummy netif winlog collectd storage_backlog emitter"
OUTPUT_PLUGINS_STD="stdout null"
OUTPUT_PLUGINS_OPT="azure bigquery counter datadog es exit forward gelf http influxdb nats tcp plot file td retry pgsql splunk stackdriver lib flowcounter kafka kafka_rest"
FILTER_STD="grep modify stdout parser throttle nest record_modifier"
FILTER_OPT="aws expect kubernetes lua rewrite_tag"

IUSE="debug examples luajit jemalloc loki +tls"
for plugin in ${INPUT_PLUGINS_STD}; do
	IUSE="${IUSE} +fluentbit_input_plugins_${plugin}"
done
for plugin in ${INPUT_PLUGINS_OPT}; do
	IUSE="${IUSE} fluentbit_input_plugins_${plugin}"
done
for plugin in ${OUTPUT_PLUGINS_STD}; do
	IUSE="${IUSE} +fluentbit_output_plugins_${plugin}"
done
for plugin in ${OUTPUT_PLUGINS_OPT}; do
	IUSE="${IUSE} fluentbit_output_plugins_${plugin}"
done
for filter in ${FILTER_STD}; do
	IUSE="${IUSE} +fluentbit_filters_${filter}"
done
for filter in ${FILTER_OPT}; do
	IUSE="${IUSE} fluentbit_filters_${filter}"
done

RESTRICT="mirror"

RDEPEND="acct-group/logger
	acct-user/fluent-bit
	luajit? ( dev-lang/luajit )
	jemalloc? ( dev-libs/jemalloc )
	fluentbit_output_plugins_pgsql? ( >=dev-db/postgresql-9.4:= )"
DEPEND="${RDEPEND}"

BUILD_DIR="${S}/build"
CMAKE_BUILD_TYPE="Release"
CMAKE_MAKEFILE_GENERATOR="emake"

src_prepare() {
	cmake_src_prepare
	if use loki; then
		eapply "${FILESDIR}/${PN}-json_loki.patch"
	fi
}

src_configure() {
	append-cflags -fcommon
	local mycmakeargs=(
		-Wno-dev
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		-DBUILD_SHARED_LIBS=no
		-DFLB_DEBUG="$(usex debug)"
		-DFLB_JEMALLOC="$(usex jemalloc)"
		-DFLB_TLS="$(usex tls)"
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
