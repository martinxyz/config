// minimal raw socket example (public domain)
// send 3 ethernet frames (layer2), then print received frames
//
// compile:
// gcc --std=c99 -o raw_socket_minimal raw_socket_minimal.c
// run:
// ./raw_socket_minimal eth0

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/socket.h>
#include <time.h>
#include <fcntl.h>
#include <netpacket/packet.h>
#include <netinet/if_ether.h>
#include <linux/if.h> 

// global variables
uint8_t frame[2000];
uint16_t frame_size;

void setup_raw_socket(int *sock, char *if_name,
                      struct ifreq *ifinfo,
                      struct sockaddr_ll *sockinfo)
{
  printf("creating raw socket on interface '%s'\n", if_name);
  *sock = socket(AF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
  if (*sock == -1) {
    perror("cannot create socket");
    exit(1);
  }
    
  // get interface index number
  memset(ifinfo, 0, sizeof(struct ifreq));
  strcpy(ifinfo->ifr_name, if_name);
  if (ioctl(*sock, SIOCGIFINDEX, ifinfo) < 0) {
    perror("can't get interface index");
    exit(1);
  }
    
  // bind socket to specific interface
  memset(sockinfo, 0, sizeof(*sockinfo));
  sockinfo->sll_family = PF_PACKET;
  sockinfo->sll_protocol = htons(ETH_P_ALL);
  sockinfo->sll_ifindex = ifinfo->ifr_ifindex;
  if (bind(*sock, (struct sockaddr*)sockinfo, sizeof(*sockinfo)) < 0) {
    perror("can't bind socket");
    exit(1);
  }
}
/******************************************************************************/
void generate_frame(uint8_t *src_mac, unsigned char *dst_mac)
{
  int cnt = 0;
  int i = 0;
  // DST
  frame[i++] = dst_mac[0];
  frame[i++] = dst_mac[1];
  frame[i++] = dst_mac[2];
  frame[i++] = dst_mac[3];
  frame[i++] = dst_mac[4];
  frame[i++] = dst_mac[5];
  // SRC
  frame[i++] = src_mac[0];
  frame[i++] = src_mac[1];
  frame[i++] = src_mac[2];
  frame[i++] = src_mac[3];
  frame[i++] = src_mac[4];
  frame[i++] = src_mac[5];
  // Ethertype
  frame[i++] = 0xff;
  frame[i++] = 0xff;

  // pad to 60 bytes
  while (i<60) {
    frame[i++] = cnt;
    cnt++;
    cnt %= 16;
  }
    
  frame_size = i;
}

/******************************************************************************/
int main(int argc, char *argv[])
{
  int sock, uid;
  uint8_t *src_mac;
  char *iface;
  struct ifreq ifinfo_lre;
  struct sockaddr_ll sockinfo_lre;
  int packetsize = 2000;
  uint8_t packet[packetsize];
    
  unsigned char dst_mac[6] = {0x00,0x11,0x22,0x33,0x44,0x55};

  if (argc != 2) {
    printf("usage: %s <interface>.\n", argv[0]);
    exit(1);
  }
  iface = argv[1];
    
  uid = getuid();
  if (uid != 0) {
    printf("You must be root (UID 0 instead of %d).\n", uid);
    exit(1);
  }
     
  // create raw socket
  setup_raw_socket(&sock, iface, &ifinfo_lre, &sockinfo_lre);
    
  // get own mac address
  if (ioctl(sock, SIOCGIFHWADDR, &ifinfo_lre) < 0) {
    perror("could not get MAC address");
    exit(1);
  }
  src_mac = (uint8_t*)&ifinfo_lre.ifr_hwaddr.sa_data; 

  // generate a frame
  generate_frame(src_mac, dst_mac);
    
  for (int i=0; i<3; i++) {
    // send frame
    printf("sending frame %d/3\n", i+1);
    if ((sendto(sock, frame, frame_size, 0, (struct sockaddr*)&sockinfo_lre, sizeof(sockinfo_lre))) < frame_size) {
      perror("sendto() failed");
      exit(1);
    }
    if (i == 1) {
      printf("sleeping one second\n");
      sleep(1);
    }
  }
    
  printf(">>>>> Read packets out of the raw socket until you stop it <<<<<\n");
  while(1)
    {
      // read packets out of the raw socket and dump it
      struct sockaddr_ll addr;
      socklen_t addr_len = sizeof(addr);
      int length = recvfrom(sock, packet, packetsize, 0, (struct sockaddr*)&addr, &addr_len);
      if (length <= 0) {
        perror("recvfrom failed");
        exit(0);
      }
      if (addr.sll_pkttype == PACKET_OUTGOING) continue;

      // layer 2
      printf("DST_MAC: %02X:%02X:%02X:%02X:%02X:%02X\n", (int)packet[0],(int)packet[1],(int)packet[2],(int)packet[3],(int)packet[4],(int)packet[5]);
      printf("SRC_MAC: %02X:%02X:%02X:%02X:%02X:%02X\n", (int)packet[6],(int)packet[7],(int)packet[8],(int)packet[9],(int)packet[10],(int)packet[11]);
      printf("Ethertype: %02X%02X\n", (int)packet[12],(int)packet[13]);
      printf("Length: %d\n", length);
    }

  // never reached
  return 0;
}

