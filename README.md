### gentoo-extras-overlay
This repository hosts a collection of custom gentoo ebuilds that I maintain for my private setup.
The corresponding packages either did not yet find their way into the portage tree or the current portage tree version has something missing I needed. See the package comments below to get the details.

### How to use these ebuilds
The preferred way to use this overlay is to add a file with the following content to your /etc/portage/repos.conf folder:

	[gentoo-extras-overlay]                 
	location = /usr/local/gentoo-extras-overlay           
	sync-type = git                         
	sync-uri = https://github.com/hdecarne/gentoo-extras-overlay.git                
	clone-depth = 0                         
	auto-sync = yes

Alternatively you can use layman with the URL https://raw.github.com/hdecarne/gentoo-extras-overlay/master/overlay.xml to subscribe to this overlay. Or 
you can clone the repository and add the path to your PORTDIR\_OVERLAY variable manually.
__Please beware__: I am running and hence tested these ebuilds against ~amd64 or ~arm64 and with my private setup. Use them at your own risk.

### List of ebuilds

* net-misc/kea: Updated ebuild with DB backend support (MySQL, PostgreSQL).

* www-apps/phpsysinfo: Updated ebuild for the phpSysInfo script.

### List of no longer maintained ebuilds

* net-mail/kopanocore: New ebuild for the Kopano (former Zarafa) groupware solution (http://kopano.io).

* dev-cpp/libvmime: New ebuild for the latest vmime lib as needed by the Kopano Core ebuild above.

* www-apps/kopano-webapp: New ebuild for the Kopano (former Zarafa) WebApp client (http://kopano.io).

* www-apps/kopano-webapp-filepreviewe: New ebuild for the Kopano WebApp files plugin (http://kopano.io).

* www-apps/kopano-webapp-files: New ebuild for the Kopano WebApp files plugin (http://kopano.io).

* www-apps/kopano-webapp-files-[owncloud-backend,smb-backend]: New ebuilds for the Kopano WebApp files plugin backends (http://kopano.io).

* www-apps/kopano-webapp-mdm: New ebuild for the Kopano WebApp smime plugin (http://kopano.io).

* www-apps/kopano-webapp-smime: New ebuild for the Kopano WebApp mdm plugin (http://kopano.io).

* www-apps/z-push: New ebuild for the Z-Push ActiveSync solution (http://z-push.org).

* net-dialup/openl2tp: New ebuild for the OpenL2TP L2TP server (http://www.openl2tp.org)

* net-misc/freeswitch: New ebuild for the FreeSWITCH VOIP solution (https://freeswitch.org)

* net-misc/freeswitch-{sounds,sounds-en,sounds-music}: New ebuilds for the FreeSWITCH sound files.

* net-fs/davfs2: Updated ebuild for the DAVFS2 WebDAV client.

* app-admin/aws-cli: New ebuild for the AWS Command Line Interface (https://aws.amazon.com/cli/).

* mail-filter/rspamd: Updated ebuild for rspamd mail filter.

* dev-util/ragel: Updated ebuild for ragel lib (as required by mail-filter/rspamd).
