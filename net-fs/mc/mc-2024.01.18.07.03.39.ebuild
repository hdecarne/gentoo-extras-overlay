# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

MY_PV="$(ver_cut 1-3)T$(ver_cut 4-7)Z"
MY_PV=${MY_PV//./-}

MC_RELEASE="RELEASE"

S="${WORKDIR}/${PN}-${MC_RELEASE}.${MY_PV}"

DESCRIPTION="Simple | Fast tool to manage MinIO clusters."
HOMEPAGE="https://min.io/"
SRC_URI="https://github.com/minio/mc/archive/refs/tags/${MC_RELEASE}.${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

RESTRICT="strip network-sandbox"

RDEPEND="!!app-misc/mc"

src_compile() {
	PKG="github.com/minio/mc"
	GOLDFLAGS="-s -w"
	GOLDFLAGS="${GOLDFLAGS} -X ${PKG}/cmd.Version=${MY_PV}"
	GOLDFLAGS="${GOLDFLAGS} -X ${PKG}/cmd.CopyrightYear=${MY_PV:0:4}"
	GOLDFLAGS="${GOLDFLAGS} -X ${PKG}/cmd.ReleaseTag=${MC_RELEASE}.${MY_PV}"
	GOLDFLAGS="${GOLDFLAGS} -X ${PKG}/cmd.CommitID=0000000000000000000000000000000000000000"
	GOLDFLAGS="${GOLDFLAGS} -X ${PKG}/cmd.ShortCommitID=000000000000"
	CGO_ENABLED=1 go build -tags kqueue -trimpath -ldflags "${GOLDFLAGS}" -o ${PN} || die "compile failed"
}

src_install() {
	dobin "${PN}"
}
