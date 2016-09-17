clean:
	docker rm -fv owncloud

build:
	docker build -t owncloud .

start:
	docker run -d \
	--restart unless-stopped \
	--name owncloud --hostname=__YOUR_HOSTNAME__ \
	--env PASSPHRASE=__YOUR_PASSPHRASE_FOR_SSL__ \
	--env CANAME=__YOUR_CNAME__ \
	--env DNSNAMES=__YOUR_DOMAIN_NAMES__ \
	-v /mnt/DATA1/OWNCLOUD:/var/lib/owncloud/data \
	-v OWNCLOUDSSLDATA:/SSLDATA \
	-p 80:80 -p 443:443 \
	rpi-owncloud start

push:
	make build
	docker tag owncloud frjaraur/rpi-owncloud
	docker push frjaraur/rpi-owncloud
