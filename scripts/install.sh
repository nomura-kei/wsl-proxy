#!/bin/sh

WIN_BASE_PATH=$1

echo "Install Applications"
/sbin/apk add --no-cache openrc squid curl
/sbin/rc-update add squid default

echo "Network Settings"
/bin/cp "${WIN_BASE_PATH}/conf/interfaces" /etc/network/

echo "Squid Settings"
/bin/cp "${WIN_BASE_PATH}/conf/squid.conf" /etc/squid/
/bin/mkdir -p /etc/squid/conf.d/
/bin/cp "${WIN_BASE_PATH}/conf/proxy.conf" /etc/squid/conf.d/

IPADDRESS=`ip -4 addr show eth0 | awk '/inet / {print $2}' | cut -d/ -f1`
echo "${IPADDRESS}" > "${WIN_BASE_PATH}/conf/wsl_address.txt"

openrc default
