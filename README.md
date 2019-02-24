<img src="https://www.gentoo.org/assets/img/logo/gentoo-logo.svg" width="96" title="gentoo logo">

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

* dev-db/influxdb: Update ebuild for InfluxDB metrics database (https://influxdata.com).

* net-analyzer/telegraf: Update ebuild for Telegraf metric reporter (https://influxdata.com).

* net-misc/kea: Updated ebuild with DB backend support (MySQL, PostgreSQL).

* www-apps/grafana: New ebuild for Grafana dashboard web app (https://grafana.com).
