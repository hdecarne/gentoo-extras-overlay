# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit webapp eutils rpm depend.php

DESCRIPTION="Open Source Groupware Solution"
HOMEPAGE="http://zarafa.com/"

ZARAFA_WEBAPP_BUILD="final"
ZARAFA_WEBAPP_BUILDV="42633"

if [[ ${ZARAFA_WEBAPP_BUILD} == "final" ]] ; then
	SRC_URI="http://download.zarafa.com/community/${ZARAFA_WEBAPP_BUILD}/WebApp/${PV}/rhel/zarafa-webapp-${PV}-${ZARAFA_WEBAPP_BUILDV}.noarch.rpm"
else
	SRC_URI="http://download.zarafa.com/community/${ZARAFA_WEBAPP_BUILD}/WebApp/${PV}/rhel/zarafa-webapp-${PV}-${ZARAFA_WEBAPP_BUILDV}.noarch.rpm"
fi
S="${WORKDIR}/usr/share/zarafa-webapp"

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
