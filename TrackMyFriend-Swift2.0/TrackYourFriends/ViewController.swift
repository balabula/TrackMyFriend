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


class ViewController: UIViewController, UITextFieldDelegate {
    
    private var spinnerHelper: SpinnerHelper?
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        test()
        initUI()
        
        let monitor = InternetStatusDetector.sharedInstance
        monitor.startMonitoring(errorMessage: "The internet is not avaialble")
        self.spinnerHelper = SpinnerHelper(parentViewController: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    private func initUI(){
        
        
        self.btnLogin.layer.cornerRadius = 2
        self.btnLogin.layer.borderWidth = 1
        self.btnLogin.layer.borderColor = UIColor.orangeColor().CGColor
        
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
    

    @IBAction func btnLoginDidClick(sender: AnyObject) {
        self.spinnerHelper!.showModalIndicatorView()
        checkCredential(name: self.txtUserName.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()), pwd: self.txtPwd!.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
    }
    
    @IBAction func clearButtonDidClick(sender: AnyObject) {
        self.txtUserName.text = ""
        self.imgDelete.hidden = hidesBottomBarWhenPushed
    }
    
    @IBAction func unwindByBackButton(segue: UIStoryboardSegue) {
        
        clearUI()
    }
    
    // Shift the keyboard
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewMoving(true, moveValue: 100)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 100)
    }
    
    // MARK: UI function
    
    private func animateViewMoving (up:Bool, moveValue :CGFloat){
        var movementDuration:NSTimeInterval = 0.3
        var movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
    private func clearUI(){
        if self.txtPwd.text != nil {
            self.txtPwd.text = ""
        }
        
        if self.txtUserName.text != nil{
            self.txtUserName.text = ""
        }

    }
    
    // MARK: Parse Function
    func checkCredential(name name: String, pwd: String) {
        
        PFUser.logInWithUsernameInBackground(name, password: pwd, block: loginCompletionBlock)
    }
    
    lazy var loginCompletionBlock: (PFUser?, NSError?) -> Void = {
        [unowned self] (user: PFUser?, error: NSError?) -> Void in
        print("user = \(user), error = \(error)")
        
        self.spinnerHelper!.removeIndicatorControllerFromView()
        
        
        if let err = error {
            if (err.code == 100){
                print("Time out")
                var alert = UIAlertView(title: "Notice", message: "Connection Time out, please try it later", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }else{
                print("Wrong Password")
                var alert = UIAlertView(title: "Notice", message: "The entered password is not correct", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
            
        } else {
            // Go to new Page
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }
        
    }
    
}

