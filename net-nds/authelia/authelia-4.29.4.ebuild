# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="The Single Sign-On Multi-Factor portal for web apps"

HOMEPAGE="https://www.authelia.com/"

SWAGGER_PV="3.48.0"
SWAGGER_P="swagger-ui-${SWAGGER_PV}"

SRC_URI="https://github.com/authelia/authelia/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/swagger-api/swagger-ui/archive/refs/tags/v${SWAGGER_PV}.tar.gz -> ${SWAGGER_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="mysql postgres redis sqlite"
REQUIRED_USE="|| ( mysql postgres sqlite )"

RESTRICT="strip network-sandbox"

RDEPEND="acct-group/authelia
	acct-user/authelia
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql:* )
	sqlite? ( dev-db/sqlite:3 )
	redis? ( dev-db/redis )"

DEPEND="${RDEPEND}"

BDEPEND="dev-go/broccoli
	net-libs/nodejs
	sys-apps/yarn
	virtual/pkgconfig"

YARN_OPTIONS="--no-progress --network-concurrency 1 --network-timeout 3000000"

src_prepare() {
	eapply_user
	sed -i "s|__BUILD_COMMIT__|v${PV}|" ./cmd/authelia/constants.go || die "prepare failed"
	sed -i "s|__BUILD_TAG__|v${PV}|" cmd/authelia/constants.go || die "prepare failed"
}

src_configure() {
	pushd "./web"
	yarn ${YARN_OPTIONS} install || die "configure failed"
	popd
}

src_compile() {
	pushd "./web"
	INLINE_RUNTIME_CHUNK=false yarn ${YARN_OPTIONS} build || die "compile failed"
	popd
	cp -R "${WORKDIR}/${SWAGGER_P}/dist/"* "./internal/server/public_html/api/" || die "compile failed"
	cp -R "./api/"* "./internal/server/public_html/api/" || die "compile failed"
	cp -R "./web/build/"* "./internal/server/public_html/" || die "compile failed"
	GOOS=linux GOARCH=amd64 CGO_ENABLED=1 go build ./cmd/authelia || die "compile failed"
}

src_install() {
	dobin "./authelia"

	insinto "/etc/authelia"
	newins "config.template.yml" "config.yml"

	newconfd "${FILESDIR}/authelia.confd" "authelia"
	newinitd "${FILESDIR}/authelia.initd" "authelia"

	dodoc README.md SECURITY.md

	fowners authelia:authelia "/etc/authelia"
	fowners authelia:authelia "/etc/authelia/config.yml"
	fperms 600 "/etc/authelia/config.yml"

	keepdir "/var/log/authelia"
	fowners authelia:authelia "/var/log/authelia"
}
