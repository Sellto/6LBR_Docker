mkdir /app
cd app
apt-get update -y
apt-get install -y \
git \
build-essential \
libncurses5-dev \
bridge-utils \
net-tools \
uml-utilities
git clone https://github.com/cetic/6lbr
cd 6lbr
git checkout develop
git submodule update --init --recursive
cd /app/6lbr/examples/6lbr
make all
make plugins
make tools
make install
make plugins-install
update-rc.d 6lbr defaults
git clone https://github.com/Sellto/6LBR_Docker.git
cd /app/6LBR_Docker
cp settings/6lbr.conf /etc/6lbr/6lbr.conf
cp settings/interfaces /etc/network/interfaces
touch /etc/6lbr/nvm.dat
apt-get remove --auto-remove -y git\
build-essential \
uml-utilities \
libncurses5 \
rm -f /app
./usr/lib/6lbr/6lbr /etc/6lbr/6lbr.conf
