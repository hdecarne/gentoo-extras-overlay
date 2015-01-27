# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit webapp eutils rpm depend.php

DESCRIPTION="Open Source Groupware Solution"
HOMEPAGE="http://zarafa.com/"

SRC_URI="http://download.zarafa.com/community/final/WebApp/2.0/rhel-7/zarafa-webapp-2.0.47678-35.1.noarch.rpm
	http://download.zarafa.com/community/final/WebApp/2.0/rhel-7/zarafa-webapp-lang-2.0.47678-35.1.noarch.rpm"

S="${WORKDIR}/usr/share/zarafa-webapp"

LICENSE="AGPL-3"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"
IUSE="plugin_extbox plugin_pdfbox plugin_files"

PDEPEND="plugin_extbox? ( www-apps/zarafa-webapp-extbox )
	plugin_pdfbox? ( www-apps/zarafa-webapp-pdfbox )
	plugin_files? ( www-apps/zarafa-webapp-files )"

need_php_httpd

pkg_setup () {
	webapp_pkg_setup
	require_php_with_use iconv session xml
}

src_install() {
	webapp_src_preinst

	# rearrange files and remove unneeded ones
	rm config.php || die "Unexpected source layout; ebuild needs update"
	rm -r plugins || die "Unexpected source layout; ebuild needs update"
	cp "${S}/../../../etc/zarafa/webapp/config.php" "${S}/config.php" || die "Unexpected source layout; ebuild needs update"

	dodir "/var/lib/zarafa-webapp/plugins"
	dosym "/var/lib/zarafa-webapp/plugins" "${MY_HTDOCSDIR}"/plugins
	dodir "/var/lib/zarafa-webapp/tmp"

	insinto "${MY_HTDOCSDIR}"
	doins -r "${S}"/*

	webapp_serverowned -R "/var/lib/zarafa-webapp"
	webapp_serverowned "${MY_HTDOCSDIR}/config.php"
	webapp_configfile "${MY_HTDOCSDIR}/config.php"

	webapp_src_install
}
