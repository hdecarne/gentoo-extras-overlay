# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit java-pkg-2 java-ant-2

DESCRIPTION="Open Source Groupware Solution"
HOMEPAGE="http://kopanoio/"

PLUGIN_NAME="filesbackendOwncloud"
PLUGIN_REPO="files-owncloud-backend"
PLUGIN_SRC_URI_TAG="v2.0.0"
WEBAPP_SRC_URI_TAG="v3.2.0"

SRC_URI="https://stash.kopano.io/rest/archive/latest/projects/KWA/repos/${PLUGIN_REPO}/archive?at=refs%2Ftags%2F${PLUGIN_SRC_URI_TAG}&prefix=${P}/plugins/${PLUGIN_NAME}&format=tar.gz -> ${P}.tar.gz
	https://stash.kopano.io/rest/archive/latest/projects/KW/repos/kopano-webapp/archive?at=refs%2Ftags%2F${WEBAPP_SRC_URI_TAG}&prefix=${P}&format=tar.gz -> ${P}-KW.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND=">=virtual/jdk-1.6
	www-apps/kopano-webapp
	www-apps/kopano-webapp-files"

EANT_EXTRA_ARGS="-Dbuild.sysclasspath=last"
EANT_BUILD_TARGET="all deploy deploy-plugins"

HTTPD_OWNER="apache:apache"

src_prepare() {
	default
	eapply "${FILESDIR}/kopano-webapp-files-owncloud-backend-2.0.0-build.patch"
	eapply_user
}

src_compile() {
	# php lint calls during build may trigger these
	addpredict /var/lib/net-snmp/mib_indexes/0

	java-pkg-2_src_compile
}

src_install() {
	dodir "/var/lib/kopano-webapp/plugins"
	dodir "/etc/kopano/webapp"
	cp -R "${S}/deploy/plugins/${PLUGIN_NAME}" "${D}/var/lib/kopano-webapp/plugins/${PLUGIN_NAME}"
	fowners -R ${HTTPD_OWNER} "/var/lib/kopano-webapp/plugins/${PLUGIN_NAME}"
	if [[ -f "${D}/var/lib/kopano-webapp/plugins/${PLUGIN_NAME}/config.php" ]]; then
		mv "${D}/var/lib/kopano-webapp/plugins/${PLUGIN_NAME}/config.php" "${D}/etc/kopano/webapp/config-${PLUGIN_NAME}.php"
		dosym "/etc/kopano/webapp/config-${PLUGIN_NAME}.php" "/var/lib/kopano-webapp/plugins/${PLUGIN_NAME}/config.php"
	fi
}
