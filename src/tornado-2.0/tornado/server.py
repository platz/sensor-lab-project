from websocket import WebSocketHandler
import tornado.httpserver
import tornado.websocket
import tornado.ioloop
import tornado.web

class WSHandlerSensing(tornado.websocket.WebSocketHandler):

    def check_origin(self, origin):
        return True

    def open(self):
        channelSensing.append(self) # this appends a connection instance
        for channel in channelSensing:
            print channel
        print 'new connection URI: /sensing'
        self.write_message('Connection established URI: /sensing')
      
    def on_message(self, message):
        #print 'message received via websocket, uri: "/sensing": %s' % message
        for self in channelSensing:
            self.write_message('Sensing: ' +message)
 
    def on_close(self):
        channelSensing.remove(self) # this removes an appended connection instance
        print 'connection closed URI: /sensing'

class WSHandlerAlarm(tornado.websocket.WebSocketHandler):

    def check_origin(self, origin):
        return True

    def open(self):
        channelAlarm.append(self) # this appends a connection instance
        for channel in channelAlarm:
            print channel
        print 'new connection URI: /alarm'
        self.write_message('Connection established URI: /alarm')

    def on_message(self, message):
        #print 'message received via websocket, uri: "/alarm":\n%s' % message
        for self in channelAlarm:
            self.write_message('Alarm: ' +message)

    def on_close(self):
        channelAlarm.remove(self) # this removes an appended connection instance
        print 'connection closed URI: /alarm'

class WSHandlerEcho(tornado.websocket.WebSocketHandler):

    def check_origin(self, origin):
        return True

    def open(self):
        channelEcho.append(self) # this appends a connection instance
        for channel in channelEcho:
            print channel
        print 'new connection URI: /echo'
        self.write_message('Connection established URI: /echo')

    def on_message(self, message):
        print 'message received via websocket, uri: "/echo":\n%s' % message
        # this is for broadcasting messages to all appended connection instances
        for self in channelEcho:
            self.write_message('Echo Echo: ' +message)
            #self.write_message('Instance: ' +str(self))

    def on_close(self):
        channelEcho.remove(self) # this removes an appended connection instance
        print 'connection closed URI: /echo'

class WSHandlerSettings(tornado.websocket.WebSocketHandler):

    def check_origin(self, origin):
        return True

    def open(self):
        channelSettings.append(self) # this appends a connection instance
        for channel in channelSettings:
            print channel
        print 'new connection URI: /settings'
        #self.write_message('Connection established URI: /settings')

    def on_message(self, message):
        print 'message received via websocket, uri: "/settings":\n%s' % message
        # this is for broadcasting messages to all appended connection instances
        for self in channelSettings:
            self.write_message(message)
            #self.write_message('Echo Settings: ' +message+ 'Instance: ' +str(self))
            #self.write_message('Instance: ' +str(self))

    def on_close(self):
        channelSettings.remove(self) # this removes an appended connection instance
        print 'connection closed URI: /settings'

application = tornado.web.Application([
    (r'/sensing', WSHandlerSensing),
    (r'/alarm', WSHandlerAlarm),
    (r'/echo', WSHandlerEcho),
    (r'/settings', WSHandlerSettings),
])

if __name__ == "__main__":
    channelSensing = []
    channelAlarm = []
    channelEcho = []
    channelSettings = []
    http_server = tornado.httpserver.HTTPServer(application)
    http_server.listen(8888)
    http_server.start()
    tornado.ioloop.IOLoop.instance().start()






