# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit webapp eutils depend.php

DESCRIPTION="Open Source Groupware Solution"
HOMEPAGE="http://kopanoio/"

WEBAPP_PACKAGE="webapp-3.3.0.375_299-RHEL_7-noarch"
WEBAPP_RPMS="
	kopano-webapp-3.3.0.375-299.1.noarch.rpm
	kopano-webapp-lang-3.3.0.375-299.1.noarch.rpm
	kopano-webapp-plugin-contactfax-3.3.0.375-299.1.noarch.rpm
	kopano-webapp-plugin-delayeddelivery-2.0.0.6-4.1.noarch.rpm
	kopano-webapp-plugin-desktopnotifications-2.0.0.7-4.1.noarch.rpm
	kopano-webapp-plugin-filepreviewer-2.0.0.3-2.1.noarch.rpm
	kopano-webapp-plugin-folderwidgets-3.3.0.375-299.1.noarch.rpm
	kopano-webapp-plugin-gmaps-3.3.0.375-299.1.noarch.rpm
	kopano-webapp-plugin-pimfolder-3.3.0.375-299.1.noarch.rpm
	kopano-webapp-plugin-quickitems-3.3.0.375-299.1.noarch.rpm
	kopano-webapp-plugin-spell-2.0.0.0-2.1.noarch.rpm
	kopano-webapp-plugin-spell-de-at-2.0.0.0-1.1.noarch.rpm
	kopano-webapp-plugin-spell-de-ch-2.0.0.0-1.1.noarch.rpm
	kopano-webapp-plugin-spell-de-de-2.0.0.0-1.1.noarch.rpm
	kopano-webapp-plugin-spell-en-gb-2.0.0.0-1.1.noarch.rpm
	kopano-webapp-plugin-spell-en-us-2.0.0.0-1.1.noarch.rpm
	kopano-webapp-plugin-spell-es-es-2.0.0.0-1.1.noarch.rpm
	kopano-webapp-plugin-spell-fr-fr-2.0.0.0-1.1.noarch.rpm
	kopano-webapp-plugin-spell-nl-2.0.0.0-1.1.noarch.rpm
	kopano-webapp-plugin-spell-pl-pl-2.0.0.0-6.1.noarch.rpm
	kopano-webapp-plugin-titlecounter-3.3.0.375-299.1.noarch.rpm
	kopano-webapp-plugin-webappmanual-3.3.0.375-299.1.noarch.rpm
	kopano-webapp-plugin-zdeveloper-3.3.0.375-299.1.noarch.rpm
"

WEBAPP_PLUGIN_CONFIGS="
	contactfax
	delayeddelivery
	desktopnotifications
	filepreviewer
	gmaps
	pimfolder
	spellchecker
	titlecounter
	webappmanual
	zdeveloper
"

SRC_URI="https://download.kopano.io/community/webapp:/${WEBAPP_PACKAGE}.tar.gz"
S="${WORKDIR}/${WEBAPP_PACKAGE}"

LICENSE="AGPL-3"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"
IUSE="
	plugin_contactfax
	plugin_delayeddelivery
	plugin_desktopnotifications
	plugin_filepreviewer
	plugin_folderwidgets
	plugin_gmaps
	plugin_pimfolder
	plugin_quickitems
	plugin_spellchecker
	plugin_titlecounter
	plugin_webappmanual
	plugin_zdeveloper
	plugin_files
	plugin_mdm
	plugin_smime
"

PDEPEND="plugin_files? ( www-apps/kopano-webapp-files )
	plugin_mdm? ( www-apps/kopano-webapp-mdm )
	plugin_smime? ( www-apps/kopano-webapp-smime )"

need_php_httpd

pkg_setup () {
	webapp_pkg_setup
	require_php_with_use iconv session xml
	use plugin_spellchecker && require_php_with_use enchant
}

src_unpack() {
	unpack ${A}
	cd ${S}
	for p in ${WEBAPP_RPMS}; do
		elog "Unpacking ${p}"
		rpm2tar -O "${p}" | tar xf - || die "failure unpacking ${p}"
	done
}

