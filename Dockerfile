FROM frjaraur/rpi-alpine

RUN apk add --update lighttpd php5-cgi php5-curl \
owncloud-sqlite owncloud-texteditor owncloud-documents owncloud-videoplayer && \ 
rm -rf /var/cache/apk/*

COPY lighttpd.conf.simple /etc/lighttpd/lighttpd.conf

COPY php.ini /etc/php.ini

RUN ln -s /usr/share/webapps/owncloud /var/www/localhost/htdocs

ENV OWNCLOUDDATA /var/lib/owncloud/data

ENV SSLDATA /SSLDATA

ENV OWNCLOUDCFGFILE /etc/owncloud/config.php
#COPY config.php /etc/owncloud/config

#ln -sf /dev/stdout /var/log/lighttpd/access.log \
#	&& ln -sf /dev/stderr /var/log/lighttpd/error.log
EXPOSE 80 443

VOLUME ${OWNCLOUDDATA} ${SSLDATA}

COPY ssl/ ${SSLDATA}

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]
