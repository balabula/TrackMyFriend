//
//  InternetStatusDetector.swift
//  TrackYourFriends
//
//  Created by Yichao Zhao on 5/11/2015.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class InternetStatusDetector {

    
    static let sharedInstance = InternetStatusDetector()
    
    private var manager = AFHTTPRequestOperationManager()
    private var network: AFNetworkReachabilityManager
    
    private init(){
        manager = AFHTTPRequestOperationManager()
        network = manager.reachabilityManager
    }
    
    
    // monitoring the internet and show a dialog with the input string when the internet is unavailable
    func startMonitoring(errorMessage errorMessage: String){
        // Check the ReacherAbility
        self.network.setReachabilityStatusChangeBlock(
            {
                print("Detecting, 0 = \($0)")
                switch $0{
                case AFNetworkReachabilityStatus.NotReachable:
                    var alert = UIAlertView(title: "Warning", message: errorMessage, delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                default:
                    print("has internet")
                }
            }
        )
        network.startMonitoring()
        
        
    }
    
    func startMonitoring(statusBlock statusBlock: (AFNetworkReachabilityStatus) -> Void){
        self.network.setReachabilityStatusChangeBlock(statusBlock)
        self.network.startMonitoring()
    }
}
