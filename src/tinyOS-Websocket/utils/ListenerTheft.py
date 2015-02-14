import socket
import SensingTheft
import re
import sys

rcvPort = 7777
fwdPort = 2000
fwdHost = '127.0.0.1'

if __name__ == '__main__':

    rcvSocket = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
    rcvSocket.bind(('', rcvPort))

    # --- the next step would be forwarding via websocket
    fwdSocket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        fwdSocket.connect((fwdHost, fwdPort))
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
			
			

			

