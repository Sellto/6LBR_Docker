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


printf "\nCreate Tayga app Image \n"
mkdir /app
mkdir -p /var/build/
cd app



apt-get install build-essential -y  1>/dev/null 2>/var/build/dep.err  && \
apt-get install wget -y             1>/dev/null 2>/var/build/dep.err  &
PID=$!
process "Installing dependencies"



mkdir -p /build
cd /build
wget http://www.litech.org/tayga/tayga-0.9.2.tar.bz2  1>/dev/null 2>/var/build/git.err  && \
tar -jxf tayga-0.9.2.tar.bz2                          1>/dev/null 2>/var/build/git.err  &
PID=$!
process "Getting Tayga files from litech.org"



cd /build/tayga-0.9.2
./configure                                           1>/dev/null 2>/var/build/compile.err  && \
make                                                  1>/dev/null 2>/var/build/compile.err  &
PID=$!
process "Compiling Tayga application"



make install                                          1>/dev/null 2>/var/build/install.err  &
PID=$!
process "Installing Tayga application"



mkdir -p /var/db/tayga
mv /needed_files_tayga/tayga.conf /usr/local/etc/tayga.conf &
PID=$!
process "Deploying settings files"


cd /needed_files_tayga/tools
make all                                              1>/dev/null 2>/var/build/compile.err   && \
mv netinfo /usr/local/sbin/netinfo                    &
PID=$!
process "Installing needed tools"


rm -rf /build                                           1>/dev/null 2>/var/build/clean.err  && \
apt-get remove --auto-remove --purge -y wget            1>/dev/null 2>/var/build/clean.err  && \
apt-get remove --auto-remove --purge -y build-essential 1>/dev/null 2>/var/build/clean.err  && \
apt-get clean                                           1>/dev/null 2>/var/build/clean.err  &
PID=$!
process "Cleaning not needed files"

printf "Done \n"
