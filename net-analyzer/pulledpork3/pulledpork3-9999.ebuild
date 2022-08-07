# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

if [[ ${PV} == *9999 ]]; then
	inherit git-r3 python-r1
else
	inherit python-r1
fi

DESCRIPTION="Pulled Pork for Snort3 rule management"

HOMEPAGE="https://github.com/shirkdog/pulledpork3"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/shirkdog/pulledpork3.git"
	EGIT_BRANCH="main"
else
	SRC_URI="https://github.com/shirkdog/pulledpork3/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~amd64"

IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="net-analyzer/snort3
	dev-python/requests
	${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

src_install() {
	default
	insinto /etc/snort
	doins etc/pulledpork.conf
	keepdir /var/lib/snort/pulledpork
	cp -vpPR pulledpork.py ${D}/var/lib/snort/pulledpork
	cp -vpPR lib ${D}/var/lib/snort/pulledpork/
}
