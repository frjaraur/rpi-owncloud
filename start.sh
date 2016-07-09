#!/bin/sh

[ ! -n "${OWNCLOUDDATA}" ] && OWNCLOUDDATA=/var/lib/owncloud/data

echo "OWNCLOUD DATA [${OWNCLOUDDATA}]"

[ ! -d ${OWNCLOUDDATA} ] && mkdir -p ${OWNCLOUDDATA}
 

Initial_Setup(){

	[ ! -d ${OWNCLOUDDATA} ] && mkdir -p ${OWNCLOUDDATA}

	chown -R root:www-data ${OWNCLOUDDATA}

	chmod -R 770 ${OWNCLOUDDATA}

}

case $1 in
	inital)
		
		echo "INITIAL"

	;;

	run)
		echo "RUN"
		[ ! -d ${OWNCLOUDDATA} ] && Initial_Setup

	;;


esac

exec $@

