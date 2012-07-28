# Copyright 1999-2009 soul9.org
# Distributed under the terms of the WTFPL
EAPI=2

inherit cmake-utils

DESCRIPTION="A new xmpp transport based on libpurple"
HOMEPAGE="http://spectrum.im"

SRC_URI="http://spectrum.im/attachments/download/37/spectrum-1.4.7.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

IUSE="mysql sqlite ping"

RDEPEND="dev-libs/poco[mysql?,sqlite?]
	>=net-im/pidgin-2.6.0
	>=net-libs/gloox-1.0"
DEPEND="${RDEPEND}
	sys-devel/gettext"

src_unpack() {
    unpack ${A}
    mv spectrum-${PV} spectrum-transport-${PV}
        if ! use ping; then
                sed -e "s/'purple_timeout_add_seconds(60, &sendPing, this);',/'',/" \
                        -i "spectrum-transport-${PV}/src/main.cpp" \
                                || die "Cannot remove ping"
        fi
}

src_install () {
	cmake-utils_src_install

	#install init scripts and configs
	insinto /etc/spectrum
	#for protocol in aim facebook gg icq irc msn msn_pecan myspace qq simple sipe twitter xmpp yahoo; do
	for protocol in facebook msn gtalk; do
		sed -e 's,SPECTRUMGEN2PROTOCOL,'${protocol}',g' "${FILESDIR}/spectrum-2.cfg" > "${WORKDIR}/spectrum-${protocol}.cfg" || die
		doins "${WORKDIR}/spectrum-${protocol}.cfg" || die

		sed -e 's,SPECTRUMGEN2PROTOCOL,'${protocol}',g' "${FILESDIR}/spectrum.init" > "${WORKDIR}/spectrum-${protocol}" || die
		doinitd "${WORKDIR}/spectrum-${protocol}" || die
	done

	# install SQL schemas and tools
	insinto /usr/share/spectrum/schemas
	doins schemas/*
	insinto /usr/share/spectrum/tools
	doins tools/*
}
