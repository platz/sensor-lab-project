#ifndef SENSING_H_
#define SENSING_H_

enum {
      AM_SENSING_REPORT = -1
};

nx_struct sensing_report {
  nx_uint16_t seqno;
  nx_uint16_t sender;
  nx_uint16_t humidity;
  nx_uint16_t temperature;
  nx_uint16_t lightPar;
  nx_uint16_t lightTsr;
  nx_uint8_t switchState;
} ;

typedef nx_struct settings {
  nx_uint16_t sensing_period;
  nx_uint16_t alive_cnt;
} settings_t;


#define REPORT_DEST "fec0::100"
#define MULTICAST "ff02::1"

#endif
