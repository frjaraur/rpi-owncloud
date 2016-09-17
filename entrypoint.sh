#!/bin/sh

ACTION=$1

[ ! -n "${OWNCLOUDDATA}" ] && OWNCLOUDDATA=/var/lib/owncloud/data

echo "OWNCLOUD DATA [${OWNCLOUDDATA}]"

echo "OWCLOUD CONFIG FILE [${OWNCLOUDCFGFILE}]"

[ ! -d ${OWNCLOUDDATA} ] && mkdir -p ${OWNCLOUDDATA}




#Ensure config.php ownership

chown root:www-data ${OWNCLOUDCFGFILE}

Check_Installed(){
	
	[ $(grep -c "'installed' => true" ${OWNCLOUDCFGFILE})  -eq 0 ] && return 1
	
	return 0

}

 

ConfigureDataDir(){

	[ ! -d ${OWNCLOUDDATA} ] && mkdir -p ${OWNCLOUDDATA}

	chown -R root:www-data ${OWNCLOUDDATA}

	chmod -R 770 ${OWNCLOUDDATA}

}

CreateCA(){
  [ ! -d ${SSLDATA}/ca ] && mkdir -p ${SSLDATA}/ca

  touch ${SSLDATA}/ca/index.txt

  CANAME=${CANAME:=OPENVPN_SelfSigned}

  
  LOCATION=${LOCATION:=ES:HOME:HOME}

  #COUNTRY:LOCATION:ORGANIZATION
  COUNTRY="$(echo ${LOCATION}|cut -d ":" -f1)"
  CITY="$(echo ${LOCATION}|cut -d ":" -f2)"
  ORGANIZATION="$(echo ${LOCATION}|cut -d ":" -f3)"

  sed -i "s/__CANAME__/${CANAME}/g" ${SSLDATA}/ca.cnf

  
  sed -i "s/__COUNTRY__/${COUNTRY}/g" ${SSLDATA}/ca.cnf
  sed -i "s/__LOCATION__/${CITY}/g" ${SSLDATA}/ca.cnf
  sed -i "s/__ORGANIZATION__/${ORGANIZATION}/g" ${SSLDATA}/ca.cnf


  [ -n "${PASSPHRASE}" ]  && PASSPOPTS="-passout pass:${PASSPHRASE} "

  openssl req -new \
    -config ${SSLDATA}/ca.cnf  \
    ${PASSPOPTS} \
    -keyout ${SSLDATA}/ca/ca.key \
    -out ${SSLDATA}/ca/ca.req

  [ -n "${PASSPHRASE}" ]  && PASSPOPTS="-passin pass:${PASSPHRASE}"

  openssl ca -batch \
    -config ${SSLDATA}/ca-sign.cnf  \
    ${PASSPOPTS} \
    -extensions X509_ca \
    -days 3650  \
    -create_serial -selfsign \
    -keyfile ${SSLDATA}/ca/ca.key \
    -in ${SSLDATA}/ca/ca.req \
    -out ${SSLDATA}/ca/ca.crt

  chmod 400 ${SSLDATA}/ca/ca.key

  chmod 444 ${SSLDATA}/ca/ca.crt

  rm -f ${SSLDATA}/ca/ca.req
}

CreateServerCert(){

  SERVERNAME=${SERVERNAME:=$(hostname)}
  LOCATION=${LOCATION:=ES:HOME:HOME}

  #COUNTRY:LOCATION:ORGANIZATION
  COUNTRY="$(echo ${LOCATION}|cut -d ":" -f1)"
  CITY="$(echo ${LOCATION}|cut -d ":" -f2)"
  ORGANIZATION="$(echo ${LOCATION}|cut -d ":" -f3)"


  sed -i "s/__SERVERNAME__/${SERVERNAME}/g" ${SSLDATA}/server.cnf


  sed -i "s/__COUNTRY__/${COUNTRY}/g" ${SSLDATA}/server.cnf
  sed -i "s/__LOCATION__/${CITY}/g" ${SSLDATA}/server.cnf
  sed -i "s/__ORGANIZATION__/${ORGANIZATION}/g" ${SSLDATA}/server.cnf
  sed -i "s/__DNSNAMES__/${DNSNAMES}/g" ${SSLDATA}/server.cnf

  if [ -n "${ALTERNAME_NAMES}" ]
  then
	I=0
	DNSNAMES=""
	for name in ${ALTERNAME_NAMES}
	do
		 DNSNAMES="${DNSNAMES}DNS.${I} = ${name},"
		I=$(($I+1))
	done

  fi
  sed -i "s/__DNSNAMES__/${DNSNAMES}/g" ${SSLDATA}/server.cnf



  [ ! -d ${SSLDATA}/ca ] && ErrorMessage "Can not find ca.crt, please use 'create-ca' or add your ca.crt in ${SSLDATA}/ca dir."

  [ ! -d ${SSLDATA}/server ] && mkdir -p ${SSLDATA}/server

  cp -p ${SSLDATA}/ca/ca.crt ${SSLDATA}/server

  [ -n "${PASSPHRASE}" ]  && PASSPOPTS="-passin pass:${PASSPHRASE}"

## openssl req -new -sha256 -key domain.key -subj "/C=US/ST=CA/O=Acme, Inc./CN=example.com" -reqexts SAN -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS:example.com,DNS:www.example.com")) -out domain.csr

  openssl req -new \
    -config ${SSLDATA}/server.cnf \
    ${PASSPOPTS} \
    -keyout ${SSLDATA}/server/server.key \
    -out ${SSLDATA}/server/server.req

  chmod 400 ${SSLDATA}/server/server.key

  openssl ca  -batch \
    -config ${SSLDATA}/ca-sign.cnf \
    -extensions X509_server \
    ${PASSPOPTS} \
    -in ${SSLDATA}/server/server.req \
    -out ${SSLDATA}/server/server.crt

  chmod 444 ${SSLDATA}/server/server.crt

  rm -f ${SSLDATA}/server/server.req

}

EnableSSL(){
	[ -f /etc/lighttpd/certs/lighttpd.pem ] && return 0

 	mkdir -p /etc/lighttpd/certs && cd /etc/lighttpd/certs
	#openssl req -new -x509 -keyout lighttpd.pem -out lighttpd.pem -days 365 -nodes

	cat ${SSLDATA}/server/server.key ${SSLDATA}/server/server.crt >/etc/lighttpd/certs/lighttpd.pem

	chmod 400 /etc/lighttpd/certs/lighttpd.pem

	cp ${SSLDATA}/ca/ca.crt /etc/lighttpd/certs/ca.crt

	chmod 400 /etc/lighttpd/certs/ca.crt
	
	printf "ssl.engine= \"enable\"\nssl.pemfile= \"/etc/lighttpd/certs/lighttpd.pem\"\nssl.ca-file = \"/etc/lighttpd/certs/ca.crt\"\n" >> /etc/lighttpd/lighttpd.conf

}

Create_ConfigFile(){

	echo "Check Config File"		




}

case ${ACTION} in
	setup)
		
		echo "SETUP "

	;;

	start)
		echo "START"
		[ ! -f /etc/lighttpd/certs/ca.crt ] && CreateCA
		[ ! -f /etc/lighttpd/certs/lighttpd.pem ] && CreateServerCert
		EnableSSL	
		ConfigureDataDir
		lighttpd -D -f /etc/lighttpd/lighttpd.conf


	;;

	passwd)

	;;

	help)

	;;

	*)

		exec "$@"
	;;

esac


