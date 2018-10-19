FROM debian
ADD needed_files_6lbr ./needed_files_6lbr
RUN chmod -R +x /needed_files_6lbr && needed_files_6lbr/6lbr_Docker_Install.sh
ADD needed_files_tayga ./needed_files_tayga
RUN chmod -R +x /needed_files_tayga && needed_files_tayga/Tayga_Docker_Install.sh
CMD bash
