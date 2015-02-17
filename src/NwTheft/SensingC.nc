configuration SensingC {
} implementation {
	components MainC, LedsC, SensingP;
	SensingP.Boot -> MainC;
	SensingP.Leds -> LedsC;

	components IPStackC;
	components RPLRoutingC;
	components StaticIPAddressTosIdC;
	SensingP.RadioControl -> IPStackC;

	components new TimerMilliC() as SenseTimer;
	SensingP.SenseTimer -> SenseTimer;

	components new  SensirionSht11C() as TemperateHumiditySensor;
	SensingP.Temperature -> TemperateHumiditySensor.Temperature;
	SensingP.Humidity -> TemperateHumiditySensor.Humidity;

	components new HamamatsuS1087ParC() as LightPar;
	components new HamamatsuS10871TsrC() as LightTsr;
	SensingP.LightPar -> LightPar.Read;
	SensingP.LightTsr -> LightTsr.Read;

	components new UdpSocketC() as SenseSend;
	SensingP.SenseSend -> SenseSend;

	components IrqPortC;
	SensingP.Get -> IrqPortC;
  	SensingP.Notify -> IrqPortC;

#ifdef PRINTFUART_ENABLED
  /* This component wires printf directly to the serial port, and does
   * not use any framing.  You can view the output simply by tailing
   * the serial device.  Unlike the old printfUART, this allows us to
   * use PlatformSerialC to provide the serial driver.
   *
   * For instance:
   * $ stty -F /dev/ttyUSB0 115200
   * $ tail -f /dev/ttyUSB0
  */
  components SerialPrintfC;

  /* This is the alternative printf implementation which puts the
   * output in framed tinyos serial messages.  This lets you operate
   * alongside other users of the tinyos serial stack.
   */
  // components PrintfC;
  // components SerialStartC;
#endif
}
