# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#inherit autotools

DESCRIPTION="OpenID Connect Relying Party module for NGINX"
HOMEPAGE="https://github.com/zmartzone/ngx_openidc_module"
SRC_URI="https://github.com/zmartzone/ngx_openidc_module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"

SLOT="mainline"

KEYWORDS="~amd64 ~arm64"

IUSE=""

RESTRICT="mirror"

RDEPEND=">=net-libs/liboauth2-1.4.0[nginx]
	www-servers/nginx:mainline"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	eapply_user
	./autogen.sh || die "prepare failed"
}

src_configure() {
	econf
}
