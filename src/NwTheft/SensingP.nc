#include <lib6lowpan/ip.h>
#include "sensing.h"
#include "IrqPort.h"
#include "blip_printf.h"

module SensingP {
	uses {
		interface Boot;
		interface Leds;
		interface SplitControl as RadioControl;
		interface UDP as SenseSend;
		interface UDP as ConfigSend;
		
		interface Timer<TMilli> as SenseTimer;
		interface Read<uint16_t> as Humidity;
		interface Read<uint16_t> as Temperature;
		interface Read<uint16_t> as LightPar;
		interface Read<uint16_t> as LightTsr;

		interface Get<port_state_t>;
    		interface Notify<port_state_t>;

		interface ShellCommand as ConfigSet;
		interface ShellCommand as ConfigGet;
	}

} implementation {

	enum {
		SENSE_PERIOD = 1000, // ms
		ALIVE_COUNT = 10, 
	};

	nx_struct sensing_report stats;
	struct sockaddr_in6 route_dest;
	struct sockaddr_in6 multicast;

	
	uint16_t m_LightPar, m_LightTsr, m_temp, m_humid;
	uint16_t aliveCnt = 0;
	port_state_t bs;
	settings_t settings;	

	event void Boot.booted() {
		call RadioControl.start();
		call Notify.enable();
		settings.alive_cnt = ALIVE_COUNT;
		settings.sensing_period = SENSE_PERIOD;
	}

	event void RadioControl.startDone(error_t e) {
		route_dest.sin6_port = htons(7000);
		inet_pton6(REPORT_DEST, &route_dest.sin6_addr);
		call SenseTimer.startPeriodic(settings.sensing_period);

		multicast.sin6_port = htons(4000);
		inet_pton6(MULTICAST, &multicast.sin6_addr);
		call ConfigSend.bind(4000);
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

	
	event void ConfigSend.recvfrom(struct sockaddr_in6 *from, void *data, uint16_t len, struct ip6_metadata *meta) {
		memcpy(&settings, data, sizeof(settings_t));
		call SenseTimer.startPeriodic(settings.sensing_period);
		
	}
	event void SenseTimer.fired() {
		call Humidity.read();
		call Temperature.read();
		call LightPar.read();
		call LightTsr.read();
		bs = call Get.get();
		if(aliveCnt >= settings.alive_cnt){
			post report_values(); // alive message
			call ConfigSend.sendto(&multicast, &settings, sizeof(settings)); // send config message with alive message to auto configure new nodes
			aliveCnt = 0;	
		}
		aliveCnt++;
		call Leds.led1Toggle();
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
	post report_values();
	} else if ( state == SWITCH_OPEN ) {
	call Leds.led2Off();
	} 
	call Leds.led0Toggle();
	}

	event char* ConfigSet.eval(int argc, char* argv[]) {
		char *ret = call ConfigSet.getBuffer(40);
		if (ret != NULL) {
			if (argc == 3) { 
				if (!strcmp("per",argv[1])) {
					settings.sensing_period = atoi(argv[2]);
					sprintf(ret, ">>>Timer Period changed to %u\n",settings.sensing_period);
					call ConfigSend.sendto(&multicast, &settings, sizeof(settings));
					call SenseTimer.startPeriodic(settings.sensing_period);
				
				} else if (!strcmp("cnt", argv[1])) {
					settings.alive_cnt = atoi(argv[2]);
					sprintf(ret, ">>>Alive Message Counter changed to %u\n",settings.alive_cnt);
					call ConfigSend.sendto(&multicast, &settings, sizeof(settings));
				} else {
					strcpy(ret,"Usage: set per|cnt [<sampleperiod in ms>|<alivecnt>]\n");
				}
			} else {
				strcpy(ret,"Usage: set per|cnt [<sampleperiod in ms>|<alivecnt> counts of per until alive msg]\n");
			}
		}
		return ret;
	}

	event char *ConfigGet.eval(int argc, char **argv) {
		char *ret = call ConfigGet.getBuffer(40);
		if (ret != NULL) {
			switch (argc) {
				case 1:
					sprintf(ret, "\t[Period: %u]\n\t[alivecnt: %u]\n", settings.sensing_period, settings.alive_cnt);
					break;
				case 2: 
					if (!strcmp("per",argv[1])) {
						sprintf(ret, "\t[Period: %u]\n", settings.sensing_period);
					} else if (!strcmp("cnt", argv[1])) {
						sprintf(ret, "\t[alivecnt: %u]\n",settings.alive_cnt);
					} else {
						strcpy(ret, "Usage: get [per|cnt]\n");
					}
					break;
				default:
					strcpy(ret, "Usage: get [per|cnt]\n");
			}
		}
		return ret;
	}


}
