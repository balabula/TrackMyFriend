//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {


    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("Started")
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
    }
    
    @IBAction func unwindByRegisterButton(segue: UIStoryboardSegue) {
        println("Press Register Button")
    }
    @IBAction func didClickRegisterButton(sender: AnyObject) {
        println("Click New User Button")
    }
    @IBAction func didClickLoginButton(sender: AnyObject) {
        println("Click Login Button")
    }

}

