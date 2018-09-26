#!/usr/bin/env bash
brctl addbr br0
cd /
netstat -r6 | awk '/eth0/{print $1}' | grep '/64' | grep -v 'fe80' |head -n 1|cut -d'/' -f1 > sixlbrnet
./nvm_tool --update --wsn-prefix $(cat /sixlbrnet) /etc/6lbr/nvm.dat
./nvm_tool --update --wsn-context-0 $(cat /sixlbrnet) /etc/6lbr/nvm.dat
service 6lbr start
sleep 7
brctl addif br0 eth0 tap0
ip link set br0 up
sleep 5
cat /var/log/6lbr.ip
tail -f /var/log/6lbr.log
