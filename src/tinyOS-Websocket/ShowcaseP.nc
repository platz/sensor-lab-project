#include <lib6lowpan/ip.h>
#include <lib6lowpan/lib6lowpan.h>

#include "UDPReport.h"

#define REPORT_PERIOD 75L

module ShowcaseP {
  uses {
    interface Boot;
    interface SplitControl as RadioControl;

    interface UDP as Echo;
    interface UDP as Status;
    
    interface Timer<TMilli> as StatusTimer;
   
    interface BlipStatistics<ip_statistics_t> as IPStats;
    interface BlipStatistics<udp_statistics_t> as UDPStats;

    interface Random;
  }

} implementation {

  bool timerStarted;
  nx_struct udp_report stats;
  struct sockaddr_in6 route_dest;

  event void Boot.booted() {
    call RadioControl.start();
    timerStarted = FALSE;

    call IPStats.clear();

#ifdef REPORT_DEST
    route_dest.sin6_port = htons(7000);
    inet_pton6(REPORT_DEST, &route_dest.sin6_addr);
    call StatusTimer.startOneShot(call Random.rand16() % (1024 * REPORT_PERIOD));
#endif

    dbg("Boot", "booted: %i\n", TOS_NODE_ID);
    call Echo.bind(7);
    call Status.bind(7001);
  }

  event void RadioControl.startDone(error_t e) {

  }

  event void RadioControl.stopDone(error_t e) {

  }

  event void Status.recvfrom(struct sockaddr_in6 *from, void *data, 
                             uint16_t len, struct ip6_metadata *meta) {

  }

  event void Echo.recvfrom(struct sockaddr_in6 *from, void *data, 
                           uint16_t len, struct ip6_metadata *meta) {
    call Echo.sendto(from, data, len);
  }

  enum {
    STATUS_SIZE = sizeof(ip_statistics_t) + 
    sizeof(route_statistics_t) +
    sizeof(icmp_statistics_t) + sizeof(udp_statistics_t),
  };


  event void StatusTimer.fired() {
    if (!timerStarted) {
      call StatusTimer.startPeriodic(1024 * REPORT_PERIOD);
      timerStarted = TRUE;
    }

    stats.seqno++;
    stats.sender = TOS_NODE_ID;

    call IPStats.get(&stats.ip);
    call UDPStats.get(&stats.udp);

    call Status.sendto(&route_dest, &stats, sizeof(stats));
  }
}
