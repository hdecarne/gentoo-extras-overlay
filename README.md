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

* net-im/spectrum-transport: New ebuild for the 1.x version of Spectrum XMPP transport (http://spectrum.im/).

* net-mail/zcp/zcp: New ebuild for the Zarafa groupware solution (http://www.zarafa.com). __Please see__ following ebuilds for more details.

* dev-cpp/libvmime-zcp/libvmime-zcp: New ebuild for Zarafa patched version of libvmime. Required by the zcp ebuild above.

* dev-libs/libical-zcp/libical-zcp: New ebuild for Zarafa patched version of libical. Required by the zcp ebuild above. __Please note__: There is an official libical ebuild in the portage tree that conflicts with this ebuild.

* www-apps/zarafa-webapp: New ebuild for the Zarafa Webapp client.

* www-apps/z-push: New ebuild for the Zarafa ActiveSync solution.

* www-apache/mod_auth_kerb: Update to the portage ebuild for Apache 2.4 compability.

* net-wireless/bluez: New ebuild for Bluez 5.8 version.
