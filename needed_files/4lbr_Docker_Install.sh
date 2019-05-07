#!/usr/bin/env bash
mkdir /app
mkdir -p /var/build/
cd app

apt-get update  -y
apt-get install -y git
apt-get install -y build-essential
apt-get install -y libncurses5-dev
apt-get install -y bzip2
apt-get install -y golang
apt-get install -y wget

git clone https://github.com/cetic/6lbr
git checkout develop
cd /app/6lbr
git submodule update --init --recursive
cd /app/6lbr/examples/6lbr
make all
make plugins
make tools
make install
make plugins-install
update-rc.d 6lbr defaults
mv /app/6lbr/examples/6lbr/tools/nvm_tool /usr/local/sbin/nvmtool
cp /needed_files/6lbr.conf /etc/6lbr/6lbr.conf
cp /needed_files/nvm.dat /etc/6lbr/nvm.dat
cp /needed_files/nvm.conf /etc/6lbr/nvm.conf

wget https://raw.githubusercontent.com/Sellto/netinfo/master/netinfo.go
export GOPATH=$HOME/go
go get github.com/hashicorp/go-sockaddr
go get github.com/urfave/cli
go build netinfo.go
mv netinfo /usr/local/bin/netinfo
mkdir -p /build
cd /build
wget http://www.litech.org/tayga/tayga-0.9.2.tar.bz2
tar -jxf tayga-0.9.2.tar.bz2
cd /build/tayga-0.9.2
./configure
make
make install
mkdir -p /var/db/tayga


cd /app
addgroup wheel
adduser root wheel
git clone https://github.com/fwdillema/totd.git
cd /app/totd
./configure
make
make install
mkdir -p /etc/totd
cp /needed_files/totd.conf /etc/totd/totd.conf

apt-get remove --auto-remove --purge -y git
apt-get remove --auto-remove --purge -y build-essential
apt-get remove --auto-remove --purge -y manpages
apt-get remove --auto-remove --purge -y wget
apt-get remove --auto-remove --purge -y golang
apt-get remove --auto-remove --purge -y bzip2
apt-get clean
rm -rf /build
rm -r /app
