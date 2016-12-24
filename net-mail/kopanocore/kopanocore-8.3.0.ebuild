# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PHP_EXT_NAME="mapi"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
USE_PHP="php5-6"

PYTHON_DEPEND="2"

inherit autotools eutils flag-o-matic user php-ext-source-r2 python

DESCRIPTION="Open Source Groupware Solution"
HOMEPAGE="http://kopano.io/"

KOPANO_BUILD="350"

SRC_URI="https://download.kopano.io/community/core:/sourcecode/${P}.${KOPANO_BUILD}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}.${KOPANO_BUILD}"

KOPANO_USER=${KOPANO_USER:-kopano}
KOPANO_GROUP=${KOPANO_GROUP:-kopano}

KOPANO_SERVICES="dagent gateway ical monitor presence search server spooler"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"
IUSE="debug icu kerberos ldap logrotate static tcmalloc"

RDEPEND="!net-mail/zcp
	>=dev-libs/libical-0.44
	>=dev-cpp/libvmime-0.9.3[smtp]
	virtual/httpd-php
	virtual/mysql
	dev-libs/boost
	dev-libs/libxml2
	dev-libs/openssl
	dev-libs/xapian-bindings[python]
	net-libs/gsoap
	net-misc/curl
	sys-libs/e2fsprogs-libs
	sys-libs/zlib
	icu? ( dev-libs/icu )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap )
	logrotate? ( app-admin/logrotate )
	dev-lang/python
	>=dev-python/python-daemon-1.6
	dev-python/bsddb3
	dev-python/flask
	dev-lang/swig
	tcmalloc? ( dev-util/google-perftools )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup

	enewgroup "${KOPANO_GROUP}"
	enewuser "${KOPANO_USER}" -1 -1 "/var/lib/kopano" "${KOPANO_GROUP}"
}

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_prepare() {
	epatch "${FILESDIR}/kopanocore-8.3.0-sysconfig.patch"
	epatch "${FILESDIR}/kopanocore-8.3.0-bsddb3.patch"
	epatch "${FILESDIR}/kopanocore-8.3.0-php.patch"
	eautoreconf
}

src_configure() {
	append-flags -fpermissive
	econf \
		--enable-release \
		--enable-unicode \
		--enable-epoll \
		--with-userscript-prefix=/etc/kopano/userscripts \
		--with-quotatemplate-prefix=/etc/kopano/quotamails \
		--with-searchscripts-prefix=/etc/kopano/searchscripts \
		$(use_enable debug) \
		$(use_enable icu) \
		$(use_enable static)
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	php-ext-source-r2_createinifiles

	if use logrotate; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}"/kopano.logrotate kopano || die "Failed to install logrotate"
	fi
	if use ldap; then
		insinto /etc/openldap/schema
		doins "${S}"/installer/ldap/kopano.* || die "Failed to install ldap schema files"
	fi

	dodir /etc/kopano
	insinto /etc/kopano
	doins "${S}"/installer/linux/*.cfg || die "Failed to install config files"
	fowners -Rf "${KOPANO_USER}":"root" "/etc/kopano"

	dodir /var/log/kopano
	keepdir /var/log/kopano
	fowners -Rf "${KOPANO_USER}":"root" "/var/log/kopano"

	dodir /var/lib/kopano
	keepdir /var/lib/kopano
	dodir /var/lib/kopano/spooler/plugins
	dodir /var/lib/kopano/dagent/plugins
	fowners -Rf "${KOPANO_USER}":"root" "/var/lib/kopano"

	for service in ${KOPANO_SERVICES}; do
		newconfd "${FILESDIR}/kopano-${service}.confd" "kopano-${service}"
		newinitd "${FILESDIR}/kopano-${service}.initd" "kopano-${service}"
	done
}

pkg_postinst() {
	elog
	elog "Kopano Core has been successfully emerged!"
	elog
	elog "Kopano Core replaces the former ZCP package."
	elog
	elog "Please check the following URL for how to migrate:"
	elog "    https://kb.kopano.io/display/WIKI/Migrating+from+ZCP+to+Kopano"
	elog
}
