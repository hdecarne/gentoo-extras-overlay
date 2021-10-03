# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

#
# awk '{print "\x27" $1 " " $2 "\x27"}' go.sum | sort
#
EGO_SUM=(
'github.com/google/go-cmp v0.2.0'
'github.com/google/go-cmp v0.2.0/go.mod'
'github.com/google/subcommands v1.0.1'
'github.com/google/subcommands v1.0.1/go.mod'
'github.com/pmezard/go-difflib v1.0.0'
'github.com/pmezard/go-difflib v1.0.0/go.mod'
'golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod'
'golang.org/x/net v0.0.0-20190311183353-d8887717615a/go.mod'
'golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod'
'golang.org/x/sys v0.0.0-20190222072716-a9d3bda3a223'
'golang.org/x/sys v0.0.0-20190222072716-a9d3bda3a223/go.mod'
'golang.org/x/text v0.3.0'
'golang.org/x/text v0.3.0/go.mod'
'golang.org/x/tools v0.0.0-20190422233926-fe54fb35175b'
'golang.org/x/tools v0.0.0-20190422233926-fe54fb35175b/go.mod'
)

go-module_set_globals

DESCRIPTION="Compile-time Dependency Injection for Go"
HOMEPAGE="https://github.com/google/wire"

SRC_URI="https://github.com/google/wire/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="mirror"

RDEPEND=""

DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig"

src_compile() {
	go build -o "${S}/${PN}" github.com/google/wire/cmd/wire
}

src_install() {
	dodoc README.md
	dobin "${PN}"
}
