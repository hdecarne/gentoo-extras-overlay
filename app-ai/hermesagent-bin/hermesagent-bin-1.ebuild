# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Installs init scripts and dependencies to run to run an externally installed Hermes Agent"
HOMEPAGE="https://hermes-agent.nousresearch.com/"
#SRC_URI=""

S=${WORKDIR}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="headless-chrome"

RDEPEND="acct-group/hermesagent
	acct-user/hermesagent
	dev-python/uv
	media-video/ffmpeg
	sys-apps/ripgrep
	headless-chrome? (
		app-accessibility/at-spi2-core
		dev-libs/atk
		dev-libs/nspr
		dev-libs/nss
		media-libs/alsa-lib
		media-libs/mesa
		net-print/cups
		x11-libs/libxkbcommon
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXdamage
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXrandr
		x11-libs/libxcb
	)"
DEPEND="${RDEPEND}"

src_install() {
	newconfd "${FILESDIR}/hermesagent.confd" "hermesagent"
	newinitd "${FILESDIR}/hermesagent.initd" "hermesagent"
}
