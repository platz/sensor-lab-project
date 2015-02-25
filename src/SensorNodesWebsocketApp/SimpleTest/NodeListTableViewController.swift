//
//  NodeListTableViewController.swift
//  SimpleTest
//
//  Created by Developer on 19.02.15.
//  Copyright (c) 2015 vluxe. All rights reserved.
//

import Foundation
import UIKit
import Starscream

class NodeListTableViewController: UITableViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var noteTableView: UITableView!
    let appD = UIApplication.sharedApplication().delegate as AppDelegate
    //var myLib:NSMutableArray = NSMutableArray()
    
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
    }
    

    
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refresh:", name: "newnode", object: nil)
        
        var dummyview:UIView = UIView(frame:CGRectZero)
        self.noteTableView.tableFooterView = dummyview
        self.appD.ListOfNodesObjects.removeAllObjects()
        self.appD.ListOfNodes.removeAllObjects()

    }
    
    
    
    func refresh(notification: NSNotification){
        
        //self.myLib = appD.ListOfNodesObjects
        
        self.noteTableView.reloadData()
        
        
        if (appD.AlARMSET == true){
            self.navigationController?.navigationBar.backgroundColor = UIColor.redColor()
            self.navigationController?.title = "Intrusion Detected"  
        }
        
       // var indp:NSIndexPath = NSIndexPath(forRow: self.appD.ListOfNodes.count-1, inSection: 0)
       // self.noteTableView.reloadRowsAtIndexPaths(indp, withRowAnimation: UITableViewRowAnimation.Fade)
        
       // self.noteTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Left)
        
       

    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("nodecell") as UITableViewCell
        
        var node:SingleNodeObject = SingleNodeObject()
        node = self.appD.ListOfNodesObjects[indexPath.row] as SingleNodeObject
        
        cell.textLabel?.text = node.NodeName
        cell.detailTextLabel?.text = node.Alarm
        
        
     return cell
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.appD.selectedIndexPath = indexPath
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appD.ListOfNodesObjects.count //self.appD.ListOfNodes.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    

}
 