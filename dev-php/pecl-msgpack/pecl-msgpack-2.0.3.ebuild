# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PHP_EXT_NAME="msgpack"
DOCS="ChangeLog LICENSE README.md"
USE_PHP="php7-1 php7-2 php7-3 php7-4"

inherit php-ext-pecl-r3

KEYWORDS="amd64 x86"

DESCRIPTION="PHP extension for interfacing with MessagePack"
LICENSE="BSD"
SLOT="0"
IUSE=""

#DEPEND="dev-libs/geoip"
#RDEPEND="${DEPEND}"

#PATCHES=( "${FILESDIR}/fix-failing-tests-1.1.1.patch" )
