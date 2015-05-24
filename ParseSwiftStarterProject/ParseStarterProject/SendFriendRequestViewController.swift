//
//  SendFriendRequestViewController.swift
//  TrackYourFriends
//
//  Created by Yichao Zhao on 21/05/2015.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import CoreData

class SendFriendRequestViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtMessage: UITextView!
    private var spinnerHelper: SpinnerHelper?
    
    var context: NSManagedObjectContext?
    var friendRequested: PFUser?
    var currentUser: PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        var monitor = InternetStatusDetector.sharedInstance
        monitor.startMonitoring(errorMessage: "The internet is not avaialble")
        
        spinnerHelper = SpinnerHelper(parentViewController: self)
        println("friendRequest = \(friendRequested)")
        // Do any additional setup after loading the view.
        self.currentUser = PFUser.currentUser()
        self.txtMessage.delegate = self
        
        // Update User Interface
        lblName.text = self.friendRequested?.username
        lblEmail.text = self.friendRequested?.email
        
        // Read from cache
        txtMessage.text = readFromCache()
        
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
  
    // TODO
    override func didMoveToParentViewController(parent: UIViewController?) {
        if(self.txtMessage != nil){
                    println("caching data: parent Controller = \(parent?.title)")
            // Add into Core Data with current user, destination user and message
            var entityDescription: NSEntityDescription = NSEntityDescription.entityForName("FriendRequest", inManagedObjectContext: self.context!)!
            var newEntity = NSManagedObject(entity: entityDescription, insertIntoManagedObjectContext: self.context)
            newEntity.setValue(self.currentUser!.objectId!, forKey: "userId")
                        newEntity.setValue(self.txtMessage.text, forKey: "content")
                        newEntity.setValue(self.friendRequested!.objectId!, forKey: "friendId")
            self.context?.save(nil)
            
        }

    }
    
    // TODO:
    private func readFromCache() -> String{
        var request = NSFetchRequest(entityName: "FriendRequest")
//        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "userId = %@ && friendId = %@", self.currentUser!.objectId!, self.friendRequested!.objectId!)
        
        var results: NSArray = self.context!.executeFetchRequest(request, error: nil)!
        
        if results.count > 0 {
            var result = results[0] as! NSManagedObject
            return result.valueForKey("content") as! String
        }
        return ""
    }
    

}
