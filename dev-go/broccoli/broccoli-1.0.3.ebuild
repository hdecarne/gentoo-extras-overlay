# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

#
# awk '{print "\x27" $1 " " $2 "\x27"}' go.sum | sort
#
EGO_SUM=(
'aletheia.icu/broccoli/fs v0.0.0-20200417133515-96f8feb4daae'
'aletheia.icu/broccoli/fs v0.0.0-20200417133515-96f8feb4daae/go.mod'
'aletheia.icu/broccoli/fs v0.0.0-20200420162907-e7ff440cf358'
'aletheia.icu/broccoli/fs v0.0.0-20200420162907-e7ff440cf358/go.mod'
'github.com/andybalholm/brotli v1.0.0'
'github.com/andybalholm/brotli v1.0.0/go.mod'
'github.com/davecgh/go-spew v1.1.0'
'github.com/davecgh/go-spew v1.1.0/go.mod'
'github.com/davecgh/go-spew v1.1.1'
'github.com/davecgh/go-spew v1.1.1/go.mod'
'github.com/pkg/errors v0.9.1'
'github.com/pkg/errors v0.9.1/go.mod'
'github.com/pmezard/go-difflib v1.0.0'
'github.com/pmezard/go-difflib v1.0.0/go.mod'
'github.com/sabhiram/go-gitignore v0.0.0-20180611051255-d3107576ba94'
'github.com/sabhiram/go-gitignore v0.0.0-20180611051255-d3107576ba94/go.mod'
'github.com/stretchr/objx v0.1.0/go.mod'
'github.com/stretchr/testify v1.5.1'
'github.com/stretchr/testify v1.5.1/go.mod'
'gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405'
'gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod'
'gopkg.in/yaml.v2 v2.2.2'
'gopkg.in/yaml.v2 v2.2.2/go.mod'
)

go-module_set_globals

DESCRIPTION="Using brotli compression to embed static files in Go."
HOMEPAGE="https://github.com/thealetheia/broccoli"

SRC_URI="https://github.com/thealetheia/broccoli/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="mirror"

RDEPEND=""

DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig"

src_install() {
	dodoc README.md
	dobin broccoli
}
