//
//  ViewController.swift
//  SimpleTest
//
//  Created by Dalton Cherry on 8/12/14.
//  Copyright (c) 2014 vluxe. All rights reserved.
//

import UIKit
import Starscream

class ViewController: UIViewController, WebSocketDelegate {
    
    // var endpoint = "ws://141.23.84.201:8888/ws"
    //var endpoint = "ws://sockets.mbed.org/ws/platz/ro"
    
    
    //var socket = WebSocket(url: NSURL(scheme: "ws", host: "axinen.ddns.net:8888", path: "/echo")!, protocols: ["chat", "superchat"])
    
    var socket = WebSocket(url: NSURL(scheme: "ws", host: "192.168.0.105:8888", path: "/sensing")!, protocols: ["chat", "superchat"])
    
    @IBOutlet weak var startbutton: UIButton!

    
    //var socket = WebSocket(url: NSURL(scheme: "ws", host: "localhost:8080", path: "/")!, protocols: ["chat", "superchat"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socket.delegate = self
        println("imalive")
        let appD = UIApplication.sharedApplication().delegate as AppDelegate
        
        self.startbutton.titleLabel?.text = appD.status

       // socket.connect()
    }
    
    // MARK: Websocket Delegate Methods.
    
    func websocketDidConnect(ws: WebSocket) {
        
        println("websocket: \(ws) (Headers: \(ws.headers)) (Description: \(ws.description)) is connected")
    }
    
    func websocketDidDisconnect(ws: WebSocket, error: NSError?) {
        if let e = error {
            println("websocket is disconnected: \(e.localizedDescription)")
        }
    }
    
    func websocketDidReceiveMessage(ws: WebSocket, text: String) {
        println("Received text: \(text)")
    }
    
    func websocketDidReceiveData(ws: WebSocket, data: NSData) {
        println("Received data: \(data.length)")
    }
    
    // MARK: Write Text Action
    
    @IBAction func writeText(sender: UIBarButtonItem) {
        socket.writeString("Hallo Alex")
        
    }
    
    // MARK: Disconnect Action
    
    
    @IBAction func disconnect(sender: UIBarButtonItem) {
        if socket.isConnected {
            sender.title = "Connect"
            socket.disconnect()
        } else {
            sender.title = "Disconnect"
            socket.connect()
        }
    }
    
}

