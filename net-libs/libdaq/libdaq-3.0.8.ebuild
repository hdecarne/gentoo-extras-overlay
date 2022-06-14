# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="LibDAQ: The Data AcQuisition Library"

HOMEPAGE="https://github.com/snort3/libdaq"

SRC_URI="https://github.com/snort3/libdaq/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~amd64"

IUSE="+af-packet +bpf divert +dump fst netmap nfq +pcap savefile trace"

RESTRICT="mirror"

RDEPEND="!net-libs/daq
	af-packet? ( net-libs/libpcap )
	bpf? ( net-libs/libpcap )
	dump? ( net-libs/libpcap )
	pcap? ( net-libs/libpcap )"

DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-disable-example.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable af-packet afpacket-module) \
		$(use_enable bpf bpf-module) \
		$(use_enable divert divert-module) \
		$(use_enable dump dump-module) \
		$(use_enable fst fst-module) \
		$(use_enable netmap netmap-module) \
		$(use_enable nfq nfq-module) \
		$(use_enable pcap pcap-module) \
		$(use_enable savefile savefile-module) \
		$(use_enable trace trace-module)
}
