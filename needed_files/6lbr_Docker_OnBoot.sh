#!/usr/bin/env bash
brctl addbr br0
service 6lbr start
sleep 10
brctl addif br0 eth0 tap0
ip link set br0 up
sleep 5
cat /var/log/6lbr.ip
tail -f /var/log/6lbr.log
