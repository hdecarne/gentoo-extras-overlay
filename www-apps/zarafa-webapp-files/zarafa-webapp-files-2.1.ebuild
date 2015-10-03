# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils rpm

ZARAFA_WEBAPP_PLUGIN="files"

DESCRIPTION="Zarafa WebApp plugins"
HOMEPAGE="http://zarafa.com/"

SRC_URI="http://download.zarafa.com/community/final/WebApp/2.1.0/rhel-7/zarafa-webapp-${ZARAFA_WEBAPP_PLUGIN}-2.1.0.51748-419.1.noarch.rpm"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror"

DEPEND="www-apps/zarafa-webapp
	!www-apps/zarafa-webapp-plugins"

RDEPEND="${DEPEND}"

S="${WORKDIR}/usr/share/zarafa-webapp"

src_install() {
	dodir "/var/lib/zarafa-webapp/plugins"
	dodir "/etc/zarafa/webapp"
	cp -R "${WORKDIR}/usr/share/zarafa-webapp/plugins/${ZARAFA_WEBAPP_PLUGIN}" "${D}/var/lib/zarafa-webapp/plugins/"
	cp "${WORKDIR}/etc/zarafa/webapp/config-${ZARAFA_WEBAPP_PLUGIN}.php" "${D}/etc/zarafa/webapp/"
	fowners -R apache:apache "/var/lib/zarafa-webapp/plugins/${ZARAFA_WEBAPP_PLUGIN}"
}
