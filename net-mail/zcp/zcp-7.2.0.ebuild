# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

WANT_AUTOMAKE="1.11"

PHP_EXT_NAME="mapi"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
USE_PHP="php5-6 php5-5 php5-4 php5-3"

PYTHON_DEPEND="python? 2"

inherit autotools eutils flag-o-matic php-ext-source-r2 python

DESCRIPTION="Open Source Groupware Solution"
HOMEPAGE="http://zarafa.com/"

ZARAFA_VERSION="7.2"
ZARAFA_VERSION_MINOR=".0"
ZARAFA_RELEASE="final"
ZARAFA_BUILD="-48204"

SRC_URI="http://download.zarafa.com/community/${ZARAFA_RELEASE}/${ZARAFA_VERSION}/${ZARAFA_VERSION}${ZARAFA_VERSION_MINOR}${ZARAFA_BUILD}/sourcecode/zarafa-${ZARAFA_VERSION}${ZARAFA_VERSION_MINOR}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/zarafa-${ZARAFA_VERSION}${ZARAFA_VERSION_MINOR}"

ZARAFA_SERVICES="dagent gateway ical monitor search server spooler"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"
IUSE="debug icu kerberos ldap logrotate +python static +swig tcmalloc"

RDEPEND=">=dev-libs/libical-0.44
	>=dev-cpp/libvmime-zcp-0.9.2
	virtual/httpd-php
	virtual/mysql
	dev-libs/boost
	dev-libs/libxml2
	dev-libs/openssl
	dev-libs/xapian-bindings[python]
	>=net-libs/gsoap-2.8.13
	net-misc/curl
	sys-libs/e2fsprogs-libs
	sys-libs/zlib
	icu? ( dev-libs/icu )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap )
	logrotate? ( app-admin/logrotate )
	python? ( dev-lang/python
			dev-python/bsddb3
			>=dev-python/python-daemon-1.6 )
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
#	epatch "${FILESDIR}/zcp-shared.patch"
	epatch "${FILESDIR}/zcp-sysconfig.patch"
	epatch "${FILESDIR}/zcp-bsddb3.patch"
}

src_configure() {
	append-flags -fpermissive
	econf \
		--enable-release \
		--enable-unicode \
		--enable-sparsehash \
		--enable-oss \
		--enable-epoll \
		--with-userscript-prefix=/etc/zarafa/userscripts \
		--with-quotatemplate-prefix=/etc/zarafa/quotamails \
		--with-searchscripts-prefix=/etc/zarafa/searchscripts \
		$(use_enable debug) \
		$(use_enable icu) \
		$(use_enable python) \
		$(use_enable tcmalloc) \
		$(use_enable static) \
		$(use_enable swig)
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	php-ext-source-r2_createinifiles

	if use logrotate; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}"/zarafa.logrotate zarafa || die "Failed to install logrotate"
	fi
	if use ldap; then
		insinto /etc/openldap/schema
		doins "${S}"/installer/ldap/zarafa.* || die "Failed to install ldap schema files"
	fi

	insinto /etc/zarafa
	doins "${S}"/installer/linux/*.cfg || die "Failed to install config files"

	dodir /var/log/zarafa
	keepdir /var/log/zarafa

	dodir /var/lib/zarafa/spooler/plugins
	keepdir /var/lib/zarafa/spooler/plugins

	for service in ${ZARAFA_SERVICES}; do
		newconfd "${FILESDIR}/zarafa-${service}.confd" "zarafa-${service}"
		newinitd "${FILESDIR}/zarafa-${service}.initd" "zarafa-${service}"
	done
}
