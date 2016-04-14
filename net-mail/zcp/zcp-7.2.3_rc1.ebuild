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

inherit autotools eutils flag-o-matic user php-ext-source-r2 python

DESCRIPTION="Open Source Groupware Solution"
HOMEPAGE="http://zarafa.com/"

ZARAFA_RELEASE="beta"
ZARAFA_VERSION="7.2"
ZARAFA_VERSION_MINOR=".3"
ZARAFA_BUILD=".653"

SRC_URI="https://download.zarafa.com/community/${ZARAFA_RELEASE}/${ZARAFA_VERSION}/${ZARAFA_VERSION}${ZARAFA_VERSION_MINOR}${ZARAFA_BUILD}/zcp-${ZARAFA_VERSION}${ZARAFA_VERSION_MINOR}${ZARAFA_BUILD}.tar.xz -> ${P}.tar.xz"
S="${WORKDIR}/zcp-${ZARAFA_VERSION}${ZARAFA_VERSION_MINOR}${ZARAFA_BUILD}"

ZARAFA_USER=${ZARAFA_USER:-zarafa}
ZARAFA_GROUP=${ZARAFA_GROUP:-zarafa}

ZARAFA_SERVICES="dagent gateway ical monitor presence search server spooler"

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
	<net-libs/gsoap-2.8.24
	net-misc/curl
	sys-libs/e2fsprogs-libs
	sys-libs/zlib
	icu? ( dev-libs/icu )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap )
	logrotate? ( app-admin/logrotate )
	python? ( dev-lang/python
			>=dev-python/python-daemon-1.6
			dev-python/bsddb3
			dev-python/flask )
	swig? ( dev-lang/swig )
	tcmalloc? ( dev-util/google-perftools )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup

	enewgroup "${ZARAFA_GROUP}"
	enewuser "${ZARAFA_USER}" -1 -1 "/var/lib/zarafa" "${ZARAFA_GROUP}"
}

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_prepare() {
	epatch "${FILESDIR}/zcp-sysconfig-r1.patch"
	epatch "${FILESDIR}/zcp-php-r1.patch"
	epatch "${FILESDIR}/zcp-logging-r1.patch"
	epatch "${FILESDIR}/zcp-bsddb3-r1.patch"
	eautoreconf
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

	dodir /etc/zarafa
	insinto /etc/zarafa
	doins "${S}"/installer/linux/*.cfg || die "Failed to install config files"
	fowners -Rf "${ZARAFA_USER}":"root" "/etc/zarafa"

	dodir /var/log/zarafa
	keepdir /var/log/zarafa
	fowners -Rf "${ZARAFA_USER}":"root" "/var/log/zarafa"

	dodir /var/lib/zarafa
	keepdir /var/lib/zarafa
	fowners -Rf "${ZARAFA_USER}":"root" "/var/lib/zarafa"
	dodir /var/lib/zarafa/spooler/plugins

	for service in ${ZARAFA_SERVICES}; do
		newconfd "${FILESDIR}/zarafa-${service}.confd" "zarafa-${service}"
		newinitd "${FILESDIR}/zarafa-${service}.initd3" "zarafa-${service}"
	done
}

pkg_postinst() {
	elog
	elog "Zarafa has been successfully emerged!"
	elog
	elog "Beginnging with ZCP 7.2.2 unprivileged users are used by default."
	elog "Please make sure that access rights for existing directories are"
	elog "modifed accordingly for example by issueing the following commands:"
	elog "    chown -R ${ZARAFA_USER}:root /var/lib/zarafa"
	elog "    chown -R ${ZARAFA_USER}:root /var/log/zarafa"
	elog "    chown -R ${ZARAFA_USER}:root /etc/zarafa"
	elog
	elog "For more details see the Zarafa changelog at:"
	elog
	elog "    https://download.zarafa.com/community/beta/7.2/changelog-7.2.txt"
	elog
}
