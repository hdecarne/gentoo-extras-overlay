# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#inherit autotools

DESCRIPTION="OpenID Connect Relying Party module for NGINX"
HOMEPAGE="https://github.com/zmartzone/ngx_openidc_module"

NGINX_PV="1.20.1"
NGINX_P="nginx-${NGINX_PV}"

SRC_URI="https://github.com/zmartzone/ngx_openidc_module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://nginx.org/download/${NGINX_P}.tar.gz"

LICENSE="AGPL-3"

SLOT="mainline"

KEYWORDS="~amd64 ~arm64"

IUSE=""

RESTRICT="mirror"

RDEPEND=">=net-libs/liboauth2-1.4.0[nginx]
	>=www-servers/${NGINX_P}"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	eapply_user
	./autogen.sh || die "prepare failed"
}

src_configure() {
	pushd ${WORKDIR}/${NGINX_P}
	./configure
	popd
	econf --with-nginx=${WORKDIR}/${NGINX_P}
}
