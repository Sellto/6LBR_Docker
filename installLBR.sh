#!/bin/bash

echo '6LBR on RPI3 installation'
echo '-------------------------'

#Dependencies.
#apt-get install bridge-utils
dpkg -i cetic-6lbr_1.3.3_armhf.deb

#Create 6LBR.conf file
cd /etc/6lbr
if [ -e "6lbr.conf" ];
then
echo -e "\e[31mbr0 File 6lbr.conf is already present.We are creating a new one\e[0m"
 rm 6lbr.conf

fi
 touch 6lbr.conf
 chmod 666 6lbr.conf
 echo '#Bridge Mode Config'   >> 6lbr.conf
 echo 'MODE=SMART-BRIDGE'     >> 6lbr.conf
 echo 'RAW_ETH=0'             >> 6lbr.conf
 echo 'BRIDGE=1'              >> 6lbr.conf
 echo 'CREATE_BRIDGE=0'       >> 6lbr.conf
 echo 'DEV_ETH=eth0'          >> 6lbr.conf
 echo 'DEV_BRIDGE=br0'        >> 6lbr.conf
 echo 'DEV_TAP=tap0'          >> 6lbr.conf
 echo 'DEV_RADIO=/dev/ttyUSB0'>> 6lbr.conf
 echo 'BAUDRATE=115200'       >> 6lbr.conf

cd /etc/network
if grep -q "br0" interfaces
then
echo -e "\e[31mbr0 already present in the interfaces file\e[0m"
else

 chmod 666 interfaces
 echo 'source-directory /etc/network/interfaces.d' >> interfaces
 echo 'iface eth0 inet static'>>interfaces
 echo 'address 0.0.0.0'>> interfaces
 echo $'\n'>>interfaces
 echo 'auto br0' >> interfaces
 echo 'iface br0 inet dhcp'>> interfaces
 echo '    bridge_ports eth0'>> interfaces
 echo '    bridge_stp off'>> interfaces
 echo '    up echo 0 > /sys/devices/virtual/net/br0/bridge/multicast_snooping' >>interfaces
 echo "    post-up ip link set br0 address `ip link show eth0 | grep ether | awk '{print $2}'`" >> interfaces
fi

#Start 6lbr Service
service 6lbr start

#Check if service is active.
service --status-all | grep '6lbr'

#Ip of the Webserver.
cat /var/log/6lbr.ip
