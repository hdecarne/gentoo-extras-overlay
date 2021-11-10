# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

#
# awk '{print "\x27" $1 " " $2 "\x27"}' go.sum | sort -u
#
EGO_SUM=(
'github.com/AlecAivazis/survey/v2 v2.2.9'
'github.com/AlecAivazis/survey/v2 v2.2.9/go.mod'
'github.com/BurntSushi/toml v0.3.1'
'github.com/BurntSushi/toml v0.3.1/go.mod'
'github.com/cpuguy83/go-md2man/v2 v2.0.0-20190314233015-f79a8a8ca69d'
'github.com/cpuguy83/go-md2man/v2 v2.0.0-20190314233015-f79a8a8ca69d/go.mod'
'github.com/daixiang0/gci v0.2.8'
'github.com/daixiang0/gci v0.2.8/go.mod'
'github.com/davecgh/go-spew v1.1.0/go.mod'
'github.com/davecgh/go-spew v1.1.1'
'github.com/davecgh/go-spew v1.1.1/go.mod'
'github.com/dustin/go-humanize v1.0.0'
'github.com/dustin/go-humanize v1.0.0/go.mod'
'github.com/fatih/color v1.9.0'
'github.com/fatih/color v1.9.0/go.mod'
'github.com/fujiwara/shapeio v1.0.0'
'github.com/fujiwara/shapeio v1.0.0/go.mod'
'github.com/gocarina/gocsv v0.0.0-20210408192840-02d7211d929d'
'github.com/gocarina/gocsv v0.0.0-20210408192840-02d7211d929d/go.mod'
'github.com/golang/mock v1.5.0'
'github.com/golang/mock v1.5.0/go.mod'
'github.com/golang/protobuf v1.5.0/go.mod'
'github.com/google/go-cmp v0.5.5'
'github.com/google/go-cmp v0.5.5/go.mod'
'github.com/google/go-jsonnet v0.17.0'
'github.com/google/go-jsonnet v0.17.0/go.mod'
'github.com/hinshun/vt10x v0.0.0-20180616224451-1954e6464174'
'github.com/hinshun/vt10x v0.0.0-20180616224451-1954e6464174/go.mod'
'github.com/kballard/go-shellquote v0.0.0-20180428030007-95032a82bc51'
'github.com/kballard/go-shellquote v0.0.0-20180428030007-95032a82bc51/go.mod'
'github.com/kr/pretty v0.1.0'
'github.com/kr/pretty v0.1.0/go.mod'
'github.com/kr/pty v1.1.1/go.mod'
'github.com/kr/pty v1.1.4'
'github.com/kr/pty v1.1.4/go.mod'
'github.com/kr/text v0.1.0'
'github.com/kr/text v0.1.0/go.mod'
'github.com/MakeNowJust/heredoc/v2 v2.0.1'
'github.com/MakeNowJust/heredoc/v2 v2.0.1/go.mod'
'github.com/mattn/go-colorable v0.1.2/go.mod'
'github.com/mattn/go-colorable v0.1.4'
'github.com/mattn/go-colorable v0.1.4/go.mod'
'github.com/mattn/go-isatty v0.0.11/go.mod'
'github.com/mattn/go-isatty v0.0.13'
'github.com/mattn/go-isatty v0.0.13/go.mod'
'github.com/mattn/go-isatty v0.0.8/go.mod'
'github.com/mattn/go-runewidth v0.0.9'
'github.com/mattn/go-runewidth v0.0.9/go.mod'
'github.com/mgutz/ansi v0.0.0-20170206155736-9520e82c474b'
'github.com/mgutz/ansi v0.0.0-20170206155736-9520e82c474b/go.mod'
'github.com/Netflix/go-expect v0.0.0-20180615182759-c93bf25de8e8'
'github.com/Netflix/go-expect v0.0.0-20180615182759-c93bf25de8e8/go.mod'
'github.com/olekukonko/tablewriter v0.0.5'
'github.com/olekukonko/tablewriter v0.0.5/go.mod'
'github.com/pmezard/go-difflib v1.0.0'
'github.com/pmezard/go-difflib v1.0.0/go.mod'
'github.com/russross/blackfriday/v2 v2.0.1'
'github.com/russross/blackfriday/v2 v2.0.1/go.mod'
'github.com/sergi/go-diff v1.1.0'
'github.com/sergi/go-diff v1.1.0/go.mod'
'github.com/shurcooL/sanitized_anchor_name v1.0.0'
'github.com/shurcooL/sanitized_anchor_name v1.0.0/go.mod'
'github.com/stretchr/objx v0.1.0'
'github.com/stretchr/objx v0.1.0/go.mod'
'github.com/stretchr/testify v1.2.1/go.mod'
'github.com/stretchr/testify v1.4.0/go.mod'
'github.com/stretchr/testify v1.7.0'
'github.com/stretchr/testify v1.7.0/go.mod'
'github.com/urfave/cli v1.22.5'
'github.com/urfave/cli v1.22.5/go.mod'
'github.com/yuin/goldmark v1.2.1/go.mod'
'go.etcd.io/bbolt v1.3.6'
'go.etcd.io/bbolt v1.3.6/go.mod'
'golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod'
'golang.org/x/crypto v0.0.0-20190530122614-20be4c3c3ed5/go.mod'
'golang.org/x/crypto v0.0.0-20191011191535-87dc89f01550/go.mod'
'golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9'
'golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9/go.mod'
'golang.org/x/mod v0.3.0'
'golang.org/x/mod v0.3.0/go.mod'
'golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod'
'golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod'
'golang.org/x/net v0.0.0-20201021035429-f5854403a974/go.mod'
'golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod'
'golang.org/x/sync v0.0.0-20201020160332-67f06af15bc9/go.mod'
'golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod'
'golang.org/x/sys v0.0.0-20190222072716-a9d3bda3a223/go.mod'
'golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod'
'golang.org/x/sys v0.0.0-20190530182044-ad28b68e88f1/go.mod'
'golang.org/x/sys v0.0.0-20191026070338-33540a1f6037/go.mod'
'golang.org/x/sys v0.0.0-20200116001909-b77594299b42/go.mod'
'golang.org/x/sys v0.0.0-20200923182605-d9f96fdee20d/go.mod'
'golang.org/x/sys v0.0.0-20200930185726-fdedc70b468f/go.mod'
'golang.org/x/sys v0.0.0-20210119212857-b64e53b001e4/go.mod'
'golang.org/x/sys v0.0.0-20210831042530-f4d43177bf5e'
'golang.org/x/sys v0.0.0-20210831042530-f4d43177bf5e/go.mod'
'golang.org/x/text v0.3.0/go.mod'
'golang.org/x/text v0.3.3'
'golang.org/x/text v0.3.3/go.mod'
'golang.org/x/time v0.0.0-20210220033141-f8bda1e9f3ba'
'golang.org/x/time v0.0.0-20210220033141-f8bda1e9f3ba/go.mod'
'golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod'
'golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod'
'golang.org/x/tools v0.0.0-20201118003311-bd56c0adb394/go.mod'
'golang.org/x/tools v0.1.0'
'golang.org/x/tools v0.1.0/go.mod'
'golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod'
'golang.org/x/xerrors v0.0.0-20191011141410-1b5146add898/go.mod'
'golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod'
'golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1'
'golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1/go.mod'
'google.golang.org/protobuf v1.26.0-rc.1/go.mod'
'google.golang.org/protobuf v1.27.1'
'google.golang.org/protobuf v1.27.1/go.mod'
'gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod'
'gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15'
'gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15/go.mod'
'gopkg.in/yaml.v2 v2.2.2/go.mod'
'gopkg.in/yaml.v2 v2.2.4/go.mod'
'gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c'
'gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod'
'honnef.co/go/tools v0.2.0'
'honnef.co/go/tools v0.2.0/go.mod'
)

go-module_set_globals

DESCRIPTION="CLI for managing resources in InfluxDB v2"
HOMEPAGE="https://influxdata.com"

SRC_PV="${PV/_/}"

SRC_URI="https://github.com/influxdata/${PN}/archive/v${SRC_PV}.tar.gz -> ${P}.tar.gz
		${EGO_SUM_SRC_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-db/influxdb-2.1.0"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

RESTRICT="mirror"

src_compile() {
	CGO_ENABLED=0 \
	BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	go build -ldflags "-X main.date=${BUILD_DATE} -X main.version=${PV}" -o influx ./cmd/influx
}

src_install() {
	dobin "${S}/influx"
}
