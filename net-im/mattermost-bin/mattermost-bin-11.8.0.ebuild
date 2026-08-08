# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="mattermost"

DESCRIPTION="Mattermost is an open source platform for secure collaboration."
HOMEPAGE="https://mattermost.com/"
SRC_URI="amd64? ( https://releases.mattermost.com/${PV}/mattermost-${PV}-linux-amd64.tar.gz )
	arm64? ( https://releases.mattermost.com/${PV}/mattermost-${PV}-linux-arm64.tar.gz )"

S="${WORKDIR}/${MY_PN}"

LICENSE=""
SLOT="0"
KEYWORDS="~arm64 ~amd64"

RESTRICT="strip"

RDEPEND="acct-group/${MY_PN}
	acct-user/${MY_PN}"

DEPEND="${RDEPEND}"

src_install() {
	keepdir "/var/lib/${MY_PN}"
	keepdir "/var/lib/${MY_PN}/plugins"
	keepdir "/var/lib/${MY_PN}/client/plugins"
	fowners -R ${MY_PN}:${MY_PN} "/var/lib/${MY_PN}"
	fperms -R g+w "/var/lib/${MY_PN}"

	dodir "/opt/${MY_PN}"
	insinto "/opt/${MY_PN}"
	doins -r "${S}/."
	dosym "../../var/lib/${MY_PN}/plugins" "/opt/${MY_PN}/plugins"
	dosym "../../../var/lib/${MY_PN}/client/plugins" "/opt/${MY_PN}/client/plugins"
	fowners -R ${MY_PN}:${MY_PN} "/opt/${MY_PN}"
	fperms -R g+w "/opt/${MY_PN}"
	fperms ugo+x "/opt/${MY_PN}/bin/mattermost"
	fperms ugo+x "/opt/${MY_PN}/bin/mmctl"

	dodir "/etc/${MY_PN}"
	insinto "/etc/${MY_PN}"
	doins -r "${S}/config/."
	fowners -R ${MY_PN}:${MY_PN} "/etc/${MY_PN}"
	fperms -R g+w "/etc/${MY_PN}"

	keepdir "/var/log/${MY_PN}"
	fowners -R ${MY_PN}:${MY_PN} "/var/log/${MY_PN}"
	fperms -R g+w "/var/log/${MY_PN}"

	newconfd "${FILESDIR}/${MY_PN}.confd" "${MY_PN}"
	newinitd "${FILESDIR}/${MY_PN}.initd" "${MY_PN}"
}
