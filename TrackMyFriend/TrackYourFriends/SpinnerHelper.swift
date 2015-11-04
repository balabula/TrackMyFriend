//
//  SpinnerHelper.swift
//  TrackYourFriends
//
//  Created by Yichao Zhao on 23/05/2015.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation

class SpinnerHelper{
    
    var indicator: UIActivityIndicatorView
    var indicatorController: UIViewController
    var parentViewController: UIViewController
    
    init(parentViewController: UIViewController){
        self.parentViewController = parentViewController
        self.indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.indicatorController = UIViewController()
    }
    
    func removeIndicatorControllerFromView(){
        self.indicator.removeFromSuperview()
        self.indicatorController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func showModalIndicatorView(){
        self.indicatorController.view.addSubview(self.indicator)
        self.indicatorController.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        parentViewController.presentViewController(self.indicatorController, animated: false, completion: { () -> Void in
            self.indicator.center = CGPointMake(self.parentViewController.view.frame.width/2, self.parentViewController.view.frame.height/2)
            self.indicator.startAnimating()
        })
    }
}
