# TECHNISCHE UNIVERSITÄT BERLIN
# Sensor-Networks Lab Project

Environment monitoring with intrusion detection using the open-source TelosB / TmoteSky platform with tinyOS as the wireless sensor node operating system. Environment monitoring is done by sending periodically the on-board sensor data (light, humidity and temperature). Intrusion is detected by a reed-switch on interrupt. Both data is sent via the 6LoWPAN stack using UDP sockets to a Python request handler. There, the data is distributed to the Tornado Websocket Server, into different channels. These channels are separated by URIs so that connecting clients to the Tornado Websocket Server can hook to different channels.

# Remote Sensor App

The remote sensor app communicates via websocket connection to the webserver. It is capable to get realtime information about sensor datas. The application is build in iOS swift and uses the open WebSocket Library Starscream for Websocket-communication in Swift.

## Prerequisites

Hardware:
- TelosB / TmoteSky development platform
- Reed-Switch
- iPhone 5

Software:
- Python ≥ 3.4 or Python 3.3 with the asyncio module

- Tornado 2.0: http://github.com/downloads/facebook/tornado/tornado-2.0.tar.gz

- Python websockets 2.4: https://pypi.python.org/pypi/websockets
- iOS8
-  Swift programming language
-  Starscream WebSocket (Swift) https://github.com/daltoniam/starscream

## Installation

Python specific: Please have a look at the links above.

TinyOS specific: To flash a development board, navigate to <projectRoot>/src/SecureNsense/
and execute $>make telosb install,<node-id> bsl,/dev/ttyUSB<virtual USB Port>
please make sure to have a working TinyOS border router.

## Usage
1. Make sure your TinyOS nodes are running and sending.

2. Start the Tornado Websocket Server and navigate to <projectRoot>/src/tornado-2.0/tornado/ and execute $>python server.py

3. Start the Python Request Handler and navigate to <projectRoot>/src/requestHandler/ and execute $python Listener.py

4. Connect a websocket client to: "ws://127.0.0.1:8888/sensing" or "ws://127.0.0.1:8888/alarm"
   if you can't use the IOS-Client, a simple web client, named testclient.html is provided which you can find under: <projectRoot>/src/tornado-2.0/tornado/
   
or under: http://www.user.tu-berlin.de/alexander.platz/sensor-lab-project/testclient.html

   You can download it or just use it as it is from the internet. If you use it from the internet
   please make sure you have active port-forwarding (:8888) on the local router where the machine with the
   Tornado Websocket Server is running.  
   
   
## Installation Swift Source Code
   1. Make sure you run the latest version of xcode to be able to compile the project files
   2. Note that the delivery of prebuild apps is not supported by apple, without a paid Developers account.
   3. As soon you opened the project in xcode you can run it on an iPhone - Simulator
   4. To run the app on a smartphone, you need a paid apple developers account.
