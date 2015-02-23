import socket
import websocket
import Sensing

rcvPort = 7000

def msgSensing(rpt):
    returnMsg = ""
	# --- splitted Message structure:
    # delimtedRpt: [0] = seqno, [1] = sender, [2] = humidity
    #              [3] = temperature,[4] = lightPar,[5] = lightTsr,
    #              [6] = switchState

    # --- Split the tinyOS Message
    delimitedRpt = rpt.split(';') # split message by delimiter ';'

    # --- Node ID
    nodeId = str(delimitedRpt[1])

    # --- Temperature value
    temp2Int = float(int(delimitedRpt[3], 0))
    temp2Int = round(-40 + 0.01 * temp2Int, 2) # convert to Celsius and round two decimals

    # --- Humidity value
    linHumid = -4.0 + 0.0405 * float(int(delimitedRpt[2], 0)) + (-2.8 * 0.000001 * float(int(delimitedRpt[2], 0)) * int(delimitedRpt[2], 0))
    trueHumid = round((temp2Int - 25.0) * (0.01 + 0.0008 * float(int(delimitedRpt[2], 0))) + linHumid, 2)

    # --- Light value
    vPar = ((float(int(delimitedRpt[4], 0)) / 4096) * 1.5) / 100
    vTsr = ((float(int(delimitedRpt[5], 0)) / 4096) * 1.5) / 100
    luxPar = round(0.625 * 1000000 * vPar * 1000, 2)
    luxTsr = round(0.769 * 100000 * vTsr * 1000, 2)

    # --- Reed Switch value
    reedSwitch = int(delimitedRpt[6], 0)
    if(reedSwitch == 0):
        reedMsg = "Intrusion!"
    else:
        reedMsg = "Safe."
    
    returnMsg = 'Node: ' +str(nodeId)+', Temperature: ' +str(temp2Int)+ ', linear Humid: ' +str(trueHumid)+ ', LightPar: ' +str(luxPar)+ ', LightTsr: ' +str(luxTsr)+ ', '+reedMsg

    return returnMsg

def msgAlarm(rpt):
    returnMsg = ""
	# --- splitted Message structure:
    # delimtedRpt: [0] = seqno, [1] = sender, [2] = humidity
    #              [3] = temperature,[4] = lightPar,[5] = lightTsr,
    #              [6] = switchState

    # --- Split the tinyOS Message
    delimitedRpt = rpt.split(';') # split message by delimiter ';'

    # --- Node ID
    nodeId = str(delimitedRpt[1])

    # --- Reed Switch value
    reedSwitch = int(delimitedRpt[6], 0)
    if(reedSwitch == 0):
        reedMsg = "Intrusion!"
    else:
        reedMsg = "Safe."

    returnMsg = 'Node: ' +str(nodeId)+ ', '+reedMsg

    return returnMsg

if __name__ == '__main__':

    rcvSocket = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
    rcvSocket.bind(('', rcvPort))

    #websocket.enableTrace(True)
    try:
        wsSensing = websocket.create_connection('ws://localhost:8888/sensing')
        wsAlarm = websocket.create_connection('ws://localhost:8888/alarm')

    except:
        print ('unable to connect')

    while True:
        data, addr = rcvSocket.recvfrom(1024)
        if (len(data) > 0):
            # --- forwarding data via websocket to server
            rpt = Sensing.Sensing(data=data, data_length=len(data))
            rpt = str(rpt)
            #print rpt

            wsSensing.send(msgSensing(rpt))
            wsAlarm.send(msgAlarm(rpt))

            resultSensing = wsSensing.recv() # for echo testing
            resultAlarm = wsAlarm.recv()

            # --- for echo testing
            #print("Received: {}".format(resultSensing))
            #print("Received: {}".format(resultAlarm))


    wsSensing.close()
    wsAlarm.close()


			

