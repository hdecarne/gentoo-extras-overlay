# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Installs init scripts to run bitwarden via podman"
HOMEPAGE="https://bitwarden.com/help/install-and-deploy-unified-beta/"
#SRC_URI=""

S=${WORKDIR}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="acct-group/bitwarden
	acct-user/bitwarden"

src_install() {
	newconfd "${FILESDIR}/bitwarden.confd3" "bitwarden"
	newinitd "${FILESDIR}/bitwarden.initd3" "bitwarden"
}
