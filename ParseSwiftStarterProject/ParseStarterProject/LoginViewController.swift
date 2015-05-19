//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let user = PFUser()
//        user.username = "my name"
//        user.password = "my pass"
//        user.email = "email@example.com"
//        
//        // other fields can be set if you want to save more information
//        user["phone"] = "650-555-0000"
//        user.delete()
//        user.signUpInBackgroundWithBlock(completionBlock)
    }

    var completionBlock = {
        (success:Bool, error: NSError?) -> Void in
            if error == nil {
                // Hooray! Let them use the app now.
            } else {
                // Examine the error object and inform the user.
            }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindByCancelButton(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindByRegisterButton(segue: UIStoryboardSegue) {
        
    }
}

