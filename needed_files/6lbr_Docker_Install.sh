#!/usr/bin/env bash
echo "Create 6LBR app Image"
mkdir /app
cd app
echo "Installing dependancies"
apt-get update -y
apt-get install -y git
apt-get install -y build-essential
apt-get install -y libncurses5-dev
apt-get install -y bridge-utils
apt-get install -y net-tools
echo "Getting 6LBR files from CETIC's Github"
git clone https://github.com/cetic/6lbr
cd /app/6lbr
git checkout develop
git submodule update --init --recursive
echo "Compiling 6LBR application"
cd /app/6lbr/examples/6lbr
make all
make plugins
make tools
echo "Installing 6LBR application"
make install
make plugins-install
update-rc.d 6lbr defaults
echo "Deploying settings files"
mv /app/6lbr/examples/6lbr/tools/nvm_tool /nvm_tool
cp /needed_files/6lbr.conf /etc/6lbr/6lbr.conf
cp /needed_files/nvm.dat /etc/6lbr/nvm.dat
echo "Cleaning not needed files"
apt-get remove --auto-remove --purge -y git
apt-get remove --auto-remove --purge -y build-essential
apt-get remove --auto-remove --purge -y libncurses5-dev
apt-get remove --auto-remove --purge -y manpages
apt-get clean
rm -r /app
echo "Done"
