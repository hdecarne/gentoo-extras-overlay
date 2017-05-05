# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit java-pkg-2 java-ant-2 webapp

DESCRIPTION="Open Source Groupware Solution"
HOMEPAGE="http://kopanoio/"

SRC_URI_TAG="v3.3.0"

SRC_URI="https://stash.kopano.io/rest/archive/latest/projects/KW/repos/kopano-webapp/archive?at=refs%2Ftags%2F${SRC_URI_TAG}&prefix=${P}&format=tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

WEBAPP_CORE_PLUGINS="
	contactfax
	folderwidgets
	gmaps
	pimfolder
	quickitems
	titlecounter
	webappmanual
	zdeveloper
"

IUSE="
	debug
	plugin_filepreviewer
	plugin_files
	plugin_mdm
	plugin_smime
"

for p in ${WEBAPP_CORE_PLUGINS}; do
	IUSE="${IUSE} plugin_${p}"
done

DEPEND=">=virtual/jdk-1.6
	>=virtual/httpd-php-5.6
	sys-devel/gettext"

PDEPEND="plugin_filepreviewer? ( www-apps/kopano-webapp-filepreviewer )
	plugin_files? ( www-apps/kopano-webapp-files )
	plugin_mdm? ( www-apps/kopano-webapp-mdm )
	plugin_smime? ( www-apps/kopano-webapp-smime )"

EANT_EXTRA_ARGS="-Dbuild.sysclasspath=last"
EANT_BUILD_TARGET="all deploy deploy-plugins"

src_prepare() {
	epatch "${FILESDIR}/kopano-webapp-8.2.0-invalid-moduleObjects.patch"
	eapply_user
	echo "${PVR}" > version
}

src_compile() {
	# php lint calls during build may trigger these
	addpredict /var/lib/net-snmp/mib_indexes/0

	java-pkg-2_src_compile

	# remove unwanted files
	rm "deploy/kopano-webapp.conf"
	# remove unwanted plugins
	for p in ${WEBAPP_CORE_PLUGINS}; do
		if ! use plugin_${p}; then
			einfo "  Removing plugin ${p}"
			rm -r "deploy/plugins/${p}"
		fi
	done
	# prepare config files
	mv "deploy/config.php.dist" "deploy/config.php"
	if use debug; then
		mv "deploy/debug.php.dist" "deploy/debug.php"
	else
		rm "deploy/debug.php.dist"
	fi
}

src_install() {
	webapp_src_preinst

	dodir "/var/lib/kopano-webapp"
	keepdir "/var/lib/kopano-webapp"
	dodir "/var/lib/kopano-webapp/tmp"

	# prepare directories for extra plugins
	dodir "/var/lib/kopano-webapp/plugins"
    dodir "/etc/kopano/webapp"

	dodoc "AGPL-3" "LICENSE.txt" "kopano-webapp.conf"

	insinto "${MY_HTDOCSDIR}"
	doins -r "deploy"/*

	webapp_serverowned "/var/lib/kopano-webapp/tmp"
	webapp_serverowned "/var/lib/kopano-webapp/plugins"
	webapp_serverowned "/etc/kopano/webapp"
	webapp_configfile "${MY_HTDOCSDIR}/config.php"
	for p in ${WEBAPP_CORE_PLUGINS}; do
		if [[ -f "${MY_HTDOCSDIR}/plugins/${c}/config.php" ]]; then
			webapp_configfile "${MY_HTDOCSDIR}/plugins/${c}/config.php"
		fi
	done

	webapp_src_install
}
