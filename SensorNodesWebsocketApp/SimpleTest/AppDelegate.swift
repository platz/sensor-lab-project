//
//  AppDelegate.swift
//  SimpleTest
//
//  Created by Dalton Cherry on 8/12/14.
//  Copyright (c) 2014 vluxe. All rights reserved.
//

import UIKit
import Starscream


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WebSocketDelegate {
                            
    var window: UIWindow?
    var ListOfNodes :NSMutableArray = NSMutableArray()
    var ListOfNodesObjects :NSMutableArray = NSMutableArray()

    
    var datasetNode:NSString = ""
    var datasettemp:NSString = ""
    var datasetlinearhumid:NSString = ""
    var lightpar:NSString = ""
    var lighttsr:NSString = ""
    var alarm:NSString = ""
    var safe:NSString = ""
    var alert: UIAlertView = UIAlertView()
    var AlARMSET = false
    var status:NSString = ""
    var selectedIndexPath :NSIndexPath = NSIndexPath()

    
    let socket = WebSocket(url: NSURL(scheme: "ws", host: "141.23.71.194:8888", path: "/sensing")!, protocols: ["chat", "superchat"])


    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        // Override point for customization after application launch.
        self.letsDoTheSocketStuff()
        
        
        alert.delegate = self
        alert.title = "ALARM"
        alert.message = "\(self.datasetNode) has been intruded."
        alert.addButtonWithTitle("ok")
        
        
        return true
    }
    
    func letsDoTheSocketStuff(){
        socket.delegate = self
        socket.connect()
    }
    
    

    func applicationWillResignActive(application: UIApplication!) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication!) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication!) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication!) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication!) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /*
    #
    #
    # WEBSOCKET DELEGATES
    #
    #
    */
    func websocketDidConnect(ws: WebSocket) {
        
        println("websocket: \(ws) (Headers: \(ws.headers)) (Description: \(ws.description)) is connected")
    }
    
    func websocketDidDisconnect(ws: WebSocket, error: NSError?) {
        if let e = error {
            println("websocket_ is disconnected: \(e.localizedDescription)")
        }
    }
    
    func websocketDidReceiveMessage(ws: WebSocket, text: String) {
        //println("Received text: \(text)")
        //Echo Sensing: Node: 0x2, Temperature: 19.34, linear Humid: 26.7, LightPar: 4577.64, LightTsr: 844.85, Intrusion!

        
        
            var components:NSArray = text.componentsSeparatedByString(",")
           // println("MyComponents: \(components)")
        
        if text.rangeOfString("Echo Sensing:") != nil{
            println("exists")
                 }else{
            println(text)
            if(components.count > 2){
                var name:NSString = components[0] as NSString
                self.datasetNode = name.stringByReplacingOccurrencesOfString("Sensing: Node: ", withString: "")
                self.datasettemp = components[1] as NSString
                self.datasetlinearhumid = components[2] as NSString
                self.lightpar = components[3] as NSString
                self.lighttsr = components[4] as NSString
                self.alarm = components[5] as NSString
                
                
                var node:SingleNodeObject = SingleNodeObject()
                node.NodeName = self.datasetNode
                node.Temperature = self.datasettemp
                node.LinearHumid = self.datasetlinearhumid
                node.LightPar = self.lightpar
                node.LightTsr = self.lighttsr
                node.Alarm = self.alarm
                
                /*
                Check if we already know this node
                */
                
                if(self.ListOfNodes.containsObject(self.datasetNode) == false){
                    self.ListOfNodes.addObject(self.datasetNode)
                    self.ListOfNodesObjects.addObject(node)

                    NSNotificationCenter.defaultCenter().postNotificationName("newnode", object: nil)
                }
            }
            
        }
        
        
        if(self.AlARMSET == false){
            
            if text.rangeOfString("Intrusion!") != nil{
                println("exists")
                if(components.count > 2){
                    
                    self.datasetNode = components[0] as NSString
                    self.datasettemp = components[1] as NSString
                    self.datasetlinearhumid = components[2] as NSString
                    self.lightpar = components[3] as NSString
                    self.lighttsr = components[4] as NSString
                    self.alarm = components[5] as NSString
                    
                    alert.message = "\(self.datasetNode) has been intruded."
                    
                    alert.show()
                }
            }
            
        }else{
            println("kein alarmset")
        }
        
        
        
        
    }
    
    func websocketDidReceiveData(ws: WebSocket, data: NSData) {
        println("Received data: \(data.length)")
        
        
      }
    
    func writeText() {
        socket.writeString("Hallo ich bin eine Nachricht")
        
    }
    
    func disconnect() {
        if socket.isConnected {
            println("Okay... Connected.")
            self.status = "Disconnected"
            socket.disconnect()
        } else {
            println("Okay... Disconnected.")
            self.status = "Connection Established"
            socket.connect()
        }
    }
    

    
    


}

