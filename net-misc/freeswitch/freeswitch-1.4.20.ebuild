# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from freeswitch overlay; Bumped by mva; Bumped and extended by me; $

EAPI="5"

PHP_EXT_NAME="ESL"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-3 php5-4 php5-5 php5-6"

inherit autotools eutils flag-o-matic user php-ext-source-r2

DESCRIPTION="FreeSWITCH telephony platform"
HOMEPAGE="http://www.freeswitch.org/"
LICENSE="MPL-1.1"
KEYWORDS="~amd64 ~x86"
SLOT="0"

SRC_URI="http://files.freeswitch.org/releases/freeswitch/${P/_/}.tar.bz2"
RESTRICT="mirror"

S="${WORKDIR}/${P/_/}"

FS_MODULES_CORE="
	freeswitch_modules_commands:applications/mod_commands
	freeswitch_modules_db:applications/mod_db
	freeswitch_modules_dptools:applications/mod_dptools
	freeswitch_modules_expr:applications/mod_expr
	freeswitch_modules_hash:applications/mod_hash
	freeswitch_modules_limit:applications/mod_limit
	freeswitch_modules_spandsp:applications/mod_spandsp
	freeswitch_modules_dialplan_xml:dialplans/mod_dialplan_xml
	freeswitch_modules_loopback:endpoints/mod_loopback
	freeswitch_modules_sofia:endpoints/mod_sofia
	freeswitch_modules_event_socket:event_handlers/mod_event_socket
	freeswitch_modules_local_stream:formats/mod_local_stream
	freeswitch_modules_native_file:formats/mod_native_file
	freeswitch_modules_sndfile:formats/mod_sndfile
	freeswitch_modules_tone_stream:formats/mod_tone_stream
	freeswitch_modules_console:loggers/mod_console
	freeswitch_modules_logfile:loggers/mod_logfile
"

