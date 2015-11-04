//
//  LoginView.swift
//  TrackYourFriends
//
//  Created by Yichao Zhao on 5/11/2015.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

// Configuration: 30 * 260
class LoginView: UIView {

    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var text: UITextField!
    
    // MARK: Initialization
   
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
  
    
    func setLoginView(imageLeft: String, imageRight: String, isPwd: Bool){
        self.leftImage.image = UIImage(named: imageLeft)
        self.rightImage.image = UIImage(named: imageRight)
    }

}
