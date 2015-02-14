#include <lib6lowpan/ip.h>
#include "sensing.h"
#include "blip_printf.h"

module SensingP {
	uses {
		interface Boot;
		interface Leds;
		interface SplitControl as RadioControl;
		interface UDP as TheftSend;
		interface Timer<TMilli> as SenseTimerLight;
		interface Read<uint16_t> as LightVal;
		interface ShellCommand as SetThreshold;
	}

} implementation {

	enum {
		SENSE_PERIOD = 250, // ms
	};

	nx_struct theft_report theft_struct;
	nx_struct light_report light_struct;

	struct sockaddr_in6 route_dest;
	struct sockaddr_in6 route_dest_light;
	uint16_t m_light = 0;
	uint16_t theft_threshold = 15;

	event void Boot.booted() {
		call RadioControl.start();
	}

	event void RadioControl.startDone(error_t e) {
		route_dest.sin6_port = htons(7777); // port for reporting theft
		route_dest_light.sin6_port = htons(6666); // port for sending light sensor data
		inet_pton6(REPORT_DEST, &route_dest.sin6_addr);
		inet_pton6(REPORT_DEST, &route_dest_light.sin6_addr);
		call SenseTimerLight.startPeriodic(SENSE_PERIOD);
	}

	task void report_theft() {
		call Leds.led0On();
		call Leds.led1On();
		call Leds.led2On();

		theft_struct.sender = TOS_NODE_ID;
		theft_struct.light = m_light;
		call TheftSend.sendto(&route_dest, &theft_struct, sizeof(theft_struct));
	}

	task void report_light() {
		call Leds.led0Off();
		call Leds.led1Off();
		call Leds.led2Off();

		light_struct.seqno++;
		light_struct.sender = TOS_NODE_ID;
		light_struct.light = m_light;
		call TheftSend.sendto(&route_dest_light, &light_struct, sizeof(light_struct));
		
	}

	event void TheftSend.recvfrom(struct sockaddr_in6 *from, 
			void *data, uint16_t len, struct ip6_metadata *meta) {}


	// --- LightPar
	event void SenseTimerLight.fired() {
		call LightVal.read();
	}

	event void LightVal.readDone(error_t ok, uint16_t val) {
		if (ok == SUCCESS) {
			m_light = val;

			if(m_light <= theft_threshold)
				post report_theft();
			else
				post report_light();
		}
	}

	// --- Set threshold for light sensor to fire theft alarm
	event char* SetThreshold.eval(int argc, char* argv[]) {
		char* reply_buf = call SetThreshold.getBuffer(35);
		switch (argc) {
			case 2:
				theft_threshold = atoi(argv[1]);
			case 1: 
				sprintf(reply_buf, "theft treshold set to %d\n", theft_threshold);
				break;
			default:
				strcpy(reply_buf, "Usage: thresh <illuminance value/in lx> (a good indoor range value is 15-30)\n");
		}
		return reply_buf;
	}

	event void RadioControl.stopDone(error_t e) {}
}








