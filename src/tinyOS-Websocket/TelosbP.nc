module TelosbP {
	uses {
		interface Leds;
		interface ShellCommand as Led0;
		interface ShellCommand as Led1;
		interface ShellCommand as Led2;
		interface ShellCommand as Sense;
		interface Read<uint16_t> as LightPar;
		interface Read<uint16_t> as LightTsr;
		interface Read<uint16_t> as Temperature;
		interface Read<uint16_t> as Humidity;
		interface Boot;
		interface Timer<TMilli> as UpdateTimer;
	}
} implementation {

	uint16_t m_LightPar, m_LightTsr, m_temp, m_humid;

	event char *Led0.eval(int argc, char **argv) {
		char *ret = call Led0.getBuffer(16);
		call Leds.led0Toggle();
		if (ret != NULL) {
			strncpy(ret, ">>>Toggle Led0\n", 16);
		}
		return ret;
	} 

	event char *Led1.eval(int argc, char **argv) {
		char *ret = call Led1.getBuffer(16);
		call Leds.led1Toggle();
		if (ret != NULL) {
			strncpy(ret, ">>>Toggle Led1\n", 16);
		}
		return ret;
	} 

	event char *Led2.eval(int argc, char **argv) {
		char *ret = call Led2.getBuffer(16);
		call Leds.led2Toggle();
		if (ret != NULL) {
			strncpy(ret, ">>>Toggle Led2\n", 16);
		}
		return ret;
	} 

	event void Boot.booted() {
		call UpdateTimer.startPeriodic(500);
	}

	event void UpdateTimer.fired() {
		call LightPar.read();
		call LightTsr.read();
		call Temperature.read();
		call Humidity.read();
	}

	void set_value(error_t error, uint16_t val,uint16_t* var) {
		if (error == SUCCESS)
		  *var = val;
		else
		 *var = 0xFFFF;
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

	event char *Sense.eval(int argc, char **argv) {
		char *ret = call Sense.getBuffer(100);
		if (ret != NULL) {
			sprintf(ret, "\t[LightPar: %d]\n\t[LightTsr: %d]\n\t[temperature: %d]\n\t[humidity: %d]\n",m_LightPar, m_LightTsr,m_temp,m_humid);
		}
		return ret;
	} 

}
