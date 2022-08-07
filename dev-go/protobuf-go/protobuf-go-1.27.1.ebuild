# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Compile-time Dependency Injection for Go"
HOMEPAGE="https://github.com/google/wire"

SRC_URI="https://github.com/protocolbuffers/protobuf-go/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/hdecarne/gentoo-extras-overlay/releases/download/${P}/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="strip"

RDEPEND=""

DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig"

src_compile() {
	go build -o "${S}/protoc-gen-go" google.golang.org/protobuf/cmd/protoc-gen-go
}

src_install() {
	dodoc README.md
	dobin "protoc-gen-go"
}
