configuration SensingC {
} implementation {
	components MainC, LedsC, SensingP;
	SensingP.Boot -> MainC;
	SensingP.Leds -> LedsC;

	components IPStackC;
	components RPLRoutingC;

	components UdpC;
	components UDPShellC;

	components StaticIPAddressTosIdC;
	SensingP.RadioControl -> IPStackC;

	components new TimerMilliC() as SenseTimerLight;
	SensingP.SenseTimerLight -> SenseTimerLight;

	components new HamamatsuS1087ParC() as SensorPar;
	SensingP.LightVal -> SensorPar;

	components new UdpSocketC() as TheftSend;
	SensingP.TheftSend -> TheftSend;

	components new ShellCommandC("thresh") as SetThreshold;
	SensingP.SetThreshold -> SetThreshold;

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
