//
//  RequestDetailViewController.swift
//  TrackYourFriends
//
//  Created by Yichao Zhao on 21/05/2015.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

/* 
Rules:
    - Once friend requests are accepted, the friends are added mutually
    - Any deleting will cause the disappearance from both sides
*/
class RequestDetailViewController: UIViewController {

    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    private var spinnerHelper: SpinnerHelper?
    var requestFriend: PFObject?
    var sourceFriend: PFObject?
    var currentUser: PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.currentUser = PFUser.currentUser()!
        self.spinnerHelper = SpinnerHelper(parentViewController: self)
        
        println("requestFriend = \(requestFriend) sourceFriend = \(sourceFriend)")
        // Do any additional setup after loading the view.
//        self.r
        // Update UI
        self.lblUserName.text = sourceFriend?.valueForKey("username") as? String
        self.lblEmail.text = sourceFriend?.valueForKey("email") as? String
        self.lblMessage.text = requestFriend?.valueForKey("message") as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didClickAcceptButton(sender: AnyObject) {


        self.requestFriend!.setObject(true, forKey: "checked")
        self.requestFriend!.saveInBackground()
//        var obj : PFObject = PFQuery(className: "FriendRequest", predicate: NSPredicate(format: "sourceUser = %@ && destUser = %@", self.sourceFriend as! PFUser, PFUser.currentUser()!)).getFirstObject()!
//        // Refresh the flag
//        obj.setObject(true, forKey: "checked")
//        obj.saveInBackground()
        
        // Update Friends Table
        var access1: PFACL  = PFACL()
        access1.setPublicWriteAccess(true)
        access1.setPublicReadAccess(true)
       
        
        var friendRecord = PFObject(className: "Friends")
        friendRecord.setValue(sourceFriend!, forKey: "srcFriend")
        friendRecord.setValue(currentUser!, forKey: "destFriend")
        friendRecord.ACL = access1
        friendRecord.saveInBackground()

        var friendRecord2 = PFObject(className: "Friends")
        
        friendRecord2.setValue(sourceFriend!, forKey: "destFriend")
        friendRecord2.setValue(currentUser!, forKey: "srcFriend")
        friendRecord2.ACL = access1
        friendRecord2.saveInBackground()
        
        // Tell the user
        var alert = UIAlertView(title: "Notice", message: "You have accepted the friend request", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
