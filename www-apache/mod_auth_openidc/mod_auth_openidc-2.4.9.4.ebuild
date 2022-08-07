# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit apache-module

DESCRIPTION="OpenID Connect Relying Party implementation for Apache HTTP Server 2.x"
HOMEPAGE="https://github.com/zmartzone/mod_auth_openidc"

SRC_URI="https://github.com/zmartzone/mod_auth_openidc/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE="+jq redis"

RDEPEND="net-misc/curl
	>=dev-libs/openssl-0.9.8
	>=dev-libs/jansson-2.0
	>=dev-libs/cjose-0.6.1
	dev-libs/libpcre
	redis? ( >=dev-libs/hiredis-0.9.0 )
	jq? ( app-misc/jq )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

APACHE2_MOD_CONF="48_mod_auth_openidc"
APACHE2_MOD_DEFINE="OPENIDC"

DOCFILES="README.md"

need_apache2

pkg_setup() {
	_init_apache2
	_init_apache2_late
}

src_prepare() {
	eapply_user
	./autogen.sh || die "prepare failed"
}

src_configure() {
	econf \
		--with-apxs2="${APXS}" \
		$(use_with redis hiredis) \
		$(use_with jq jq /usr)
}

src_compile() {
	emake || die "compile failed"
}
