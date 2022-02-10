# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit apache-module

S=${WORKDIR}/${PN}-${P}

DESCRIPTION="Apache Basic Auth PAM provider"
HOMEPAGE="https://github.com/adelton/mod_authnz_pam"

SRC_URI="https://github.com/adelton/mod_authnz_pam/archive/refs/tags/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="sys-libs/pam"
DEPEND="${RDEPEND}"

RESTRICT="mirror"

APXS2_ARGS="-c ${PN}.c -lpam"
APACHE2_MOD_DEFINE="PAM"


DOCFILES="README"

need_apache2

pkg_setup() {
	_init_apache2
	_init_apache2_late
}
