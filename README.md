<img src="https://www.gentoo.org/assets/img/logo/gentoo-logo.svg" width="96" title="gentoo logo">

### gentoo-extras-overlay
This repository hosts a collection of custom gentoo ebuilds that I maintain for my private setup.
The corresponding packages either did not yet find their way into the portage tree or the current portage tree version has something missing I needed. See the package comments below to get the details.

### How to use these ebuilds
The preferred way to use this overlay is to add a file with the following content to your /etc/portage/repos.conf folder:

	[gentoo-extras-overlay]                 
	location = /var/db/repos/gentoo-extras-overlay           
	sync-type = git                         
	sync-uri = https://github.com/hdecarne/gentoo-extras-overlay.git                
	clone-depth = 0                         
	auto-sync = yes

Alternatively you can use layman with the URL https://raw.github.com/hdecarne/gentoo-extras-overlay/master/overlay.xml to subscribe to this overlay. Or 
you can clone the repository and add the path to your PORTDIR\_OVERLAY variable manually.
__Please beware__: I am running and hence tested these ebuilds against ~amd64 or ~arm64 and with my private setup. Use them at your own risk.

### List of ebuilds

* dev-db/influxdb: Updated ebuild for InfluxDB metrics database (https://influxdata.com).

* net-analyzer/telegraf: Updated ebuild for Telegraf metric reporter (https://influxdata.com).

* net-misc/kea: Updated ebuild with DB backend support (MySQL, PostgreSQL).

* app-admin/fluent-bit: New ebuild for fluent-bit log processor and forwarder (https://fluentbit.io).

* app-admin/loki: New ebuild for Loki log aggregator (https://grafana.com/loki).

* dev-php/pecl-msgpack: New ebuild for msgpack PHP extension (https://github.com/msgpack/msgpack-php).

* media-libs/raspberrypi-userland: Derived ebuild for 64 bit Raspberry Pi userland tools (https://github.com/raspberrypi/userland).

* sys-kernel/raspberrypi-sources: Ebuild for latest Raspberry Pi kernel.

* sys-firmware/rpi-eeprom: New ebuild for Raspberry Pi4 bootloader EEPROM updates (https://github.com/raspberrypi/rpi-eeprom).

* www-apps/grafana: New ebuild for Grafana dashboard web app (https://grafana.com).

* sys-aut/hydra: New ebuild for Ory Hydra OAuth provider (https://github.com/ory/hydra).

* www-apache/mod_auth_openidc: New ebuild for Apache OIDC module (https://github.com/zmartzone/mod_auth_openidc).
