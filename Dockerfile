FROM resin/armv7_debian:wheezy
ADD needed_files ./needed_files
RUN chmod -R +x /needed_files && needed_files/6lbr_Docker_Install.sh
CMD needed_files/6lbr_Docker_OnBoot.sh
