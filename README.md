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

__Please beware__: I am running and hence tested these ebuilds against ~amd64 or ~arm64 and with my private setup. Use them at your own risk.

### List of active ebuilds
The following ebuilds are are in use by myself and therefore are actively maintained.

* app-admin/loki: New ebuild for Loki log aggregator (https://grafana.com/loki).

* app-crypt/bitwarden-container: New ebuild for running Bitwarden (https://bitwarden.com/help/install-and-deploy-unified-beta/) container via podman.

* app-metrics/alloy: New ebuild for Grafana Alloy OpenTelemetry Collector distribution with programmable pipelines (https://github.com/grafana/alloy).

* app-metrics/mimir: New ebuild for Grafana Mimir high scalable Prometheus storage backend (https://github.com/grafana/mimir).

* app-metrics/tempo: New ebuild for Grafana Tempo a high volume, minimal dependency distributed tracing backend (https://github.com/grafana/tempo).

* net-analyzer/snort3: Updated ebuild for the latest Snort IDS (https://snort.org).

* net-analyzer/telegraf: Updated ebuild for Telegraf metric reporter (https://influxdata.com).

* net-analyzer/pulledpork3: Updated ebuild for the latest Pulled Pork (beta) for Snort v3 (https://github.com/shirkdog/pulledpork3).

* net-nds/authelia: New ebuild for Authelia Single Sign-On Multi-Factor portal for web apps (https://www.authelia.com/).

* sys-cluster/seaweedfs: New ebuild for SeaweedFS fast distributed storage system (https://github.com/seaweedfs/seaweedfs).

* www-apps/grafana: New ebuild for Grafana dashboard web app (https://grafana.com).

* www-apps/ocis: New ebuild for ownCloud Infinite Scale Stack (https://doc.owncloud.com/ocis/next/).

* www-apps/paperless-ngx-container: New ebuild for running Paperless-ngx (https://docs.paperless-ngx.com/) container via podman.

### List of inactive ebuilds
The following ebuilds are no longer used by myself, will receive no updates and will be removed at some point in time.
