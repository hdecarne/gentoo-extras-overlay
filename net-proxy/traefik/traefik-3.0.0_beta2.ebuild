# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module fcaps

DESCRIPTION="The Cloud Native Application Proxy"

HOMEPAGE="https://traefik.io"

MY_PV=${PV/_beta/-beta}
S=${WORKDIR}

SRC_URI="https://github.com/traefik/traefik/releases/download/v${MY_PV}/traefik-v${MY_PV}.src.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="strip network-sandbox"

RDEPEND="acct-group/traefik
	acct-user/traefik"

DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig"

FILECAPS=(
	-m 755 'cap_net_bind_service=+ep' usr/bin/traefik
)

src_compile() {
	go generate || die "compile failed"
	VERSION=${PV} \
	CODENAME="cheddar" \
	DATE=$(date -u '+%Y-%m-%d_%I:%M:%S%p') \
	CGO_ENABLED=0 \
	GOGC=off \
	go build -ldflags "-s -w \
		-X github.com/traefik/traefik/v2/pkg/version.Version=${VERSION} \
		-X github.com/traefik/traefik/v2/pkg/version.Codename=${CODENAME} \
		-X github.com/traefik/traefik/v2/pkg/version.BuildDate=${DATE}" \
		-installsuffix nocgo -o traefik ./cmd/traefik || die "compile failed"
}

src_install() {
	dostrip "./traefik"
	dobin "./traefik"

	einstalldocs

	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"

	keepdir "/etc/${PN}"
	fowners ${PN}:${PN} "/etc/${PN}"
	fperms 0750 "/etc/${PN}"

	keepdir "/var/lib/${PN}"
	fowners ${PN}:${PN} "/var/lib/${PN}"
	fperms 0750 "/var/lib/${PN}"

	keepdir "/var/log/${PN}"
	fowners ${PN}:${PN} "/var/log/${PN}"
	fperms 0750 "/var/log/${PN}"

	insinto "/etc/${PN}"
	newins "./traefik.sample.toml" "traefik.toml.example"
	newins "./traefik.sample.yml" "traefik.yml.example"
}
