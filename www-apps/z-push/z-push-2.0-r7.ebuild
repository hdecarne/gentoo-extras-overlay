# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit webapp eutils depend.php

DESCRIPTION="Z-Push - open source push technology"
HOMEPAGE="http://z-push.sourceforge.net"

ZPUSH_BUILD="-1346"

SRC_URI="http://zarafa-deutschland.de/z-push-download/final/2.0/${P}${ZPUSH_BUILD}.tar.gz"
S="${WORKDIR}/${P}${ZPUSH_BUILD}"

LICENSE="AGPL-3"
KEYWORDS="~x86"
RESTRICT="mirror"
IUSE=""

need_php_httpd

pkg_setup () {
	webapp_pkg_setup
	require_php_with_use iconv session xml
}

src_install() {
	webapp_src_preinst

	dodir /var/log/z-push
	dodir /var/lib/z-push

	insinto "${MY_HTDOCSDIR}"
	doins -r "${S}"/*

	webapp_configfile "${MY_HTDOCSDIR}"/config.php
	webapp_serverowned "${MY_HTDOCSDIR}"/config.php

	webapp_src_install
}
