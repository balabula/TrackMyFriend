//
//  FriendRequestViewController.swift
//  TrackYourFriends
//
//  Created by Yichao Zhao on 19/05/2015.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class FriendRequestViewController: UITableViewController {
    
    private var friendRequest: [PFObject] = [PFObject]()
    private var sourceFriend: [PFObject] = [PFObject]()
    private var currentUser: PFUser?
    private var counter = 0
    private var spinnerHelper: SpinnerHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var monitor = InternetStatusDetector.sharedInstance
        monitor.startMonitoring(errorMessage: "The internet is not avaialble")


        self.currentUser = PFUser.currentUser()
        self.spinnerHelper = SpinnerHelper(parentViewController: self)
        
        // Do any additional setup after loading the view..
        retrieveFriendRequest()
    }
    
    private func retrieveFriendRequest(){
        
        var query = PFQuery(className: "FriendRequest", predicate: NSPredicate(format: "destUser = %@ && checked = %@", currentUser!, false))
        
        self.spinnerHelper!.showModalIndicatorView()
        
        query.findObjectsInBackgroundWithBlock({ (objs:[AnyObject]?, error: NSError?) -> Void in
            
            self.spinnerHelper!.removeIndicatorControllerFromView()
            if(error != nil){
                println("error = \(error)")
            }else{
                println("objs = \(objs)")
                self.friendRequest = objs as! [PFObject]
                self.counter = self.friendRequest.count
                
                // Get the Source User Array
                for request in self.friendRequest {
                    var objId = (request.valueForKey("sourceUser") as! PFUser).objectId!
                    println("objectId = \(objId)")
                    var query1 = PFQuery(className: "_User", predicate: NSPredicate(format: "objectId = %@", objId))
                    query1.findObjectsInBackgroundWithBlock(self.completionRetrievingObject)
                    
                    //                    self.friendRequest.append(PFUser().objectForKey(objId) as! PFObject)
                }
                
                
            }
        })
        
        
    }
    
    lazy var completionRetrievingObject: ([AnyObject]?, NSError?) -> Void = {
        [unowned self] (objs:[AnyObject]?, error: NSError?) -> Void in
        self.spinnerHelper!.removeIndicatorControllerFromView()
        println("Retriving for objId")
        self.sourceFriend.append(objs![0] as! PFObject)
        
        self.counter -= 1
        
        if(self.counter == 0){
            
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        println("Row count = \(sourceFriend.count)")
        return sourceFriend.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        
        cell.textLabel?.text = (self.sourceFriend[indexPath.row].valueForKey("username") as? String)!
        //       println((self.friendRequest![indexPath.row].valueForKey("sourceUser") as! PFUser).username)
        //        cell.textLabel?.text = self.friendRequest[indexPath.row].valueForKey("username") as? String
        println("Data: Request = \(self.friendRequest), Source User = \(self.sourceFriend)")
        
        return cell
    }
    
    @IBAction func unwindByAcceptButton(segue: UIStoryboardSegue) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "segue"){
            var destViewController: RequestDetailViewController = segue.destinationViewController as! RequestDetailViewController
            destViewController.sourceFriend = self.sourceFriend[self.tableView.indexPathForSelectedRow()!.row]
            destViewController.requestFriend = self.friendRequest[self.tableView.indexPathForSelectedRow()!.row]
            
        }
    }
    
    
    
}
