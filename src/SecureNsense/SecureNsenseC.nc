configuration SecureNsenseC {
} implementation {
	components MainC, LedsC, SecureNsenseP;
	SecureNsenseP.Boot -> MainC;
	SecureNsenseP.Leds -> LedsC;

	components IPStackC;
	components RPLRoutingC;
	components StaticIPAddressTosIdC;
	SecureNsenseP.RadioControl -> IPStackC;

	components new TimerMilliC() as SenseTimer;
	SecureNsenseP.SenseTimer -> SenseTimer;

	components new  SensirionSht11C() as TemperateHumiditySensor;
	SecureNsenseP.Temperature -> TemperateHumiditySensor.Temperature;
	SecureNsenseP.Humidity -> TemperateHumiditySensor.Humidity;

	components new HamamatsuS1087ParC() as LightPar;
	components new HamamatsuS10871TsrC() as LightTsr;
	SecureNsenseP.LightPar -> LightPar.Read;
	SecureNsenseP.LightTsr -> LightTsr.Read;

	components new UdpSocketC() as SenseSend;
	SecureNsenseP.SenseSend -> SenseSend;
	components new UdpSocketC() as ConfigSend;
	SecureNsenseP.ConfigSend -> ConfigSend;

	components IrqPortC;
	SecureNsenseP.Get -> IrqPortC;
  	SecureNsenseP.Notify -> IrqPortC;

	components UDPShellC;
	components new ShellCommandC("get") as ConfigGet;
	components new ShellCommandC("set") as ConfigSet;
	SecureNsenseP.ConfigGet -> ConfigGet;
	SecureNsenseP.ConfigSet -> ConfigSet;

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
