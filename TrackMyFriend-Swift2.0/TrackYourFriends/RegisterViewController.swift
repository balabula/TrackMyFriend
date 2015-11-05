//
//  RegisterViewController.swift
//  TrackYourFriends
//
//  Created by Yichao Zhao on 5/11/2015.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UIViewController {
    
    
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPwd: UITextField!
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var btnRegister: UIButton!
    
    
    var spinnerHelper: SpinnerHelper?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        test()
        initUI()
        
        self.spinnerHelper = SpinnerHelper(parentViewController: self)
        
        let monitor = InternetStatusDetector.sharedInstance
        monitor.startMonitoring(errorMessage: "The internet is not avaialble")
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initUI(){
        self.txtEmail.layer.cornerRadius = 2
        self.txtEmail.layer.borderWidth = 1
        self.txtEmail.layer.borderColor = UIColor.blackColor().CGColor
        
        self.txtName.layer.cornerRadius = 2
        self.txtName.layer.borderWidth = 1
        self.txtName.layer.borderColor = UIColor.blackColor().CGColor
        
        self.txtPwd.layer.cornerRadius = 2
        self.txtPwd.layer.borderWidth = 1
        self.txtPwd.layer.borderColor = UIColor.blackColor().CGColor
        
        self.btnRegister.layer.cornerRadius = 2
        self.btnRegister.layer.borderWidth = 1
        self.btnRegister.layer.borderColor = UIColor.orangeColor().CGColor
        self.btnRegister.layer.backgroundColor = UIColor.orangeColor().CGColor
        
    }
    
    
    
    @IBAction func btnRegisterDidClick(sender: AnyObject) {
        
        
        if(txtEmail.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""){
            let alert = UIAlertView(title: "Please Check", message: "Email address is empty", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        
        if(txtName.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""){
            let alert = UIAlertView(title: "Please Check", message: "User name is empty", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        
        
        if(txtPwd.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""){
            let alert = UIAlertView(title: "Please Check", message: "Password is empty", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        
         registerNewUser(self.txtEmail.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()), password: self.txtPwd.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()), username: self.txtName.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
        
    }
    
    private func registerNewUser(email: String, password: String, username: String){
        
        let user = PFUser()
        user.email = email
        user.password = password
        user.username = username
        user.signUpInBackgroundWithBlock(completionBlock)
        
        // Spinner
        self.spinnerHelper!.showModalIndicatorView()
    }
    
    lazy var completionBlock: (Bool, NSError?)-> Void = {
        [unowned self] (success:Bool, error: NSError?) -> Void in
        
        self.spinnerHelper!.removeIndicatorControllerFromView()
        if error == nil {
            var alert = UIAlertView(title: "Congradulations", message: "\(self.txtEmail.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) has been successfully registered", delegate: nil, cancelButtonTitle: "OK")
            
            alert.show()
            
            print("Redirecting")
            // Popping Back the parent View - Call the Segue
            self.performSegueWithIdentifier("exitSegue", sender: self)
            
        } else {
            print(error!.code)
            if(error!.code == 203){
                var alert = UIAlertView(title: "Notice", message: "Email has already been registered", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                print("Email has already been registered")
            }else if(error!.code == 125){
                var alert = UIAlertView(title: "Notice", message: "Invalid Email Address", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                print("Invalid Email Address")
            }else if(error!.code == 202){
                var alert = UIAlertView(title: "Notice", message: "Usename has already been taken", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                print("User name has already been registered")
            }else if (error!.code == 100){
                print("Time out")
                var alert = UIAlertView(title: "Notice", message: "Connection Time out, please try it later", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
            // Examine the error object and inform the user.
        }
    }
}