FS_MODULES_OPTIONAL="
	freeswitch_modules_abstraction:applications/mod_abstraction
	freeswitch_modules_avmd:applications/mod_avmd
	freeswitch_modules_blacklist:applications/mod_blacklist
	freeswitch_modules_callcenter:applications/mod_callcenter
	freeswitch_modules_cidlookup:applications/mod_cidlookup
	freeswitch_modules_cluechoo:applications/mod_cluechoo
	freeswitch_modules_conference:applications/mod_conference
	freeswitch_modules_curl:applications/mod_curl
	freeswitch_modules_directory:applications/mod_directory
	freeswitch_modules_distributor:applications/mod_distributor
	freeswitch_modules_easyroute:applications/mod_easyroute
	freeswitch_modules_enum:applications/mod_enum
	freeswitch_modules_esf:applications/mod_esf
	freeswitch_modules_esl:applications/mod_esl
	freeswitch_modules_fifo:applications/mod_fifo
	freeswitch_modules_fsk:applications/mod_fsk
	freeswitch_modules_fsv:applications/mod_fsv
	freeswitch_modules_httapi:applications/mod_httapi
	freeswitch_modules_http_cache:applications/mod_http_cache
	freeswitch_modules_ladspa:applications/mod_ladspa
	freeswitch_modules_lcr:applications/mod_lcr
	freeswitch_modules_memcache:applications/mod_memcache
	freeswitch_modules_mongo:applications/mod_mongo
	freeswitch_modules_mp4:applications/mod_mp4
	freeswitch_modules_nibblebill:applications/mod_nibblebill
	freeswitch_modules_oreka:applications/mod_oreka
	freeswitch_modules_osp:applications/mod_osp
	freeswitch_modules_rad_auth:applications/mod_rad_auth
	freeswitch_modules_random:applications/mod_random
	freeswitch_modules_redis:applications/mod_redis
	freeswitch_modules_rss:applications/mod_rss
	freeswitch_modules_sms:applications/mod_sms
	freeswitch_modules_snapshot:applications/mod_snapshot
	freeswitch_modules_snipe_hunt:applications/mod_snipe_hunt
	freeswitch_modules_snom:applications/mod_snom
	freeswitch_modules_sonar:applications/mod_sonar
	freeswitch_modules_soundtouch:applications/mod_soundtouch
	freeswitch_modules_spy:applications/mod_spy
	freeswitch_modules_stress:applications/mod_stress
	freeswitch_modules_translate:applications/mod_translate
	freeswitch_modules_valet_parking:applications/mod_valet_parking
	freeswitch_modules_vmd:applications/mod_vmd
	freeswitch_modules_voicemail:applications/mod_voicemail
	freeswitch_modules_voicemail_ivr:applications/mod_voicemail_ivr
	freeswitch_modules_cepstral:asr_tts/mod_cepstral
	freeswitch_modules_flite:asr_tts/mod_flite
	freeswitch_modules_pocketsphinx:asr_tts/mod_pocketsphinx
	freeswitch_modules_tts_commandline:asr_tts/mod_tts_commandline
	freeswitch_modules_unimrcp:asr_tts/mod_unimrcp
	freeswitch_modules_amr:codecs/mod_amr
	freeswitch_modules_amrwb:codecs/mod_amrwb
	freeswitch_modules_b64:codecs/mod_b64
	freeswitch_modules_bv:codecs/mod_bv
	freeswitch_modules_celt:codecs/mod_celt
	freeswitch_modules_codec2:codecs/mod_codec2
	freeswitch_modules_com_g729:codecs/mod_com_g729
	freeswitch_modules_dahdi_codec:codecs/mod_dahdi_codec
	freeswitch_modules_g723_1:codecs/mod_g723_1
	freeswitch_modules_g729:codecs/mod_g729
	freeswitch_modules_h26x:codecs/mod_h26x
	freeswitch_modules_ilbc:codecs/mod_ilbc
	freeswitch_modules_isac:codecs/mod_isac
	freeswitch_modules_mp4v:codecs/mod_mp4v
	freeswitch_modules_opus:codecs/mod_opus
	freeswitch_modules_sangoma_codec:codecs/mod_sangoma_codec
	freeswitch_modules_silk:codecs/mod_silk
	freeswitch_modules_siren:codecs/mod_siren
	freeswitch_modules_theora:codecs/mod_theora
	freeswitch_modules_vp8:codecs/mod_vp8
	freeswitch_modules_dialplan_asterisk:dialplans/mod_dialplan_asterisk
	freeswitch_modules_dialplan_directory:dialplans/mod_dialplan_directory
	freeswitch_modules_ldap:directories/mod_ldap
	freeswitch_modules_alsa:endpoints/mod_alsa
	freeswitch_modules_dingaling:endpoints/mod_dingaling
	freeswitch_modules_gsmopen:endpoints/mod_gsmopen
	freeswitch_modules_h323:endpoints/mod_h323
	freeswitch_modules_khomp:endpoints/mod_khomp
	freeswitch_modules_opal:endpoints/mod_opal
	freeswitch_modules_portaudio:endpoints/mod_portaudio
	freeswitch_modules_reference:endpoints/mod_reference
	freeswitch_modules_rtc:endpoints/mod_rtc
	freeswitch_modules_rtmp:endpoints/mod_rtmp
	freeswitch_modules_skinny:endpoints/mod_skinny
	freeswitch_modules_skypopen:endpoints/mod_skypopen
	freeswitch_modules_unicall:endpoints/mod_unicall
	freeswitch_modules_verto:endpoints/mod_verto
	freeswitch_modules_cdr_csv:event_handlers/mod_cdr_csv
	freeswitch_modules_cdr_mongodb:event_handlers/mod_cdr_mongodb
	freeswitch_modules_cdr_pg_csv:event_handlers/mod_cdr_pg_csv
	freeswitch_modules_cdr_sqlite:event_handlers/mod_cdr_sqlite
	freeswitch_modules_erlang_event:event_handlers/mod_erlang_event
	freeswitch_modules_event_multicast:event_handlers/mod_event_multicast
	freeswitch_modules_event_test:event_handlers/mod_event_test
	freeswitch_modules_event_zmq:event_handlers/mod_event_zmq
	freeswitch_modules_format_cdr:event_handlers/mod_format_cdr
	freeswitch_modules_json_cdr:event_handlers/mod_json_cdr
	freeswitch_modules_radius_cdr:event_handlers/mod_radius_cdr
	freeswitch_modules_rayo:event_handlers/mod_rayo
	freeswitch_modules_snmp:event_handlers/mod_snmp
	freeswitch_modules_portaudio_stream:formats/mod_portaudio_stream
	freeswitch_modules_shell_stream:formats/mod_shell_stream
	freeswitch_modules_shout:formats/mod_shout
	freeswitch_modules_ssml:formats/mod_ssml
	freeswitch_modules_vlc:formats/mod_vlc
	freeswitch_modules_basic:languages/mod_basic
	freeswitch_modules_java:languages/mod_java
	freeswitch_modules_lua:languages/mod_lua
	freeswitch_modules_managed:languages/mod_managed
	freeswitch_modules_perl:languages/mod_perl
	freeswitch_modules_python:languages/mod_python
	freeswitch_modules_v8:languages/mod_v8
	freeswitch_modules_yaml:languages/mod_yaml
	freeswitch_modules_graylog2:loggers/mod_graylog2
	freeswitch_modules_syslog:loggers/mod_syslog
	freeswitch_modules_posix_timer:timers/mod_posix_timer
	freeswitch_modules_timerfd:timers/mod_timerfd
	freeswitch_modules_xml_cdr:xml_int/mod_xml_cdr
	freeswitch_modules_xml_curl:xml_int/mod_xml_curl
	freeswitch_modules_xml_ldap:xml_int/mod_xml_ldap
	freeswitch_modules_xml_radius:xml_int/mod_xml_radius
	freeswitch_modules_xml_rpc:xml_int/mod_xml_rpc
	freeswitch_modules_xml_scgi:xml_int/mod_xml_scgi
