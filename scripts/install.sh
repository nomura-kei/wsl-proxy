#!/bin/sh
WIN_BASE_PATH=$1

# ----------------------------------------------------------------------
#  save wsl ipaddress (conf/wsl_address.txt)
# ----------------------------------------------------------------------
save_wsl_ipaddress() {
    IPADDRESS=`ip -4 addr show eth0 | awk '/inet / {print $2}' | cut -d/ -f1`
    echo "${IPADDRESS}" > "${WIN_BASE_PATH}/conf/wsl_address.txt"
}

# ----------------------------------------------------------------------
#  install squid
# ----------------------------------------------------------------------
install_squid() {
    which squid
    if [ $? -ne 0 ]; then
        echo "Install squid"
        /sbin/apk add --no-cache openrc squid curl
        /sbin/rc-update add squid default
    fi
}

# ----------------------------------------------------------------------
#  configure the network
# ----------------------------------------------------------------------
configure_network() {
    if [ ! -f /etc/network/interfaces ]; then
        echo "Configure the network"
        /bin/cp "${WIN_BASE_PATH}/conf/interfaces" /etc/network/
    fi
}

# ----------------------------------------------------------------------
#  configure the squid
# ----------------------------------------------------------------------
configure_squid() {
    echo "Configure the squid"
    /bin/cp "${WIN_BASE_PATH}/conf/squid.conf" /etc/squid/
    /bin/mkdir -p /etc/squid/conf.d/
    /bin/cp "${WIN_BASE_PATH}/conf/proxy.conf" /etc/squid/conf.d/

    # start squid
    /sbin/rc-service squid status
    if [ $? -ne 0 ]; then
        /sbin/openrc default
    else
        /usr/sbin/squid -k reconfigure
    fi

    # check config files
    /usr/sbin/squid -k check
    if [ $? -ne 0 ]; then
        echo "#####!!! ERROR !!!#####"
        echo "please check and modify conf/squid.conf, conf/proxy.conf."
        echo "please run install.bat again."
        read -p "[Enter]" LINE
        return 1
    fi
    return 0
}

save_wsl_ipaddress
install_squid
configure_network
configure_squid
if [ $? -eq 0 ]; then
    openrc default
fi
