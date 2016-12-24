# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Kopano WebApp plugins"
HOMEPAGE="http://kopano.io/"

PLUGIN="files"
PLUGIN_PACKAGE="files-0.5.0_30.1-RHEL_7-x86_64"
PLUGIN_RPMS="
	kopano-webapp-plugin-files-2.0.0.51-20.1.noarch.rpm
	kopano-webapp-plugin-filesbackend-owncloud-2.0.0.17-8.1.noarch.rpm
	kopano-webapp-plugin-filesbackend-smb-2.0.0.17-14.1.noarch.rpm
"

SRC_URI="https://download.kopano.io/community/files:/${PLUGIN_PACKAGE}.tar.gz"
S="${WORKDIR}/${PLUGIN_PACKAGE}"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror"

DEPEND="www-apps/kopano-webapp"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}
	for p in ${PLUGIN_RPMS}; do
		elog "Unpacking ${p}"
		rpm2tar -O "${p}" | tar xf - || die "failure unpacking ${p}"
	done
}

src_install() {
	dodir "/var/lib/kopano-webapp/plugins"
	cp -R "${S}/usr/share/kopano-webapp/plugins/"* "${D}/var/lib/kopano-webapp/plugins/"
	fowners -R apache:apache "/var/lib/kopano-webapp/plugins/"
	dodir "/etc/kopano/webapp"
	cp "${S}/etc/kopano/webapp/"* "${D}/etc/kopano/webapp/"
	fowners -R apache:apache "/etc/kopano/webapp/"
}

pkg_postinst() {
	elog
	elog "The plugin has been installed to the system's plugin directory:"
	elog "    /var/lib/kopano-webapp/plugins"
	elog
	elog "To enable the plugin place symlink it's plugin folder into your"
	elog "WebApps installation's plugin directory"
	elog "E.g. cd /var/www/localhost/htdocs/webapp/plugins;"
	elog "     ln -s /var/lib/kopano-webapp/plugins/files files;"
	elog "     ln -s /var/lib/kopano-webapp/plugins/filesbackendOwncloud filesbackendOwncloud;"
	elog "     ln -s /var/lib/kopano-webapp/plugins/filesbackendSMB filesbackendSMB"
	elog
	elog "Furthmore check the plugin specific configuration steps."
	elog
}