"

FS_LANGUAGES_CORE="
	linguas_en:say/mod_say_en
"

FS_LANGUAGES_OPTIONAL="
	linguas_de:say/mod_say_de
	linguas_es:say/mod_say_es
	linguas_fa:say/mod_say_fa
	linguas_fr:say/mod_say_fr
	linguas_he:say/mod_say_he
	linguas_hr:say/mod_say_hr
	linguas_hu:say/mod_say_hu
	linguas_it:say/mod_say_it
	linguas_ja:say/mod_say_ja
	linguas_nl:say/mod_say_nl
	linguas_pl:say/mod_say_pl
	linguas_pt:say/mod_say_pt
	linguas_ru:say/mod_say_ru
	linguas_sv:say/mod_say_sv
	linguas_th:say/mod_say_th
	linguas_zh:say/mod_say_zh
"

FS_ESL="
	freeswitch_esl_php
"

IUSE="debug libedit odbc +resampler sctp zrtp"

for e in ${FS_MODULES_CORE}; do
	u="${e%:*}"
	IUSE="${IUSE} +${u}"
done
for e in ${FS_MODULES_OPTIONAL}; do
	u="${e%:*}"
	IUSE="${IUSE} ${u}"
done
for e in ${FS_LANGUAGES_CORE}; do
	u="${e%:*}"
	IUSE="${IUSE} +${u}"
done
for e in ${FS_LANGUAGES_OPTIONAL}; do
	u="${e%:*}"
	IUSE="${IUSE} ${u}"
done
for e in ${FS_ESL}; do
	u="${e%:*}"
	IUSE="${IUSE} ${u}"
done

REQUIRED_USE="
	|| ( freeswitch_modules_posix_timer freeswitch_modules_timerfd )
"

RDEPEND="
	media-libs/speex
	libedit? ( dev-libs/libedit )
	odbc? ( dev-db/unixODBC )
	sctp? ( kernel_linux? ( net-misc/lksctp-tools ) )
	freeswitch_modules_cdr_sqlite? ( dev-db/sqlite )
	freeswitch_modules_curl? ( net-misc/curl )
	freeswitch_modules_opus? ( media-libs/opus )
	freeswitch_modules_snmp? ( net-analyzer/net-snmp )
	freeswitch_modules_spandsp? ( virtual/jpeg )
"

DEPEND="
	${RDEPEND}
"

PDEPEND="
	net-misc/freeswitch-sounds
	net-misc/freeswitch-sounds-music
"

FREESWITCH_USER=${FREESWITCH_USER:-freeswitch}
FREESWITCH_GROUP=${FREESWITCH_GROUP:-freeswitch}

configure_modules_conf() {
	einfo "Preparing modules.conf"
	rm -f "modules.conf" || die "Failed to remove existing modules.conf"
	for e in ${FS_MODULES_CORE}; do
		u="${e%:*}"
		m="${e#*:}"
		if use "${u}"; then
			einfo "  ++ Enabling ${m}"
			echo "${m}" >> modules.conf
		else
			einfo "  -- Disabling ${m}"
			echo "#${m}" >> modules.conf
		fi
	done
	for e in ${FS_MODULES_OPTIONAL}; do
		u="${e%:*}"
		m="${e#*:}"
		if use "${u}"; then
			einfo "  ++ Enabling ${m}"
			echo "${m}" >> modules.conf
		else
			einfo "  -- Disabling ${m}"
			echo "#${m}" >> modules.conf
		fi
	done
	for e in ${FS_LANGUAGES_CORE}; do
		u="${e%:*}"
		m="${e#*:}"
		if use "${u}"; then
			einfo "  ++ Enabling ${m}"
			echo "${m}" >> modules.conf
		else
			einfo "  -- Disabling ${m}"
			echo "#${m}" >> modules.conf
		fi
	done
	for e in ${FS_LANGUAGES_OPTIONAL}; do
		u="${e%:*}"
		m="${e#*:}"
		if use "${u}"; then
			einfo "  ++ Enabling ${m}"
			echo "${m}" >> modules.conf
		else
			einfo "  -- Disabling ${m}"
			echo "#${m}" >> modules.conf
		fi
	done
}

