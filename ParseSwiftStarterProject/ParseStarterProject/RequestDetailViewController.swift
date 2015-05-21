//
//  RequestDetailViewController.swift
//  TrackYourFriends
//
//  Created by Yichao Zhao on 21/05/2015.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class RequestDetailViewController: UIViewController {

    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    var requestFriend: PFObject?
    var sourceFriend: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
