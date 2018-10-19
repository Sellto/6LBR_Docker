#!/usr/bin/env bash
process(){
i=0
sp="[*   ][ *  ][  * ][   *]"
echo -n ' '
while [ -d /proc/$PID ]
do
  for j in `seq 0 $(echo -n $1 | wc -m)`;
  do
  printf "\b"
  done
  printf "\b\b\b\b\b\b${sp:i%${#sp}:6}"
  printf " $1"
  sleep 0.2
  let "i=i+6"
done
for j in `seq 0 $(echo -n $1 | wc -m)`;
do
printf "\b"
done
printf '\b\b\b\b\b\b[ \e[32mOK\e[0m ]'
printf " $1\n"
}

printf "\nCreate 6LBR app Image \n"
mkdir /app
mkdir -p /var/build/
cd app

apt-get update  -y                       1>/dev/null 2>/var/build/dep.err  && \
apt-get install -y git                   1>/dev/null 2>/var/build/dep.err  && \
apt-get install -y build-essential       1>/dev/null 2>/var/build/dep.err  && \
apt-get install -y libncurses5-dev       1>/dev/null 2>/var/build/dep.err  &
PID=$!
process "Installing dependencies"


git clone https://github.com/cetic/6lbr  1>/dev/null 2>/var/build/git.err  && \
git checkout develop                     1>/dev/null 2>/var/build/git.err  &
PID=$!
process "Getting 6LBR files from CETIC's Github"

cd /app/6lbr
git submodule update --init --recursive  1>/dev/null 2>/var/build/git.err &
PID=$!
process "Get needed submodules"

cd /app/6lbr/examples/6lbr
make all                                 1>/dev/null 2>/var/build/compile.err  && \
make plugins                             1>/dev/null 2>/var/build/compile.err  && \
make tools                               1>/dev/null 2>/var/build/compile.err  &
PID=$!
process "Compiling 6LBR application"

make install                             1>/dev/null 2>/var/build/install.err  && \
make plugins-install                     1>/dev/null 2>/var/build/install.err  && \
update-rc.d 6lbr defaults                1>/dev/null 2>/var/build/install.err  &
PID=$!
process "Installing 6LBR application"


mv /app/6lbr/examples/6lbr/tools/nvm_tool /usr/local/sbin/nvmtool && \
cp /needed_files_6lbr/6lbr.conf /etc/6lbr/6lbr.conf               && \
cp /needed_files_6lbr/nvm.dat /etc/6lbr/nvm.dat                   && \
cp /needed_files_6lbr/nvm.conf /etc/6lbr/nvm.conf                 &
PID=$!
process "Deploying settings files"


apt-get remove --auto-remove --purge -y git             1>/dev/null 2>/var/build/clean.err  && \
apt-get remove --auto-remove --purge -y build-essential 1>/dev/null 2>/var/build/clean.err  && \
apt-get remove --auto-remove --purge -y manpages        1>/dev/null 2>/var/build/clean.err  && \
apt-get clean                                           1>/dev/null 2>/var/build/clean.err  && \
rm -r /app                                              1>/dev/null 2>/var/build/clean.err  &
PID=$!
process "Cleaning not needed files"

printf "Done \n"
