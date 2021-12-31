# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PHP_EXT_NAME="msgpack"
DOCS="LICENSE README.md"
USE_PHP="php7-3 php7-4 php8-0 php8-1"

inherit php-ext-pecl-r3

KEYWORDS="amd64 x86"

DESCRIPTION="PHP extension for interfacing with MessagePack"
LICENSE="BSD"
SLOT="0"
IUSE=""
