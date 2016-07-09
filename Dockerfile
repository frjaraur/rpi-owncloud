FROM hypriot/rpi-alpine-scratch
RUN apk update && \
apk upgrade && \
apk add lighttpd php-cgi php-curl \
owncloud-sqlite owncloud-texteditor owncloud-documents owncloud-videoviewer && \ 
rm -rf /var/cache/apk/*
COPY lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY php.ini /etc/php.ini
COPY start.sh /start.sh
RUN ln -s /usr/share/webapps/owncloud /var/www/localhost/htdocs


ENV OWNCLOUDDATA /var/lib/owncloud/data
#COPY config.php /etc/owncloud/config
VOLUME ${OWNCLOUDDATA}
#ln -sf /dev/stdout /var/log/lighttpd/access.log \
#	&& ln -sf /dev/stderr /var/log/lighttpd/error.log
EXPOSE 80 443
ENTRYPOINT ["/start.sh"]
CMD ["lighttpd","-D","-f","/etc/lighttpd/lighttpd.conf"]
