# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit webapp eutils depend.php

DESCRIPTION="Z-Push - open source push technology"
HOMEPAGE="http://z-push.sourceforge.net"

ZPUSH_RELEASE="final"
ZPUSH_BASE_VERSION="2.3"
ZPUSH_VERSION="2.3.4"
ZPUSH_BUILD=""
ZPUSH_SUFFIX=""

SRC_URI="http://download.z-push.org/${ZPUSH_RELEASE}/${ZPUSH_BASE_VERSION}/z-push-${ZPUSH_VERSION}${ZPUSH_SUFFIX}${ZPUSH_BUILD}.tar.gz"
S="${WORKDIR}/z-push-${ZPUSH_VERSION}${ZPUSH_SUFFIX}${ZPUSH_BUILD}"

LICENSE="AGPL-3"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"
IUSE=""

BACKENDS="caldav  carddav  combined  imap  ipcmemcached  kopano  ldap  maildir  searchldap  sqlstatemachine  vcarddir"

need_php_httpd

pkg_setup () {
	webapp_pkg_setup
	require_php_with_use iconv session xml
}

src_install() {
	webapp_src_preinst

	dodir "/var/log/z-push"
	dodir "/var/lib/z-push"

	insinto "${MY_HTDOCSDIR}"
	doins -r "${S}"/*

	webapp_serverowned -R "/var/log/z-push"
	webapp_serverowned -R "/var/lib/z-push"
	webapp_configfile "${MY_HTDOCSDIR}"/config.php
	webapp_serverowned "${MY_HTDOCSDIR}"/config.php
	webapp_configfile "${MY_HTDOCSDIR}"/policies.ini
	webapp_serverowned "${MY_HTDOCSDIR}"/policies.ini

	for backend in ${BACKENDS}; do
		webapp_configfile "${MY_HTDOCSDIR}"/backend/${backend}/config.php
		webapp_serverowned "${MY_HTDOCSDIR}"/backend/${backend}/config.php
	done

	webapp_src_install
}
