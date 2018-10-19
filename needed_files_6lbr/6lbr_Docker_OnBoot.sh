#!/usr/bin/env bash
nvmtool --update --wsn-prefix 2002:: /etc/6lbr/nvm.dat
nvmtool --update --wsn-context-0 2002:: /etc/6lbr/nvm.dat
nvmtool --update --dft-router 2002::1 /etc/6lbr/nvm.dat
sleep 2
service 6lbr start
sleep 10
git clone https://github.com/Sellto/netinfo
echo 0 > /proc/sys/net/ipv6/conf/tap0/disable_ipv6
echo 1 > /proc/sys/net/ipv6/conf/tap0/forwarding
echo 1 > /proc/sys/net/ipv6/conf/eth0/forwarding
echo 1 > /proc/sys/net/ipv6/conf/all/forwarding
ip addr add 2002::1/64 dev tap0
ip route add 2002::4:0:0/96 via
sleep 5
cat /var/log/6lbr.ip
tail -f /var/log/6lbr.log
