# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Podman Terminal UI"
HOMEPAGE="https://github.com/containers/podman-tui/"

SRC_URI="https://github.com/containers/${PN}/archive/refs/tags/v${PV}.tar.gz"

LICENSE="Appache-2.0"
SLOT="0"
KEYWORDS="amd64"

src_compile() {
	emake binary
}

src_install() {
	dobin "${S}/bin/podman-tui"
}
