//
//  RegisterViewController.swift
//  TrackYourFriends
//
//  Created by Yichao Zhao on 5/11/2015.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

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
    
    
}
