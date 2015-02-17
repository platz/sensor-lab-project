from websocket import WebSocketHandler
import tornado.httpserver
import tornado.websocket
import tornado.ioloop
import tornado.web

class WSHandlerSensing(tornado.websocket.WebSocketHandler):

    def check_origin(self, origin):
        return True

    def open(self):
        print 'new connection URI: /sensing'
        self.write_message('Connection established URI: /sensing')
      
    def on_message(self, message):
        print 'message received via websocket, uri: "/sensing": %s' % message
        self.write_message('Echo Sensing: ' +message)
 
    def on_close(self):
        print 'connection closed URI: /sensing'

class WSHandlerAlarm(tornado.websocket.WebSocketHandler):

    def check_origin(self, origin):
        return True

    def open(self):
        print 'new connection URI: /alarm'
        self.write_message('Connection established URI: /alarm')

    def on_message(self, message):
        print 'message received via websocket, uri: "/alarm":\n%s' % message
        self.write_message('Echo Alarm: ' +message)

    def on_close(self):
        print 'connection closed URI: /alarm'

class WSHandlerEcho(tornado.websocket.WebSocketHandler):

    def check_origin(self, origin):
        return True

    def open(self):
        connArr.append(self) # this appends a connection instance
        for item in connArr:
            print item
        print 'new connection URI: /echo'
        self.write_message('Connection established URI: /echo')

    def on_message(self, message):
        print 'message received via websocket, uri: "/echo":\n%s' % message
        # this is for broadcasting messages to all appended connection instances
        for self in connArr:
            self.write_message('Echo Echo: ' +message+ ' self: ' +str(self))

    def on_close(self):
        connArr.remove(self) # this removes an appended connection instance
        print 'connection closed URI: /echo'

application = tornado.web.Application([
    (r'/sensing', WSHandlerSensing),
    (r'/alarm', WSHandlerAlarm),
    (r'/echo', WSHandlerEcho),
])

if __name__ == "__main__":

    connArr = []
    http_server = tornado.httpserver.HTTPServer(application)
    http_server.listen(8888)
    tornado.ioloop.IOLoop.instance().start()









