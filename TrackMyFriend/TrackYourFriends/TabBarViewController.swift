//
//  TabBarViewController.swift
//  TrackYourFriends
//
//  Created by Yichao Zhao on 24/05/2015.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    var hasInternet: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        var internetDetector:InternetStatusDetector = InternetStatusDetector.sharedInstance
        internetDetector.startMonitoring(statusBlock: statusClosure)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var statusClosure: (AFNetworkReachabilityStatus) -> Void = {
        [unowned self] in
        println("Detecting, 0 = \($0)")
        switch $0{
        case AFNetworkReachabilityStatus.NotReachable:
            var alert = UIAlertView(title: "Warning", message: "The internet is not avaliable", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            self.hasInternet = false
            // Disable UI
            
            
        default:
            println("Friend table: has internet")
            self.hasInternet = true
            // Enable UI
            
        }
        
        self.updateTableUIDisabilityByFlag()
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        if(item.title! == "Friends"){
            println("Friends Tabbed")
            //            println(self.viewControllers?.first)
            var friendController = (self.viewControllers?.first as! UINavigationController).viewControllers.first as! FriendsTableTableViewController
            if(self.hasInternet){
                if !friendController.compFlag {
                    friendController.friends.removeAll(keepCapacity: true)
                    friendController.retrieveFriendRecords()
                }
            }
        }else if(item.title! == "My Moment"){
            var myPostController = (self.viewControllers![1] as! UINavigationController).viewControllers.first as! MyPostViewController
            if !myPostController.completionFlag {
                if(self.hasInternet){
                    myPostController.posts.removeAll(keepCapacity: true)
                    myPostController.retrieveMyPostRecords()
                }
            }
        }
    }
    
    
    private func updateTableUIDisabilityByFlag(){
        
        //        var viewController : UIViewController = (self.selectedViewController as! UINavigationController).viewControllers.first as! UIViewController
        
        if let controller = (self.viewControllers![0] as! UINavigationController).viewControllers.first as? FriendsTableTableViewController {
            println("Updating Friend Table")
            if(controller.tableView != nil) {
                controller.tableView.userInteractionEnabled = self.hasInternet
            }
        }
        
        
        if let controller = (self.viewControllers![1] as! UINavigationController).viewControllers.first as? MyPostViewController {
            println("Updating PostTable")
            if(controller.tableView != nil) {
                controller.tableView.userInteractionEnabled = self.hasInternet
            }
            
        }
        
        if let controller = (self.viewControllers![2] as! UINavigationController).viewControllers.first as? MyAccountTableTableViewController {
            println("Updating Account Table")
            if(controller.tableView != nil) {
                controller.tableView.userInteractionEnabled = self.hasInternet
            }
        }
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    //    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
    //
    //
    //        tabBar.vi
    //        if(tabBarController.tabBar.selectedItem!.title! == "Friends"){
    //            println("friends tab bar selected, hasWIfi = \(self.hasInternet)")
    //
    //            self.friends.removeAll(keepCapacity: true)
    //            retrieveFriendRecords()
    //            self.enableTableByFlag()
    //        } else if(tabBarController.tabBar.selectedItem!.title! == "My Moment"){
    //
    //            var postViewController: MyPostViewController = ((viewController as! UINavigationController).viewControllers.first) as! MyPostViewController
    //            postViewController.enableTableByFlag()
    //
    //        }
    //    }
    
}
