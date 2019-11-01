# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Fast and Lightweight Log processor and forwarder for Linux, BSD and OSX"
HOMEPAGE="http://fluentbit.io/"
SRC_URI="https://fluentbit.io/releases/${PV:0:3}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

INPUT_PLUGINS_STD="stdin"
INPUT_PLUGINS_OPT="cpu thermal disk docker exec forward health http mem kmsg lib random serial syslog tail tcp mqtt head proc systemd dummy netif collectd storage_backlog"
OUTPUT_PLUGINS_STD="stdout null"
OUTPUT_PLUGINS_OPT="azure bigquery counter datadog es exit forward gelf http influxdb nats tcp plot file td splunk stackdriver lib flowcounter kafka kafka_rest"
FILTER_STD="grep modify stdout parser throttle nest record_modifier"
FILTER_OPT="kubernetes lua"

IUSE="debug examples luajit jemalloc tls"
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
	jemalloc? ( dev-libs/jemalloc )"
DEPEND="${RDEPEND}"

BUILD_DIR="${S}/build"
CMAKE_BUILD_TYPE="Release"
CMAKE_MAKEFILE_GENERATOR="emake"

src_configure() {
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

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	keepdir "/etc/${PN}"

	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"

	fowners fluent-bit:logger "/etc/${PN}"
}
