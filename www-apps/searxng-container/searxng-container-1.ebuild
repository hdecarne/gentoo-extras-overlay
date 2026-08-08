# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Installs init scripts to run SearXNG via podman"
HOMEPAGE="https://docs.searxng.org/"
SRC_URI=""

S=${WORKDIR}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="acct-group/searxng
	acct-user/searxng"

src_install() {
	newconfd "${FILESDIR}/searxng.confd" "searxng"
	newinitd "${FILESDIR}/searxng.initd" "searxng"
}
