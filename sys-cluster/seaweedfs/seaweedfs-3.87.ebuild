# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8


inherit go-module

DESCRIPTION="SeaweedFS is a fast distributed storage system."

HOMEPAGE="https://seaweedfs.com/"

SRC_URI="https://github.com/seaweedfs/seaweedfs/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"


LICENSE="Apache-2.0"

SLOT="0"

KEYWORDS="~amd64"

IUSE="fuse"

RESTRICT="strip network-sandbox"


RDEPEND="acct-group/${PN}
	acct-user/${PN}
	fuse? ( sys-fs/fuse )"

DEPEND="${RDEPEND}"


CONFIGS="filer notification replication security master"
SERVICES="master volume filer"

src_compile() {
	pushd weed || die "compile failed"
	emake install
	popd
	for config in ${CONFIGS}; do
		"${HOME}/go/bin/weed" scaffold -config ${config} -output . || die "compile failed"
	done
}

src_install() {
	dobin "${HOME}/go/bin/weed"

	for service in ${SERVICES}; do
		newconfd "${FILESDIR}/weed-${service}.confd" "weed-${service}"
		newinitd "${FILESDIR}/weed-${service}.initd" "weed-${service}"
	done

	keepdir "/etc/${PN}"
	keepdir "/var/log/${PN}"

	insinto "/etc/${PN}"
	for config in ${CONFIGS}; do
		doins "${config}.toml"
	done

	fowners -R ${PN}:${PN} "/etc/${PN}"
	fowners -R ${PN}:${PN} "/var/log/${PN}"
}
