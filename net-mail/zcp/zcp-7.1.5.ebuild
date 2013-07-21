# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PHP_EXT_NAME="mapi"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
USE_PHP="php5-3 php5-4"

PYTHON_DEPEND="python? 2"

inherit eutils flag-o-matic php-ext-base-r1 python

DESCRIPTION="Open Source Groupware Solution"
HOMEPAGE="http://zarafa.com/"

ZARAFA_RELEASE="final"
ZARAFA_BUILD="-42059"

SRC_URI="http://download.zarafa.com/community/${ZARAFA_RELEASE}/7.1/${PV}${ZARAFA_BUILD}/sourcecode/${P}.tar.gz"
S="${WORKDIR}/zarafa-${PV}"

ZARAFA_SERVICES="dagent gateway ical monitor search server spooler"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~x86"
RESTRICT="mirror"
IUSE="debug kerberos icu ldap logrotate +python static swig tcmalloc"

RDEPEND=">=dev-libs/libical-zcp-0.44
	>=dev-cpp/libvmime-zcp-0.9.2
	virtual/httpd-php
	virtual/mysql
	=dev-cpp/clucene-0.9.21b-r1
	dev-db/kyotocabinet
	dev-libs/boost
	dev-libs/libxml2
	dev-libs/openssl
	net-misc/curl
	sys-libs/e2fsprogs-libs
	sys-libs/zlib
	icu? ( dev-libs/icu )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap )
	logrotate? ( app-admin/logrotate )
	python? ( dev-lang/python )
	swig? ( dev-lang/swig )
	tcmalloc? ( dev-util/google-perftools )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_prepare() {
	epatch "${FILESDIR}/zarafa-${PV}-fixes.patch"
}

src_configure() {
	append-flags -fpermissive
	econf \
		--enable-oss \
		--enable-release \
		--enable-unicode \
		--enable-epoll \
		--with-userscript-prefix=/etc/zarafa/userscripts \
		--with-quotatemplate-prefix=/etc/zarafa/quotamails \
		--with-searchscripts-prefix=/etc/zarafa/searchscripts \
		$(use_enable icu) \
		$(use_enable static) \
		$(use_enable python) \
		$(use_enable swig) \
		$(use_enable tcmalloc tcmalloc-full)
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	php-ext-base-r1_src_install

	if use logrotate; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}"/zarafa.logrotate zarafa || die "Failed to install logrotate"
	fi
	if use ldap; then
		insinto /etc/openldap/schema
		doins installer/ldap/zarafa.* || die "Failed to install ldap schema files"
	fi

	insinto /etc/zarafa
	doins "${S}"/installer/linux/*.cfg || die "Failed to install config files"

	dodir /var/log/zarafa
	keepdir /var/log/zarafa

	for service in ${ZARAFA_SERVICES}; do
		newconfd "${FILESDIR}/zarafa-${service}.confd" "zarafa-${service}"
		newinitd "${FILESDIR}/zarafa-${service}.initd" "zarafa-${service}"
	done
}
