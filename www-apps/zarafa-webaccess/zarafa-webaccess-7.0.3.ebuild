# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit webapp eutils depend.php

DESCRIPTION="Open Source Groupware Solution"
HOMEPAGE="http://zarafa.com/"

SRC_URI="http://download.zarafa.com/community/final/7.0/${PV}-30515/sourcecode/zcp-${PV}.tar.gz"
#SRC_URI="http://download.zarafa.com/community/beta/7.0/${PV}beta1-30283/sourcecode/zcp-${PV}.tar.gz"
S="${WORKDIR}/zarafa-${PV}/php-webclient-ajax"

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

	# remove unneeded files
	rm zarafa-webaccess.conf
	rm -r plugins

	# create default config
	cp "${S}"/config.php.dist "${S}"/config.php

	# make .po files
	for pofile in "${S}"/server/language/*/LC_MESSAGES/zarafa.po; do
		msgfmt -o ${pofile%%.po}.mo ${pofile}
		rm ${pofile}
	done

	dodir /var/lib/zarafa-webaccess/plugins
	dodir /var/lib/zarafa-webaccess/tmp
	dosym /var/lib/zarafa-webaccess/plugins "${MY_HTDOCSDIR}"/plugins

	insinto "${MY_HTDOCSDIR}"
	doins -r "${S}"/*

	webapp_configfile "${MY_HTDOCSDIR}"/config.php
	webapp_serverowned "${MY_HTDOCSDIR}"/config.php

	webapp_src_install
}
