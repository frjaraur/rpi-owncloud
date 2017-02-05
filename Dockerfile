FROM frjaraur/rpi-alpine

RUN adduser -H -D -G www-data -u 3333 -s /sbin/nologin lighttpd \
&& mkdir -p /var/run/lighttpd/ \
&& chown lighttpd /var/run/lighttpd \
&& apk add --update --no-cache \
openssl \
lighttpd \
php5-cgi \
php5-curl \
owncloud-sqlite \
owncloud-texteditor \
owncloud-documents \
owncloud-videoplayer \
&& rm -rf /var/cache/apk/*

COPY lighttpd.conf.simple /etc/lighttpd/lighttpd.conf

COPY reconfigure.php /reconfigure.php

COPY php.ini /etc/php.ini

RUN ln -s /usr/share/webapps/owncloud /var/www/localhost/htdocs

ENV OWNCLOUDDATA /var/lib/owncloud/data

ENV SSLDATA /SSLDATA

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENV OWNCLOUDCFGFILE /etc/owncloud/config.php
#COPY config.php /etc/owncloud/config

#ln -sf /dev/stdout /var/log/lighttpd/access.log \
#	&& ln -sf /dev/stderr /var/log/lighttpd/error.log
EXPOSE 443 80

VOLUME ${OWNCLOUDDATA} ${SSLDATA}

COPY ssl/ ${SSLDATA}

ENTRYPOINT ["/entrypoint.sh"]

COPY entrypoint.sh /entrypoint.sh

CMD ["help"]
