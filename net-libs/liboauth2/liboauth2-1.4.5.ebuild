# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OAuth 2.x and OpenID Connect C library"
HOMEPAGE="https://github.com/zmartzone/liboauth2"

NGINX_PV="1.21.0"
NGINX_P="nginx-${NGINX_PV}"

SRC_URI="https://github.com/zmartzone/liboauth2/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	nginx? ( https://nginx.org/download/${NGINX_P}.tar.gz )"

LICENSE="AGPL-3"

SLOT="0"

KEYWORDS="~amd64 ~arm64"

IUSE="apache2 memcached nginx redis"

RDEPEND="net-misc/curl
	>=dev-libs/openssl-0.9.8
	>=dev-libs/jansson-2.0
	>=dev-libs/cjose-0.6.1
	apache2? ( www-servers/apache:2 )
	memcached? ( >=dev-libs/libmemcached-1.0.14 )
	nginx? ( >=www-servers/${NGINX_P} )
	redis? ( >=dev-libs/hiredis-0.9.0 )"
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
	econf \
		--with-apache=$(usex apache2) \
		--with-memcache=$(usex memcached) \
		$(usex nginx --with-nginx=${WORKDIR}/${NGINX_P}) \
		--with-redis=$(usex redis)
}
