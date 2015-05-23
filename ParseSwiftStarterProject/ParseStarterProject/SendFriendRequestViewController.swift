//
//  SendFriendRequestViewController.swift
//  TrackYourFriends
//
//  Created by Yichao Zhao on 21/05/2015.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class SendFriendRequestViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtMessage: UITextView!
    private var spinnerHelper: SpinnerHelper?
    
    var friendRequested: PFUser?
    var currentUser: PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinnerHelper = SpinnerHelper(parentViewController: self)
        println("friendRequest = \(friendRequested)")
        // Do any additional setup after loading the view.
        self.currentUser = PFUser.currentUser()
        self.txtMessage.delegate = self
        
        // Update User Interface
        lblName.text = self.friendRequested?.username
        lblEmail.text = self.friendRequested?.email
        
        self.txtMessage.layer.borderWidth = 1.0
        self.txtMessage.layer.borderColor = UIColor.grayColor().CGColor
    }
    
    @IBAction func didClickSendButton(sender: AnyObject) {
        
        println("Send Message Clicked")
        sendMessage(message: txtMessage.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()), to: self.friendRequested!)

    }
    
    private func sendMessage(#message: String, to: PFUser){
        
        self.spinnerHelper!.showModalIndicatorView()

        var friendRequest = PFObject(className: "FriendRequest")
        println("Message Saved: \(message)")
        
        // If contains the request already
        PFQuery(className: "FriendRequest", predicate: NSPredicate(format: "destUser = %@ && sourceUser = %@ && checked = %@", friendRequested!, self.currentUser!, false)).findObjectsInBackgroundWithBlock { (objs: [AnyObject]?, err: NSError?) -> Void in
            
            // TODO: Dismiss Spinner
            
            self.spinnerHelper!.removeIndicatorControllerFromView()
            if(err == nil){
                if(objs?.count == 0){

                    var access: PFACL  = PFACL()
                    access.setPublicReadAccess(true)
                    access.setPublicWriteAccess(true)

                    friendRequest.ACL = access
                    friendRequest.setObject(message, forKey: "message")
                    friendRequest.setObject(self.currentUser!, forKey: "sourceUser")
                    friendRequest.setObject(self.friendRequested!, forKey: "destUser")
                    friendRequest.setObject(false, forKey: "checked")

                    friendRequest.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                        
                        if(!success){
                            // Error Occurs
                            println("error = \(error)")
                            var alert = UIAlertView(title: "Notice", message: "Fail to send request. Please check internet connection", delegate: nil, cancelButtonTitle: "OK")
                            alert.show()
                            
                        } else {
                            // Popping up the UI
                            dispatch_async(dispatch_get_main_queue()) {
                                () -> Void in
                                self.navigationController?.popToRootViewControllerAnimated(true)
                            }
                            
                        }
                    }
                } else {
                
                    // Popping Up the UI
                    dispatch_async(dispatch_get_main_queue()) {
                        () -> Void in
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    }
                }
            }
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        self.txtMessage.endEditing(true)
        
        return true
    }


}
