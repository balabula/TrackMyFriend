//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse
import CoreData

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!

    private var spinnerHelper: SpinnerHelper?
    private var context: NSManagedObjectContext?
    private var flag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        var monitor = InternetStatusDetector.sharedInstance
        monitor.startMonitoring(errorMessage: "The internet is not avaialble")
        
        if flag {
            // Clear cache
            clearCache()
            flag = false
        }
        
        println("Started")
        self.txtPassword.delegate = self
        self.txtUsername.delegate = self
        self.txtPassword.secureTextEntry = true
        
        self.spinnerHelper = SpinnerHelper(parentViewController: self)
        // Do any additional setup after loading the view, typically from a nib.
        //        let user = PFUser()
        //        user.username = "my name"
        //        user.password = "my pass"
        //        user.email = "happy38306@hotmail.com"
        //
        //        user.signUpInBackgroundWithBlock(completionBlock)
        //        user.email = "email@example.com"
        
        //
        //        // other fields can be set if you want to save more information
        //        user["phone"] = "650-555-0000"
        //        user.delete()
        //        user.signUpInBackgroundWithBlock(completionBlock)
        //        let user = PFUser(withoutDataWithObjectId: "Jhjng24HKF")
        //        println(user.email)
        //        var friend = PFObject(className: "Friends")
        //        friend.setObject(user, forKey: "user")
        //        friend.setObject(user, forKey: "friend")
        //        friend.saveInBackground()
        
    }
    
    var completionBlock = {
        (success:Bool, error: NSError?) -> Void in
        if error == nil {
            // Hooray! Let them use the app now.
        } else {
            println("Error Occurs")
            // Examine the error object and inform the user.
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindByCancelButton(segue: UIStoryboardSegue) {
        println("Press Cancel Button")
        clearUI()
    }
    
    @IBAction func unwindByRegisterButton(segue: UIStoryboardSegue) {
        println("Press Register Button")
        clearUI()
    }
    
    @IBAction func unwindByLoggingOut(segue: UIStoryboardSegue) {
        println("Press Logging Out button")
        PFUser.logOut()
        clearUI()
    }
    
    
    private func clearUI(){
        self.txtPassword.text = ""
        self.txtUsername.text = ""
    }
    
    @IBAction func didClickLoginButton(sender: AnyObject) {
        println("Click Login Button")
        self.spinnerHelper!.showModalIndicatorView()
        checkCredential(name: self.txtUsername.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()), pwd: self.txtPassword.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func checkCredential(#name: String, pwd: String) {
        
        PFUser.logInWithUsernameInBackground(name, password: pwd, block: loginCompletionBlock)
        
        
    }
    
    lazy var loginCompletionBlock: (PFUser?, NSError?) -> Void = {
        [unowned self] (user: PFUser?, error: NSError?) -> Void in
        println("user = \(user), error = \(error)")
        
        self.spinnerHelper!.removeIndicatorControllerFromView()
        
        
        if let err = error {
            if (err.code == 100){
                println("Time out")
                var alert = UIAlertView(title: "Notice", message: "Connection Time out, please try it later", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }else{
                println("Wrong Password")
                var alert = UIAlertView(title: "Notice", message: "The entered password is not correct", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
            
        } else {
            // Go to new Page
            self.performSegueWithIdentifier("segue", sender: self)
        }
        
    }
    
    private func clearCache(){
        var request: NSFetchRequest = NSFetchRequest(entityName: "FriendRequest")
        var results: NSArray = self.context!.executeFetchRequest(request, error: nil)!
        println("Clear cache: records = \(results.count)")
        for result in results {
            self.context?.deleteObject(result as! NSManagedObject)
        }
        
    }
    
    // Shift the keyboard
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewMoving(true, moveValue: 100)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 100)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        var movementDuration:NSTimeInterval = 0.3
        var movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
}

