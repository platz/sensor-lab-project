#include <lib6lowpan/lib6lowpan.h>
#include "blip_printf.h"

configuration ShowcaseC {

} implementation {
	components MainC, LedsC;
	components ShowcaseP;

	ShowcaseP -> MainC.Boot;

	ShowcaseP.Boot -> MainC;


	components IPStackC;
	components StaticIPAddressTosIdC;
	ShowcaseP.RadioControl -> IPStackC;

	components UdpC, IPDispatchC;
	ShowcaseP.IPStats -> IPDispatchC;
	ShowcaseP.UDPStats -> UdpC;

	components UDPShellC;

#ifdef RPL_ROUTING
	components RPLRoutingC;
#endif

	components new TimerMilliC();
	ShowcaseP.StatusTimer -> TimerMilliC;

	components new UdpSocketC() as Echo;
	ShowcaseP.Echo -> Echo;

	components new UdpSocketC() as Status;
	ShowcaseP.Status -> Status;

	components RandomC;
	ShowcaseP.Random -> RandomC;

	components TelosbC;

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
