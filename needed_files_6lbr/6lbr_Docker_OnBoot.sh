#!/usr/bin/env bash
nvmtool --update --dft-router bbbb::1 /etc/6lbr/nvm.dat
echo "address=$LWM2MSERVER" >> /etc/6lbr/nvm.conf
sleep 2
service 6lbr start
sleep 10
echo 0 > /proc/sys/net/ipv6/conf/tap0/disable_ipv6
echo 1 > /proc/sys/net/ipv6/conf/tap0/forwarding
echo 1 > /proc/sys/net/ipv6/conf/eth0/forwarding
echo 1 > /proc/sys/net/ipv6/conf/all/forwarding
ip addr add bbbb::1/64 dev tap0
ip addr add cccc::1/64 dev tap0
tayga --mktun
ip link set nat64 up
echo 0 > /proc/sys/net/ipv6/conf/all/disable_ipv6
echo 0 > /proc/sys/net/ipv6/conf/nat64/disable_ipv6
echo 1 > /proc/sys/net/ipv6/conf/nat64/forwarding
ip addr add $(netinfo --ipv4router) dev nat64
ip addr add cccc::2/64 dev nat64
ip route add cccc::64:0:0/96 dev nat64
ip route add 172.46.0.0/16 dev nat64
tayga
sleep 5
cat /var/log/6lbr.ip
tail -f /var/log/6lbr.log
