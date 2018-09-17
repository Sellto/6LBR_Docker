#!/bin/bash

echo '6LBR on RPI3 installation'
echo '-------------------------'

#Dependencies.
sudo apt-get install bridge-utils

if [ !  -e "cetic-6lbr_1.3.3_armhf.deb" ];then
#Get Binary packages.
wget https://raw.github.com/wiki/cetic/6lbr/releas$

#Installation of the package.
sudo dpkg -i cetic-6lbr_1.3.3_armhf.deb
else
echo -e "\e[31mcetic-6lbr_1.3.3_armhf.deb file already there\e[0m"
fi

#Create 6LBR.conf file
cd /etc/6lbr
if [ -e "6lbr.conf" ];
then
echo -e "\e[31mbr0 File 6lbr.conf is already present.We are creating a new one\e[0m"
sudo rm 6lbr.conf

fi
sudo touch 6lbr.conf
sudo chmod 666 6lbr.conf
sudo echo '#Bridge Mode Config'   >> 6lbr.conf
sudo echo 'MODE=SMART-BRIDGE'     >> 6lbr.conf
sudo echo 'RAW_ETH=0'             >> 6lbr.conf
sudo echo 'BRIDGE=1'              >> 6lbr.conf
sudo echo 'CREATE_BRIDGE=0'       >> 6lbr.conf
sudo echo 'DEV_ETH=eth0'          >> 6lbr.conf
sudo echo 'DEV_BRIDGE=br0'        >> 6lbr.conf
sudo echo 'DEV_TAP=tap0'          >> 6lbr.conf
sudo echo 'DEV_RADIO=/dev/ttyUSB0'>> 6lbr.conf
sudo echo 'BAUDRATE=115200'       >> 6lbr.conf

cd /etc/network
if grep -q "br0" interfaces
then
echo -e "\e[31mbr0 already present in the interfaces file\e[0m"
else

sudo chmod 666 interfaces
sudo echo 'source-directory /etc/network/interfaces.d' >> interfaces
sudo echo 'iface eth0 inet static'>>interfaces
sudo echo 'address 0.0.0.0'>> interfaces
sudo echo $'\n'>>interfaces
sudo echo 'auto br0' >> interfaces
sudo echo 'iface br0 inet dhcp'>> interfaces
sudo echo '    bridge_ports eth0'>> interfaces
sudo echo '    bridge_stp off'>> interfaces
sudo echo '    up echo 0 > /sys/devices/virtual/net/br0/bridge/multicast_snooping' >>interfaces
sudo echo "    post-up ip link set br0 address `ip link show eth0 | grep ether | awk '{print $2}'`" >> interfaces
fi

#Start 6lbr Service
service 6lbr start

#Check if service is active.
service --status-all | grep '6lbr'

#Ip of the Webserver.
cat /var/log/6lbr.ip
