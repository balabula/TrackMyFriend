/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse
import FBSDKLoginKit
import FBSDKCoreKit

class ViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    
    
    
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnPwd: UIButton!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var pwdView: UIView!
    @IBOutlet weak var userView: UIView!
    
    
    @IBOutlet weak var imgVisiable: UIImageView!
    @IBOutlet weak var imgDelete: UIImageView!
    @IBOutlet weak var txtPwd: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    
    
    @IBOutlet weak var btnFBLogin: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        test()
        initUI()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    private func initUI(){
        
        
        self.btnLogin.layer.cornerRadius = 2
        self.btnLogin.layer.borderWidth = 1
        self.btnLogin.layer.borderColor = UIColor.orangeColor().CGColor

        self.btnFBLogin.delegate = self
        
        self.btnRegister.layer.cornerRadius = 2
        self.btnRegister.layer.borderWidth = 1
        self.btnRegister.layer.backgroundColor = UIColor.orangeColor().CGColor
        self.btnRegister.layer.borderColor = UIColor.orangeColor().CGColor
        
        
        self.pwdView.layer.cornerRadius = 2
        self.pwdView.layer.borderWidth = 1
        self.pwdView.layer.borderColor = UIColor.blackColor().CGColor
        
        self.userView.layer.cornerRadius = 2
        self.userView.layer.borderWidth = 1
        self.userView.layer.borderColor = UIColor.blackColor().CGColor
        
        self.txtPwd.secureTextEntry = true
        
        self.txtUserName.delegate = self
        self.txtUserName.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        
        self.imgDelete.userInteractionEnabled = true
        self.imgDelete.hidden = true
        
        
        self.imgVisiable.userInteractionEnabled = true
        
    }
    
    
    // MARK: UI Event
    func textFieldDidChange(textField: UITextField) {
        print("begin Editing")
        self.imgDelete.hidden = textField.text! == ""
    }
    
    @IBAction func visiableButtonDidClick(sender: AnyObject) {
        self.txtPwd.secureTextEntry = !self.txtPwd.secureTextEntry
    }
    
    @IBAction func clearButtonDidClick(sender: AnyObject) {
        self.txtUserName.text = ""
        self.imgDelete.hidden = hidesBottomBarWhenPushed
    }
    

    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("logout.")
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if ((error) != nil)
        {
            //handle error
        } else {

            print("result = \(result)")
            //  returnUserData()
        }
    }
    
    func returnUserData()
    {
        
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,interested_in,gender,birthday,email,age_range,name,picture.width(480).height(480)"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let id : NSString = result.valueForKey("id") as! String
                print("User ID is: \(id)")
                //etc...
            }
        })
    }
}
