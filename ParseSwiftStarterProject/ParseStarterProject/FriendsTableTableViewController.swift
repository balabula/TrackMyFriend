//
//  FriendsTableTableViewController.swift
//  TrackYourFriends
//
//  Created by Yichao Zhao on 19/05/2015.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class FriendsTableTableViewController: UITableViewController {
    
    var friends = [PFUser]()
    var currentUser: PFUser?
    
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = PFUser.currentUser()

        println("current user = \(currentUser)")
        retrieveFriendRecords()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    private func retrieveFriendRecords(){
        println("retrieve Records")
        var query = PFQuery(className: "Friends", predicate: NSPredicate(format: "destFriend = %@", self.currentUser!))
        println("srcFriend = \(self.currentUser!)")
        query.findObjectsInBackgroundWithBlock(completeFetchingFriendsList)
        
    }
    
    lazy var completeFetchingFriendsList: ([AnyObject]?, NSError?) -> Void = {
        [unowned self](objects: [AnyObject]?, error: NSError?) -> Void in

        println("CompeleFetching Friend List")
        if(error != nil){
            println("error = \(error)")
            var alert = UIAlertView(title: "Notice", message: "Cannot connect Internet Please check", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        } else {
            // Fetching Data
            self.counter = objects!.count
            println("obj = \(objects)")
            for obj in (objects! as! [PFObject]){
                
                // Fetch user data
                var userObjId = (obj.valueForKey("srcFriend") as! PFUser).objectId
                var query = PFQuery(className: "_User", predicate: NSPredicate(format: "objectId = %@", userObjId!))
                
                println("User id = \(userObjId)")
                query.getFirstObjectInBackgroundWithBlock({ (obj1:PFObject?, err: NSError?) -> Void in
                    
                    println("getting single record")
                    self.friends.append(obj1 as! PFUser)
                    self.counter -= 1
                    if(self.counter == 0){
                        self.tableView.reloadData()
                    }
                })
            }
        }
    
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return friends.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel?.text = friends[indexPath.row].username
        // Configure the cell...
        
        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    
    
    @IBAction func unwindByBackButton(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindBySaveButton(segue: UIStoryboardSegue) {
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "segue"){
            var destViewController: MapViewController = segue.destinationViewController as! MapViewController
            destViewController.selectFriend = self.friends[self.tableView.indexPathForSelectedRow()!.row]
        }
        
    }
    
}
