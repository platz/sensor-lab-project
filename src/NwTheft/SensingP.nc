#include <lib6lowpan/ip.h>
#include "sensing.h"
#include "IrqPort.h"

module SensingP {
	uses {
		interface Boot;
		interface Leds;
		interface SplitControl as RadioControl;
		interface UDP as SenseSend;
		interface Timer<TMilli> as SenseTimer;
		interface Read<uint16_t> as Humidity;
		interface Read<uint16_t> as Temperature;
		interface Read<uint16_t> as LightPar;
		interface Read<uint16_t> as LightTsr;

		interface Get<port_state_t>;
    		interface Notify<port_state_t>;
	}

} implementation {

	enum {
		SENSE_PERIOD = 500, // ms
	};

	nx_struct sensing_report stats;
	struct sockaddr_in6 route_dest;
	
	uint16_t m_LightPar, m_LightTsr, m_temp, m_humid;
	port_state_t bs;
	

	event void Boot.booted() {
		call RadioControl.start();
	}

	event void RadioControl.startDone(error_t e) {
		route_dest.sin6_port = htons(7000);
		inet_pton6(REPORT_DEST, &route_dest.sin6_addr);
		call SenseTimer.startPeriodic(SENSE_PERIOD);
	}

	task void report_values() {
		stats.seqno++;
		stats.sender = TOS_NODE_ID;
		stats.humidity = m_humid;
		stats.temperature = m_temp;
		stats.lightPar = m_LightPar;
		stats.lightTsr = m_LightTsr;
		stats.switchState = bs;
		call SenseSend.sendto(&route_dest, &stats, sizeof(stats));
	}
	
	void set_value(error_t error, uint16_t val,uint16_t* var) {
		if (error == SUCCESS)
		  *var = val;
		else
		 *var = 0xFFFF;
	}

	event void SenseSend.recvfrom(struct sockaddr_in6 *from, 
			void *data, uint16_t len, struct ip6_metadata *meta) {}

	event void SenseTimer.fired() {
		call Humidity.read();
		call Temperature.read();
		call LightPar.read();
		call LightTsr.read();
		bs = call Get.get();
	}

	event void LightPar.readDone(error_t error, uint16_t val) {
		set_value(error,val,&m_LightPar);
	}

	event void LightTsr.readDone(error_t error, uint16_t val) {
		set_value(error,val,&m_LightTsr); 
	}

	event void Temperature.readDone(error_t error, uint16_t val) {
		set_value(error,val,&m_temp);
	}

	event void Humidity.readDone(error_t error, uint16_t val) {
		set_value(error,val,&m_humid); 
	}

	event void RadioControl.stopDone(error_t e) {}

	event void Notify.notify( port_state_t state ) {
	if ( state == SWITCH_CLOSED ) {
	call Leds.led2On();
	} else if ( state == SWITCH_OPEN ) {
	call Leds.led2Off();
	} 
	call Leds.led0Toggle();
	}
/*
	event void Timer.fired() {    
	port_state_t bs;

	bs = call Get.get();

	if ( bs == SWITCH_CLOSED ) {
	call Leds.led1On();
	} else if ( bs == SWITCH_OPEN ) {
	call Leds.led1Off();
	}
  	}
*/
}
