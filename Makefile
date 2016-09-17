start:
	docker run -d \
	--restart unless-stopped \
	--name owncloud --hostname=alnitak \
	--env PASSPHRASE=Ch4ngeM3 \
	--env CANAME=Visualize \
	--env DNSNAMES=home-visualize.no-ip.org \
	-v /mnt/DATA1/OWNCLOUD:/var/lib/owncloud/data \
	-p 80:80 -p 443:443 \
	rpi-owncloud start
