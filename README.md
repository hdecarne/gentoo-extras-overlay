gentoo-extras-overlay
=====================
This repository hosts a collection of custom gentoo ebuilds that I maintain for my private setup.
The corresponding packages either did not yet find their way into the portage tree or the current portage tree version has something missing I needed. See the package comments below to get the details.

How to use these ebuilds
------------------------
You can use layman with the URL https://raw.github.com/hdecarne/gentoo-extras-overlay/master/overlay.xml to subscribe to this overlay. Or you can clone the repository and add the path to your PORTDIR\_OVERLAY variable manually.
__Please beware__: I am running and hence tested these ebuilds against ~amd64 and with my private setup. Use them at your own risk.

List of ebuilds
---------------

* dev-php/adodb: Update to the portage ebuild fixing bug https://bugs.gentoo.org/show_bug.cgi?id=420517.

* net-firewall/ipsec-tools: Update to the portage ebuild fixing issue http://sourceforge.net/tracker/?func=detail&aid=2852569&group_id=74601&atid=541484.

* net-analyzer/cacti: Update to the portage ebuild that makes version 0.8.8a available. See https://bugs.gentoo.org/show_bug.cgi?id=414419 for further details.

* net-misc/asterisk-chan\_capi: Updated ebuild for the Asteriks capi channel module (http://www.melware.org/ChanCapi). Please note: The 1.1.6 ebuild is actually a build against the development head. Expect emerge to fail with "Digest verification failed". ebuild <xxx.ebuild> manifest is your friend here.

* net-im/spectrum-transport: New ebuild for the 1.x version of Spectrum XMPP transport (http://spectrum.im/).

* net-mail/zcp/zcp: New ebuild for the Zarafa groupware solution (http://www.zarafa.com). __Please see__ following ebuilds for more details.

* dev-cpp/libvmime-zcp/libvmime-zcp: New ebuild for Zarafa patched version of libvmime. Required by the zcp ebuild above.

* dev-libs/libical-zcp/libical-zcp: New ebuild for Zarafa patched version of libical. Required by the zcp ebuild above. __Please note__: There is an official libical ebuild in the portage tree that conflicts with this ebuild.

* www-apps/zarafa-webapp: New ebuild for the Zarafa Webapp client.

* www-apps/z-push: New ebuild for the Zarafa ActiveSync solution.
