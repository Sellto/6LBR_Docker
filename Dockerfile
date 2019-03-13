FROM debian
ADD needed_files ./needed_files
RUN chmod -R +x /needed_files && needed_files/4lbr_Docker_Install.sh
ENV LWM2MSERVER="cccc::64:ac11:2"
CMD needed_files/4lbr_Docker_OnBoot.sh
