# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils rpm

ZARAFA_WEBAPP_PLUGIN="mdm"

DESCRIPTION="Zarafa WebApp plugins"
HOMEPAGE="http://zarafa.com/"

SRC_URI="http://download.zarafa.com/community/final/WebApp/plugins/MDM%201.0/rhel-7/zarafa-webapp-plugins-mdm-1.0.1453470163.f6c94a8-34.2.noarch.rpm"
LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror"

DEPEND=">=www-apps/zarafa-webapp-2.0
	>=www-apps/z-push-2.2"

RDEPEND="${DEPEND}"

S="${WORKDIR}/usr/share/zarafa-webapp"

src_install() {
	dodir "/var/lib/zarafa-webapp/plugins"
	dodir "/etc/zarafa/webapp"
	cp -R "${WORKDIR}/usr/share/zarafa-webapp/plugins/${ZARAFA_WEBAPP_PLUGIN}" "${D}/var/lib/zarafa-webapp/plugins/"
	cp "${WORKDIR}/etc/zarafa/webapp/config-${ZARAFA_WEBAPP_PLUGIN}.php" "${D}/etc/zarafa/webapp/"
	fowners -R apache:apache "/var/lib/zarafa-webapp/plugins/${ZARAFA_WEBAPP_PLUGIN}"
}
