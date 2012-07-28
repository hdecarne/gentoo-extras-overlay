# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit webapp eutils depend.php

DESCRIPTION="Open Source Groupware Solution"
HOMEPAGE="http://zarafa.com/"

SRC_URI="http://download.zarafa.com/community/final/7.0/${PV}-28479/sourcecode/zcp-${PV}.tar.gz"
#SRC_URI="http://download.zarafa.com/community/beta/7.0/${PV}beta2-28479/sourcecode/zcp-${PV}.tar.gz"
S="${WORKDIR}/zarafa-${PV}/php-mobile-webaccess"

LICENSE="AGPL-3"
KEYWORDS="~x86"
RESTRICT="mirror"
IUSE=""

RDEPEND="dev-php/smarty"

need_php_httpd

pkg_setup () {
	webapp_pkg_setup
	require_php_with_use iconv session xml
}

src_install() {
	webapp_src_preinst

	dodir /var/lib/zarafa-webaccess-mobile/config
	dodir /var/lib/zarafa-webaccess-mobile/cache
	dodir /var/lib/zarafa-webaccess-mobile/templates_c

	# Apply patches
	epatch "${FILESDIR}/zarafa-mobile-utf-8.patch"
	epatch "${FILESDIR}/zarafa-mobile-webkit.patch"

	# remove unneeded files
	rm zarafa-webaccess-mobile.conf

	insinto "${MY_HTDOCSDIR}"
	doins -r "${S}"/*

	webapp_configfile "${MY_HTDOCSDIR}"/config.php
	webapp_serverowned "${MY_HTDOCSDIR}"/config.php

	webapp_src_install
}
