//
//  NoteDetailViewTableViewController.swift
//  SimpleTest
//
//  Created by Developer on 20.02.15.
//  Copyright (c) 2015 vluxe. All rights reserved.
//

import Foundation
import UIKit
import Starscream

class NodeListDetailViewTableViewController: UITableViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    
    
    @IBOutlet weak var temp: UILabel!
    
    @IBOutlet weak var linearhumid: UILabel!
    
    @IBOutlet weak var node: UILabel!
    
    @IBOutlet weak var lightPar: UILabel!
    
    @IBOutlet weak var lightTsr: UILabel!
    
    @IBOutlet weak var zustand: UILabel!
      let appD = UIApplication.sharedApplication().delegate as AppDelegate

    
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("update"), userInfo: nil, repeats: true)

       
    }
    
    
   
    func update(){
        
        var node:SingleNodeObject = SingleNodeObject()
        node = self.appD.ListOfNodesObjects[self.appD.selectedIndexPath.row] as SingleNodeObject
        
        /*
        self.node.text = node.NodeName
        self.temp.text = node.Temperature
        self.linearhumid.text = node.LinearHumid
        self.lightPar.text = node.LightPar
        self.lightTsr.text = node.LightTsr
        */
        
        
        //self.node.text = appD.datasetNode
        self.node.text = node.NodeName
        self.temp.text = appD.datasettemp
        self.linearhumid.text = appD.datasetlinearhumid
        self.lightPar.text = appD.lightpar
        self.lightTsr.text = appD.lighttsr

        
        //println("WERT:\(self.temp.text)")
        //println("WERTAPPD:\(appD.datasetNode)")

    }
    
    
    
}