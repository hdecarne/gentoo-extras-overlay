# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

S=${WORKDIR}

DESCRIPTION="Installs init scripts to run paperless-ngx via podman"
HOMEPAGE="https://docs.paperless-ngx.com/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="acct-group/paperless
	acct-user/paperless"

src_install() {
	newconfd "${FILESDIR}/paperless-ngx.confd" "paperless-ngx"
	newinitd "${FILESDIR}/paperless-ngx.initd" "paperless-ngx"
}
