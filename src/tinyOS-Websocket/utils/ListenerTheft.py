import socket
import websocket
import SensingTheft
import re
import sys

rcvPort = 7777
#fwdUdpPort = 2000
#fwdWsPort = 8888
fwdHost = '127.0.0.1'

if __name__ == '__main__':

    rcvSocket = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
    rcvSocket.bind(('', rcvPort))
    
    websocket.enableTrace(True)
    try:
        ws = websocket.create_connection("ws://127.0.0.1:8888/wsNeu")
    except:
        print 'unable to connect'

    while True:
        data, addr = rcvSocket.recvfrom(1024)
        if (len(data) > 0):
            # --- forwarding data via websocket to server
            rpt = SensingTheft.SensingTheft(data=data, data_length=len(data))
	
            print addr
            print rpt
            #fwdSocket.send(str(rpt))

            ws.send(str(rpt))
            print("Theft: Sent")
            result = ws.recv()
            #print("Received {}".format(result))
            #ws.close()







    
    '''
    ---> this is the UDP Socket version

    fwdSocket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        fwdSocket.connect((fwdHost, fwdUdpPort))
    except:
        print 'unable to connect'

    while True:
        data, addr = rcvSocket.recvfrom(1024)
        #data = rcvSocket.recv(1024)
        if (len(data) > 0):
            rpt = SensingTheft.SensingTheft(data=data, data_length=len(data))
			
            print addr
            print rpt
            fwdSocket.send(str(rpt))
    
    <--- UDP Socket version
    '''
	
			

			

