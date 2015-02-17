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

#define REPORT_DEST "fec0::1"

#endif
