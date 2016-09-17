FROM hypriot/rpi-alpine-scratch

RUN apk update && \
apk upgrade && \
apk add lighttpd php-cgi php-curl \
owncloud-sqlite owncloud-texteditor owncloud-documents owncloud-videoviewer && \ 
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

COPY ssl/ ${SSLDATA}

VOLUME ${OWNCLOUDDATA} ${SSLDATA}

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]
