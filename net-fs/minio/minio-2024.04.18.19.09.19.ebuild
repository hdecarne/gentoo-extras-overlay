# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

MY_PV="$(ver_cut 1-3)T$(ver_cut 4-7)Z"
MY_PV=${MY_PV//./-}

MINIO_RELEASE="RELEASE"

S="${WORKDIR}/${PN}-${MINIO_RELEASE}.${MY_PV}"

DESCRIPTION="The Object Store for AI Data Infrastructure."
HOMEPAGE="https://min.io/"
SRC_URI="https://github.com/minio/minio/archive/refs/tags/${MINIO_RELEASE}.${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

RESTRICT="strip network-sandbox"

RDEPEND="acct-group/minio
	acct-user/minio"
DEPEND="${RDEPEND}"

src_compile() {
	PKG="github.com/minio/minio"
	GOLDFLAGS="-s -w"
	GOLDFLAGS="${GOLDFLAGS} -X ${PKG}/cmd.Version=${MY_PV}"
	GOLDFLAGS="${GOLDFLAGS} -X ${PKG}/cmd.CopyrightYear=${MY_PV:0:4}"
	GOLDFLAGS="${GOLDFLAGS} -X ${PKG}/cmd.ReleaseTag=${MINIO_RELEASE}.${MY_PV}"
	GOLDFLAGS="${GOLDFLAGS} -X ${PKG}/cmd.CommitID=0000000000000000000000000000000000000000"
	GOLDFLAGS="${GOLDFLAGS} -X ${PKG}/cmd.ShortCommitID=000000000000"
	GOLDFLAGS="${GOLDFLAGS} -X ${PKG}/cmd.GOPATH=$(go env GOPATH)"
	GOLDFLAGS="${GOLDFLAGS} -X ${PKG}/cmd.GOROOT=$(go env GOROOT)"
	CGO_ENABLED=1 go build -tags kqueue -trimpath -ldflags "${GOLDFLAGS}" -o ${PN} || die "compile failed"
}

src_install() {
	dobin "${PN}"

	keepdir "/etc/${PN}"
	keepdir "/var/lib/${PN}"
	keepdir "/var/log/${PN}"

	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"

	insinto "/etc/${PN}"
	doins "${FILESDIR}/${PN}"

	fowners -R minio:minio "/etc/${PN}"
	fperms -R 0640 "/etc/${PN}"
	fowners -R minio:minio "/var/lib/${PN}"
	fperms -R 0640 "/var/lib/${PN}"
	fowners -R minio:minio "/var/log/${PN}"
	fperms -R 0640 "/var/log/${PN}"
}
