# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenID Connect Relying Party module for NGINX"
HOMEPAGE="https://github.com/zmartzone/ngx_openidc_module"

NGINX_PV="1.21.0"
NGINX_P="nginx-${NGINX_PV}"

SRC_URI="https://github.com/zmartzone/ngx_openidc_module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://nginx.org/download/${NGINX_P}.tar.gz"

S="${WORKDIR}/${NGINX_P}"

LICENSE="AGPL-3"

SLOT="mainline"

KEYWORDS="~amd64 ~arm64"

IUSE=""

RDEPEND=">=net-libs/liboauth2-1.4.0[nginx]
	>=www-servers/${NGINX_P}"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	eapply_user
	pushd ${WORKDIR}/${P}
	./autogen.sh || die "prepare failed"
	popd
}

src_configure() {
	pushd ${WORKDIR}/${P}
	econf
	popd
	./configure --with-compat --add-dynamic-module="${WORKDIR}/${P}/src"
}

src_compile() {
	emake modules
}

src_install() {
	exeinto "/usr/$(get_libdir)/nginx/modules"
	doexe "${S}/objs/ngx_openidc_module.so"
}
