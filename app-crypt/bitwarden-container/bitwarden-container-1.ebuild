# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

S=${WORKDIR}

DESCRIPTION="Installs init scripts to run bitwarden via podman"
HOMEPAGE="https://bitwarden.com/help/install-and-deploy-unified-beta/"
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"

DEPEND="acct-group/bitwarden
	acct-user/bitwarden"

src_install() {
	newconfd "${FILESDIR}/bitwarden.confd" "bitwarden"
	newinitd "${FILESDIR}/bitwarden.initd" "bitwarden"
}
