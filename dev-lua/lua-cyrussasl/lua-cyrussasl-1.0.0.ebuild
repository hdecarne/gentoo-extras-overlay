# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils flag-o-matic

DESCRIPTION="Cyrus SASL library for Lua 5.1"
HOMEPAGE="https://github.com/JorjBauer/${PN}"
SRC_URI="https://github.com/JorjBauer/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"
LICENSE="BSD"
SLOT="0"
IUSE=""
DEPEND="
	>=dev-lang/lua-5.1
	dev-libs/cyrus-sasl"
RDEPEND="${DEPEND}"

# S=${WORKDIR}/${P}

src_prepare() {
	epatch "${FILESDIR}/${PN}-update_makefile.patch"
}

src_configure() {

	append-flags "-I/usr/include/lua5.1 -fPIC -g"  || die "could not append flags"
	append-ldflags "-shared -fPIC -lsasl2"  || die "could not append ldflags"
	
	# No configure script, only a simple Makefile
	return
}

src_install() {

	# Create the usr/lib/lua/5.1
	mkdir -p "${D}usr/lib/lua/5.1"

	if [[ -f Makefile ]] || [[ -f GNUmakefile ]] || [[ -f makefile ]] ; then
		emake DESTDIR="${D}" install
	fi

	if ! declare -p DOCS >/dev/null 2>&1 ; then
		local d
		for d in README* ChangeLog AUTHORS NEWS TODO CHANGES THANKS BUGS \
				FAQ CREDITS CHANGELOG ; do
			[[ -s "${d}" ]] && dodoc "${d}"
		done
	# TODO: wrong "declare -a" command...
	elif declare -p DOCS | grep -q `^declare -a` ; then
		dodoc "${DOCS[@]}"
	else
		dodoc ${DOCS}
	fi
}
