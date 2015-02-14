import tornado.httpserver
import tornado.websocket
import tornado.ioloop
import tornado.web

class WSHandler(tornado.websocket.WebSocketHandler):

    def check_origin(self, origin):
        return True

    def open(self):
        print 'new connection'
        self.write_message('Connection established')
      
    def on_message(self, message):
        print 'message received via websocket, uri: "myWs": %s' % message
        self.write_message('Echo: ' +message)
 
    def on_close(self):
        print 'connection closed'
 
application = tornado.web.Application([
    (r'/myWs', WSHandler),
])

class WSHandlerNeu(tornado.websocket.WebSocketHandler):
    def check_origin(self, origin):
        return True

    def open(self):
        print 'new connection'
        self.write_message('Connection established')

    def on_message(self, message):
        print 'message received via websocket, uri: "wsNeu":\n%s' % message
        self.write_message('Echo Neuuuuuu: ' +message)

    def on_close(self):
        print 'connection closed'

application = tornado.web.Application([
    (r'/wsNeu', WSHandlerNeu),
])
 
 
if __name__ == "__main__":
    http_server = tornado.httpserver.HTTPServer(application)
    http_server.listen(8888)
    tornado.ioloop.IOLoop.instance().start()
