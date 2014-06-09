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

* net-im/prosody: Updated ebuild for the Prosody XMPP server (http://prosody.im/) for SASL support.

* dev-lua/lua-cyrussasl: New ebuild for the Cyrus-SASL LUA binding as used by Prosody.

* net-im/spectrum-transport: New ebuild for the 1.x version of Spectrum XMPP transport (http://spectrum.im/).

* net-mail/zcp/zcp: New ebuild for the Zarafa groupware solution (http://www.zarafa.com).

* dev-cpp/libvmime-zcp/libvmime-zcp: New ebuild for Zarafa patched version of libvmime. Required by the zcp ebuild above.

* www-apps/zarafa-webapp: New ebuild for the Zarafa Webapp client.

* www-apps/zarafa-webapp-plugins: New ebuild for the Zarafa Webapp plugins.

* www-apps/z-push: New ebuild for the Zarafa ActiveSync solution.

* net-dialup/openl2tp: New ebuild for the OpenL2TP L2TP server (http://www.openl2tp.org/)
