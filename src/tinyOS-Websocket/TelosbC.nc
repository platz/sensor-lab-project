configuration TelosbC {

} implementation {
	components MainC,LedsC,TelosbP;
	TelosbP.Boot -> MainC;
	TelosbP.Leds -> LedsC;

	components new TimerMilliC() as UpdateTimer;
	TelosbP.UpdateTimer -> UpdateTimer;

	components new ShellCommandC("led0") as Led0;
	components new ShellCommandC("led1") as Led1;
	components new ShellCommandC("led2") as Led2;
	components new ShellCommandC("sense") as Sense;
	TelosbP.Led0 -> Led0;
	TelosbP.Led1 -> Led1;
	TelosbP.Led2 -> Led2;
	TelosbP.Sense -> Sense;

	components new HamamatsuS1087ParC() as LightPar;
	components new HamamatsuS10871TsrC() as LightTsr;
	TelosbP.LightPar -> LightPar.Read;
	TelosbP.LightTsr -> LightTsr.Read;

	components new  SensirionSht11C() as TemperateHumiditySensor;
	TelosbP.Temperature -> TemperateHumiditySensor.Temperature;
	TelosbP.Humidity -> TemperateHumiditySensor.Humidity;
}


