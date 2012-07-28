# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PHP_EXT_NAME="mapi"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
USE_PHP="php5-3 php5-4"

inherit eutils flag-o-matic php-ext-base-r1

DESCRIPTION="Open Source Groupware Solution"
HOMEPAGE="http://zarafa.com/"

#SRC_URI="http://download.zarafa.com/community/final/7.0/${PV}-32752/sourcecode/${P}.tar.gz"
SRC_URI="http://download.zarafa.com/community/beta/7.1/${PV}rc2-36025/sourcecode/${P}.tar.gz"
S="${WORKDIR}/zarafa-${PV}"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~x86"
RESTRICT="mirror"
IUSE="debug kerberos icu ldap logrotate perl static swig tcmalloc"

RDEPEND=">=app-text/catdoc-0.94.2
	>=dev-libs/libical-zcp-0.44
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
	dev-lang/python
	icu? ( dev-libs/icu )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap )
	logrotate? ( app-admin/logrotate )
	perl? ( virtual/perl )
	swig? ( virtual/swig )
	tcmalloc? ( dev-util/google-perftools )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_compile() {
	append-flags -fpermissive
	econf \
		--enable-oss \
		--disable-testtools \
		--enable-release \
		--enable-unicode \
		--enable-epoll \
		--enable-python \
		--with-userscript-prefix=/etc/zarafa/userscripts \
		--with-quotatemplate-prefix=/etc/zarafa/quotamails \
		--with-searchscripts-prefix=/etc/zarafa/searchscripts \
		$(use_enable icu) \
		$(use_enable static) \
		$(use_enable perl) \
		$(use_enable swig) \
		$(use_enable tcmalloc)
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

	newinitd ${FILESDIR}/zarafa-dagent.rc6 zarafa-dagent
	newinitd ${FILESDIR}/zarafa-gateway.rc6 zarafa-gateway
	newinitd ${FILESDIR}/zarafa-ical.rc6 zarafa-ical		
	newinitd ${FILESDIR}/zarafa-monitor.rc6 zarafa-monitor
	newinitd ${FILESDIR}/zarafa-server.rc6 zarafa-server
	newinitd ${FILESDIR}/zarafa-spooler.rc6 zarafa-spooler
	newinitd ${FILESDIR}/zarafa-search.rc6 zarafa-search
}
