
       #include <arpa/inet.h>
       #include <ifaddrs.h>
       #include <stdio.h>
       #include <stdlib.h>
       #include <string.h>
       #include <regex.h>

       #define MAX_LENGTH 128
       #define DEFAULT_IP6_PREF_LGT 64




       char *getIPV6NatSubnet(int net_lenght, char *addr);
       char *getIPV6Prefix(int Lenght, char *addr);
       char *getIPV6Router(char *addr);
       char *getIPV4Router(char *addr);


       int main(int argc, char *argv[]){
           struct ifaddrs *ifaddr, *ifa;
           int err , match;
           char addr[MAX_LENGTH], net[MAX_LENGTH];
           char *ipv4name,*ipv4addr;
           regex_t preg;

           if (getifaddrs(&ifaddr) == -1) {
               perror("getifaddrs");
               exit(EXIT_FAILURE);
           }

            for (ifa = ifaddr; ifa != NULL; ifa = ifa->ifa_next) {
               if (ifa->ifa_addr == NULL)
                    continue;
               if(ifa->ifa_addr->sa_family == AF_INET && !(strcmp(ifa->ifa_name,"eth0")))
               {
                 inet_ntop(AF_INET, &(((struct sockaddr_in *)ifa->ifa_addr)->sin_addr), addr, MAX_LENGTH);
                 ipv4addr = malloc(strlen(addr) + 1);
                 strcpy(ipv4addr,addr);
               }
            }

            if(argc==1)
            {
              printf("Available commands:\n\n");
              printf("--ipv4addr\t\t\t\tIPV4 address\n");
              printf("--ipv4router\t\t\t\tIPV4 router address\n\n");
            }
            else if (!(strcmp(argv[1],"--ipv4addr")))
            {
              printf("%s\n",ipv4addr);
            }
            else if (!(strcmp(argv[1],"--ipv4router")))
            {
              printf("%s\n",getIPV4Router(ipv4addr));
            }
           freeifaddrs(ifaddr);
           exit(EXIT_SUCCESS);
       }

       char *getIPV4Router(char *addr)
       {
         char *expanse_addr,*collapse_addr,*save;
         expanse_addr=malloc(MAX_LENGTH/2);
         collapse_addr=malloc(MAX_LENGTH/2);
         inet_pton(AF_INET, addr, expanse_addr);
         expanse_addr[2]=0x00;
         expanse_addr[3]=0x01;
         inet_ntop(AF_INET, expanse_addr,collapse_addr, MAX_LENGTH);
         save = malloc(strlen(collapse_addr) + 1);
         strcpy(save,collapse_addr);
         return save;
       }