src_prepare() {
	# rearrange external config files to have one single self-contained htdocs dir
	rm "${S}/usr/share/kopano-webapp/config.php" || die "Unexpected source layout; ebuild needs update"
	cp "${S}/etc/kopano/webapp/config.php" "${S}/usr/share/kopano-webapp/config.php" || die "Unexpected source layout; ebuild needs update"
	for c in ${WEBAPP_PLUGIN_CONFIGS}; do
		rm "${S}/usr/share/kopano-webapp/plugins/${c}/config.php" || die "Unexpected source layout; ebuild needs update"
		cp "${S}/etc/kopano/webapp/config-${c}.php" "${S}/usr/share/kopano-webapp/plugins/${c}/config.php" || die "Unexpected source layout; ebuild needs update"
	done
	if use plugin_contactfax; then
		elog Plugin contactfax available
	else
		rm -r "${S}/usr/share/kopano-webapp/plugins/contactfax" || die "Unexpected source layout; ebuild needs update"
		elog Plugin contactfax removed
	fi
	if use plugin_delayeddelivery; then
		elog Plugin delayeddelivery available
	else
		rm -r "${S}/usr/share/kopano-webapp/plugins/delayeddelivery" || die "Unexpected source layout; ebuild needs update"
		elog Plugin delayeddelivery removed
	fi
	if use plugin_desktopnotifications; then
		elog Plugin desktopnotifications available
	else
		rm -r "${S}/usr/share/kopano-webapp/plugins/desktopnotifications" || die "Unexpected source layout; ebuild needs update"
		elog Plugin desktopnotifications removed
	fi
	if use plugin_filepreviewer; then
		elog Plugin filepreviewer available
	else
		rm -r "${S}/usr/share/kopano-webapp/plugins/filepreviewer" || die "Unexpected source layout; ebuild needs update"
		elog Plugin filepreviewer removed
	fi
	if use plugin_folderwidgets; then
		elog Plugin folderwidgets available
	else
		rm -r "${S}/usr/share/kopano-webapp/plugins/folderwidgets" || die "Unexpected source layout; ebuild needs update"
		elog Plugin folderwidgets removed
	fi
	if use plugin_gmaps; then
		elog Plugin gmaps available
	else
		rm -r "${S}/usr/share/kopano-webapp/plugins/gmaps" || die "Unexpected source layout; ebuild needs update"
		elog Plugin gmaps removed
	fi
	if use plugin_pimfolder; then
		elog Plugin pimfolder available
	else
		rm -r "${S}/usr/share/kopano-webapp/plugins/pimfolder" || die "Unexpected source layout; ebuild needs update"
		elog Plugin pimfolder removed
	fi
	if use plugin_quickitems; then
		elog Plugin quickitems available
	else
		rm -r "${S}/usr/share/kopano-webapp/plugins/quickitems" || die "Unexpected source layout; ebuild needs update"
		elog Plugin quickitems removed
	fi
	if use plugin_spellchecker; then
		elog Plugin spellchecker available
	else
		rm -r "${S}/usr/share/kopano-webapp/plugins/spellchecker" || die "Unexpected source layout; ebuild needs update"
		rm -r "${S}/usr/share/kopano-webapp/plugins/spellchecker-languagepack-"* || die "Unexpected source layout; ebuild needs update"
		elog Plugin spellchecker removed
	fi
	if use plugin_titlecounter; then
		elog Plugin titlecounter available
	else
		rm -r "${S}/usr/share/kopano-webapp/plugins/titlecounter" || die "Unexpected source layout; ebuild needs update"
		elog Plugin titlecounter removed
	fi
	if use plugin_webappmanual; then
		elog Plugin webappmanual available
	else
		rm -r "${S}/usr/share/kopano-webapp/plugins/webappmanual" || die "Unexpected source layout; ebuild needs update"
		elog Plugin webappmanual removed
	fi
	if use plugin_zdeveloper; then
		elog Plugin zdeveloper available
	else
		rm -r "${S}/usr/share/kopano-webapp/plugins/zdeveloper" || die "Unexpected source layout; ebuild needs update"
		elog Plugin zdeveloper removed
	fi
}

src_install() {
	webapp_src_preinst

	dodir "/var/lib/kopano-webapp"
	keepdir "/var/lib/kopano-webapp"
	dodir "/var/lib/kopano-webapp/tmp"
	# prepare empty directories for extra plugins
	dodir "/var/lib/kopano-webapp/plugins"
    dodir "/etc/kopano/webapp"

	insinto "${MY_HTDOCSDIR}"
	doins -r "${S}"/usr/share/kopano-webapp/*

	webapp_serverowned "/var/lib/kopano-webapp/tmp"
	webapp_serverowned "/var/lib/kopano-webapp/plugins"
	webapp_serverowned "/etc/kopano/webapp"
	webapp_configfile "${MY_HTDOCSDIR}/config.php"
	for c in ${WEBAPP_PLUGIN_CONFIGS}; do
		if [[ -f "${MY_HTDOCSDIR}/plugins/${c}/config.php" ]]; then
			webapp_configfile "${MY_HTDOCSDIR}/plugins/${c}/config.php"
		fi
	done

	webapp_src_install
}
