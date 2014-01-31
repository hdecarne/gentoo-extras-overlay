# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="A powerful C++ class library for working with MIME messages and services like IMAP, POP or SMTP."
HOMEPAGE="http://www.vmime.org/"

ZARAFA_PV="${PV}+svn603"

SRC_URI="http://download.zarafa.com/community/final/7.0/7.0.5-31880/sourcecode/libvmime-${ZARAFA_PV}.tar.bz2 -> libvmime-zcp-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RESTRICT="mirror"
IUSE="debug doc examples +imap +maildir +pop sasl sendmail +smtp ssl static"

RDEPEND="!dev-cpp/libvmime
	virtual/libiconv
	sasl? ( virtual/gsasl )
	ssl? ( net-libs/gnutls )
	sendmail? ( virtual/mta )"

DEPEND="${RDEPEND}
      doc? ( app-doc/doxygen )"

S="${WORKDIR}/libvmime-${PV}"

src_prepare() {
	EPATCH_SOURCE="${FILESDIR}" EPATCH_SUFFIX="diff" EPATCH_FORCE="yes" \
		epatch
	sed -i \
		-e "s|doc/\${PACKAGE_TARNAME}|doc/${PF}|" \
		-e "s|doc/\$(GENERIC_LIBRARY_NAME)|doc/${PF}|" \
		configure Makefile.in || die "sed failed"
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable sasl) \
		$(use_enable ssl tls) \
		$(use_enable static) \
		--enable-platform-posix \
		--enable-messaging \
		$(use_enable pop messaging-proto-pop3) \
		$(use_enable smtp messaging-proto-smtp) \
		$(use_enable imap messaging-proto-imap) \
		$(use_enable maildir messaging-proto-maildir) \
		$(use_enable sendmail messaging-proto-sendmail)
}

src_compile() {
	default
	if use doc ; then
		doxygen vmime.doxygen || die "doxygen failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	if use doc ; then
		dohtml doc/html/*
	fi

	insinto /usr/share/doc/${PF}
	use examples && doins -r examples
}