pkg_setup() {
	enewgroup "${FREESWITCH_GROUP}"
	enewuser "${FREESWITCH_USER}" -1 -1 "/var/lib/${PN}" "${FREESWITCH_GROUP}"
}

src_prepare() {
	einfo "Preparing FreeSWITCH..."
	sed -e 's/-Werror//' -i configure || dir "failed to prepare compile options"
	sed -e 's/-Wno-unused-result//' -i configure || dir "failed to prepare compile options"
	if use freeswitch_esl_php; then
		sed -e 's/swig2\.0/swig/' -i libs/esl/php/Makefile.in || die "failed to prepare PHP esl module"
	fi
	epatch_user
}

src_configure() {
	local config_opts python_opts java_opts

	configure_modules_conf
	einfo "Configuring FreeSWITCH..."
	touch noreg
	if ! use debug; then
		debug_opts="--disable-debug --enable-optimization"
	fi
	config_opts=""
	if ! use libedit; then
		config_opts="${config_opts} --disable-core-libedit-support"
	fi
	if use freeswitch_modules_python; then
		python_opts="--with-python=$(PYTHON -a)"
	fi
	if use freeswitch_modules_java; then
		java_opts="--with-java=$(/usr/bin/java-config -O)"
	fi
	addpredict /var/lib/net-snmp/mib_indexes
	econf \
		--disable-option-checking \
		${CTARGET:+--target=${CTARGET}} \
		--enable-core-libedit-support \
		--localstatedir="/var" \
		--sysconfdir="/etc/${PN}" \
		--with-modinstdir="/usr/$(get_libdir)/${PN}/mod" \
		--with-rundir="/var/run/${PN}" \
		--with-logfiledir="/var/log/${PN}" \
		--with-dbdir="/var/lib/${PN}/db" \
		--with-htdocsdir="/usr/share/${PN}/htdocs" \
		--with-soundsdir="/usr/share/${PN}/sounds" \
		--with-grammardir="/usr/share/${PN}/grammar" \
		--with-scriptdir="/usr/share/${PN}/scripts" \
		--with-recordingsdir="/var/lib/${PN}/recordings" \
		--with-pkgconfigdir="/usr/$(get_libdir)/pkgconfig" \
		$(use_enable sctp) \
		$(use_enable zrtp) \
		$(use_enable resampler resample) \
		$(use_enable odbc core-odbc-support) \
		${config_opts} \
		${debug_opts} \
		${python_opts} \
		${java_opts} \
		|| die "failed to configure FreeSWITCH"
}

src_compile() {
	einfo "Building FreeSWITCH..."
	emake || die "failed to build FreeSWITCH"
	if use freeswitch_esl_php; then
		einfo "Building PHP esl module..."
		emake -C libs/esl/php reswig || die "failed to reswig PHP esl module"
		emake -C libs/esl phpmod || die "failed to build PHP esl module"
	fi
}

src_install() {
	einfo "Installing FreeSWITCH..."
	emake install DESTDIR="${D}" || die "failed to install FreeSWITCH"

	find "${ED}" -name "*.la" -delete || die "failed to cleanup .la files"

	newinitd "${FILESDIR}"/freeswitch.rc6 freeswitch
	newconfd "${FILESDIR}"/freeswitch.confd freeswitch

	fowners -Rf "${FREESWITCH_USER}":"${FREESWITCH_GROUP}" "/etc/${PN}"
	fowners -Rf "${FREESWITCH_USER}":"${FREESWITCH_GROUP}" "/usr/$(get_libdir)/${PN}"
	fowners -Rf "${FREESWITCH_USER}":"${FREESWITCH_GROUP}" "/var/run/${PN}"
	fowners -Rf "${FREESWITCH_USER}":"${FREESWITCH_GROUP}" "/var/log/${PN}"
	fowners -Rf "${FREESWITCH_USER}":"${FREESWITCH_GROUP}" "/usr/share/${PN}"
	fowners -Rf "${FREESWITCH_USER}":"${FREESWITCH_GROUP}" "/var/lib/${PN}"
	if use freeswitch_esl_php; then
		einfo "Installing PHP esl module..."
		emake DESTDIR="${D}" -C libs/esl phpmod-install || die "failed to install PHP esl module"
		php-ext-source-r2_createinifiles
	fi
}

pkg_postinst() {
	einfo
	einfo "FreeSWITCH has been successfully emerged!"
	einfo
	einfo "More information about FreeSWITCH and how to configure it"
	einfo "can be found on one of these sites:"
	einfo
	einfo "    http://www.freeswitch.org/"
	einfo "    http://wiki.freeswitch.org/"
	einfo
}
