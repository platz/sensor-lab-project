# TECHNISCHE UNIVERSITÄT BERLIN
# Sensor-Networks Lab Project

Environment monitoring with intrusion detection using the open-source TelosB / TmoteSky platform with tinyOS as the wireless sensor node operating system. Environment monitoring is done by sending periodically the on-board sensor data (light, humidity and temperature). Intrusion is detected by a reed-switch on interrupt. Both data is sent via an IPv6 UDP socket to a Python request handler. There, the data is distributed to the Tornado Websocket Server, into different channels. These channels are separated by URIs so that connecting clients to the Tornado Websocket Server can hook to different channels.  

## Prerequisites

Hardware:
- TelosB / TmoteSky development platform
- Reed-Switch

Software:
- Python ≥ 3.4 or Python 3.3 with the asyncio module

- Tornado 2.0
http://github.com/downloads/facebook/tornado/tornado-2.0.tar.gz

- Python websockets 2.4
https://pypi.python.org/pypi/websockets

## Installation

Python specific: please have a look the links above

TinyOS specific: To flash a development board, navigate to <projectRoot>/src/SecureNsense/
and execute $>make telosb install,<node-id> bsl,/dev/ttyUSB<virtual USB Port>
please make sure to have a working TinyOS border router

## Usage
1. Make sure your TinyOS nodes are running and sending.

2. Start the Tornado Websocket Server
   navigate to <projectRoot>/src/tornado-2.0/tornado/ and execute 
   $>python server.py

3. Start the Python Request Handler
   navigate to <projectRoot>/src/requestHandler/ and execute
   $python Listener.py

4. Connect a websocket client to: "ws://127.0.0.1:8888/sensing" or "ws://127.0.0.1:8888/sensing"
   if you can't use the IOS-Client a simple web client is provided which you can find under:
   http://www.user.tu-berlin.de/alexander.platz/sensor-lab-project/testclient.html

   You can download it or just use it as it is from the internet. If you use it from the internet
   please make sure you have active port-forwarding (:8888) to the machine where the
   Tornado Websocket Server is running.  
