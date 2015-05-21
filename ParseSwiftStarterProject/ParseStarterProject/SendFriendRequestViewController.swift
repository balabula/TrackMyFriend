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
    
    var friendRequested: PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        println("friendRequest = \(friendRequested)")
        // Do any additional setup after loading the view.
        
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
        
        
        var friendRequest = PFObject(className: "FriendRequest")
        println("Message Saved: \(message)")
        
        // If contains the request already
        if(isRequestExists()){
        }else{
            
            friendRequest.setObject(message, forKey: "message")
            friendRequest.setObject(PFUser.currentUser()!, forKey: "sourceUser")
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
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    private func isRequestExists() -> Bool{
        return false
    }
}
