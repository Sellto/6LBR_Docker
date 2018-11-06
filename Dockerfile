%6LBR -> 4LBR
FROM debian
ADD needed_files_6lbr ./needed_files_6lbr
RUN chmod -R +x /needed_files_6lbr && needed_files_6lbr/6lbr_Docker_Install.sh
ADD needed_files_tayga ./needed_files_tayga
RUN chmod -R +x /needed_files_tayga && needed_files_tayga/Tayga_Docker_Install.sh
ENV LWM2MSERVER="cccc::64:ac11:2"
CMD needed_files_6lbr/6lbr_Docker_OnBoot.sh
