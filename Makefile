clean:
	docker rm -fv owncloud

build:
	#docker build --no-cache --rm  -t frjaraur/rpi-owncloud .
	docker build -t frjaraur/rpi-owncloud .
start:
	docker run -d \
	--restart unless-stopped \
	--name owncloud --hostname=E__ \
	--env PASSPHRASE=__YOUR_PASSPHRASE_FOR_SSL__ \
	--env CANAME=__YOUR_CNAME__ \
	--env DNSNAMES=__YOUR_DOMAIN_NAMES__ \
	-v /mnt/DATA1/OWNCLOUD:/var/lib/owncloud/data \
	-v OWNCLOUDSSLDATA:/SSLDATA \
	-p 443:443 \
	rpi-owncloud start

push:
	make build
	docker push frjaraur/rpi-owncloud

setup:
	docker rm -f owncloud-setup 2>/dev/null || true
	docker run  -d  --name owncloud-setup \
	-p 8443:443 \
	-v /mnt/OWNCLOUD/DATA:/var/lib/owncloud/data \
	-v OWNCLOUDSSL:/SSLDATA \
	--env PASSPHRASE=XXXXXXXXXXXX \
	--env CANAME=visualize \
	--env DNSNAMES=DNS:home-visualize.duckdns.org \
	--env OWNCLOUDCFGFILE=/etc/owncloud/config.php \
	frjaraur/rpi-owncloud setup
