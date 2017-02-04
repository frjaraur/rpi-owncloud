
### Basic Usage ###

#### In this example we are using an external drive mounted on /mnt/OWNCLOUD ####
~~~

docker service create --name owncloud \
--mount type=bind,src=/etc/timezone,dst=/etc/timezone,readonly  \
--mount type=bind,src=/etc/localtime,dst=/etc/localtime,readonly \
--mount type=bind,src=/mnt/OWNCLOUD,dst=/var/lib/owncloud/data \
--mount type=volume,src=OWNCLOUDSSLDATA,dst=/SSLDATA \
--env PASSPHRASE=__WHATEVER_YOU_WANT_AS_PASSPHRASE__ \
--env CANAME=__YOR_CANAME__ \
--env DNSNAMES=__EXTERNAL_FQDN_ \
--env PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
--env OWNCLOUDDATA=/var/lib/owncloud/data \
--env SSLDATA=/SSLDATA \
--env OWNCLOUDCFGFILE=/etc/owncloud/config.php \
--publish 8080:80 --publish 8443:443 \
frjaraur/rpi-owncloud start

~~~
