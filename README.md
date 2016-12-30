### gentoo-extras-overlay
This repository hosts a collection of custom gentoo ebuilds that I maintain for my private setup.
The corresponding packages either did not yet find their way into the portage tree or the current portage tree version has something missing I needed. See the package comments below to get the details.

### How to use these ebuilds
You can use layman with the URL https://raw.github.com/hdecarne/gentoo-extras-overlay/master/overlay.xml to subscribe to this overlay. Or you can clone the repository and add the path to your PORTDIR\_OVERLAY variable manually.
__Please beware__: I am running and hence tested these ebuilds against ~amd64 and with my private setup. Use them at your own risk.

### List of ebuilds

* net-mail/kopanocore: New ebuild for the Kopano (former Zarafa) groupware solution (http://kopano.io). This is the initial version an might still need some tuning.

* dev-cpp/libvmime: New (live) ebuild for the latest vmime lib as needed by the Kopano Core ebuild above.

* www-apps/kopano-webapp: New ebuild for the Kopano (former Zarafa) WebApp client (http://kopano.io). This is the initial version and might still need some tuning.

* www-apps/kopano-webapp-files: New ebuild for the Kopano WebApp files plugin (http://kopano.io).

* www-apps/kopano-webapp-mdm: New ebuild for the Kopano WebApp smime plugin (http://kopano.io).

* www-apps/kopano-webapp-smime: New ebuild for the Kopano WebApp mdm plugin (http://kopano.io).

* www-apps/z-push: New ebuild for the Z-Push ActiveSync solution (http://z-push.org).

* net-dialup/openl2tp: New ebuild for the OpenL2TP L2TP server (http://www.openl2tp.org)

* net-misc/freeswitch: New ebuild for the FreeSWITCH VOIP solution (https://freeswitch.org)

* net-misc/freeswitch-{sounds,sounds-en,sounds-music}: New ebuild for the FreeSWITCH sound files.

* www-apps/phpsysinfo: Updated ebuild for the phpSysInfo script.

* net-fs/davfs2: Updated ebuild for the DAVFS2 WebDAV client.

* app-admin/aws-cli: New ebuild for the AWS Command Line Interface (https://aws.amazon.com/cli/).

* dev-db/mysqltuner: Updated ebuild for the mysqltuner tool (http://mysqltuner.com).

The following ebuild are no longer actively maintained in this repository and may be dropped in the future.

* net-mail/zcp/zcp: New ebuild for the Zarafa groupware solution (http://www.zarafa.com). Now superseded by the Kopano Core ebuild above.

* dev-cpp/libvmime-zcp/libvmime-zcp: New ebuild for Zarafa patched version of libvmime. Required by the zcp ebuild above.

* www-apps/zarafa-webapp: New ebuild for the Zarafa Webapp client. Now superseded by the Kopano Webapp ebuild above.

* www-apps/zarafa-webapp-{extbox,pdfbox}: New ebuild for the Zarafa Webapp file preview plugins (now superseded by the filepreviewer plugin).

* www-apps/zarafa-webapp-files: New ebuild for the Zarafa Webapp files plugin for file access.

* www-apps/zarafa-webapp-plugins-smime: New ebuild for the Zarafa Webapp S/MIME plugin for mail encryption.

* www-apps/zarafa-webapp-plugins-filepreviewer: New ebuild for the Zarafa Webapp file previewer plugin.

* www-apps/zarafa-webapp-plugins-mdm: New ebuild for the Zarafa Webapp Mobile Device Management plugin.

* net-im/prosody: Updated ebuild for the Prosody XMPP server (http://prosody.im/) for SASL support.

* dev-lua/lua-cyrussasl: New ebuild for the Cyrus-SASL LUA binding as used by Prosody.

* net-im/spectrum-transport: New ebuild for the 1.x version of Spectrum XMPP transport (http://spectrum.im/).
