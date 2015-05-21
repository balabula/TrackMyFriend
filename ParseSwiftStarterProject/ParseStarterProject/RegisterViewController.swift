//
//  RegisterViewController.swift
//  TrackYourFriends
//
//  Created by Yichao Zhao on 19/05/2015.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtPwdRpt: UITextField!
    @IBOutlet weak var txtPwd: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
   
    // TODO: Internet Detection
    override func viewDidLoad() {
        super.viewDidLoad()

        txtPwd.secureTextEntry = true
        txtPwdRpt.secureTextEntry = true
    
        txtPwd.delegate = self
        txtUsername.delegate = self
        txtPwdRpt.delegate = self
        txtEmail.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(txtPwd.text != txtPwdRpt.text){
            var alert = UIAlertView(title: "Please Check", message: "Password Not Matches", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        
        if(txtEmail.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""){
            var alert = UIAlertView(title: "Please Check", message: "Email address is empty", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        
        if(txtUsername.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""){
            var alert = UIAlertView(title: "Please Check", message: "User name is empty", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        
        // Check the credential
        registerNewUser(self.txtEmail.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()), password: self.txtPwd.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()), username: self.txtUsername.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
    }


    @IBAction func didClickRegisterButton(sender: AnyObject) {
        
        if(txtPwd.text != txtPwdRpt.text){
            var alert = UIAlertView(title: "Please Check", message: "Password Not Matches", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        
        if(txtEmail.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""){
            var alert = UIAlertView(title: "Please Check", message: "Email address is empty", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        
        if(txtUsername.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""){
            var alert = UIAlertView(title: "Please Check", message: "User name is empty", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        
        registerNewUser(self.txtEmail.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()), password: self.txtPwd.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()), username: self.txtUsername.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
    }
//
//        // Check the credential
//
//    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        
        // Checking
        self.view.endEditing(true)
        return true;
    }
    
    func registerNewUser(email: String, password: String, username: String){
       
        var user = PFUser()
        user.email = email
        user.password = password
        user.username = username
        user.signUpInBackgroundWithBlock(completionBlock)

    }
    
    lazy var completionBlock: (Bool, NSError?)-> Void = {
        [unowned self] (success:Bool, error: NSError?) -> Void in

        if error == nil {
            var alert = UIAlertView(title: "Congradulations", message: "\(self.txtEmail.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) has been registered", delegate: nil, cancelButtonTitle: "OK")

            alert.show()
           
            // Popping Back the parent View - Call the Segue
            self.performSegueWithIdentifier("exitSegue", sender: self)

        } else {
            println(error!.code)
            if(error!.code == 203){
                var alert = UIAlertView(title: "Notice", message: "Email has already been registered", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                println("Email has already been registered")
            }else if(error!.code == 125){
                var alert = UIAlertView(title: "Notice", message: "Invalid Email Address", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                println("Invalid Email Address")
            }
            // Examine the error object and inform the user.
        }
    }
}
