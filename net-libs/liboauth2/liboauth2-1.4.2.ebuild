# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#inherit autotools

DESCRIPTION="OAuth 2.x and OpenID Connect C library"
HOMEPAGE="https://github.com/zmartzone/liboauth2"
SRC_URI="https://github.com/zmartzone/liboauth2/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"

SLOT="0"

KEYWORDS="~amd64 ~arm64"

IUSE="apache2 memcached nginx redis"

RESTRICT="mirror"

RDEPEND="net-misc/curl
	>=dev-libs/openssl-0.9.8
	>=dev-libs/jansson-2.0
	>=dev-libs/cjose-0.6.1
	apache2? ( www-servers/apache:2 )
	memcached? ( >=dev-libs/libmemcached-1.0.14 )
	nginx? ( www-servers/nginx:mainline )
	redis? ( >=dev-libs/hiredis-0.9.0 )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	eapply_user
	./autogen.sh || die "prepare failed"
}

src_configure() {
	econf \
		--with-apache=$(usex apache2) \
		--with-memcache=$(usex memcached) \
		$(usex nginx --with-nginx=/usr/include/nghttp2) \
		--with-redis=$(usex redis)
}
