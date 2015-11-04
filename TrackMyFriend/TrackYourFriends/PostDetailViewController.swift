//
//  PostDetailViewController.swift
//  TrackYourFriends
//
//  Created by Yichao Zhao on 22/05/2015.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class PostDetailViewController: UIViewController {
    
    var post: PFObject?
    @IBOutlet weak var lblPost: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    private var spinnerHelper: SpinnerHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var monitor = InternetStatusDetector.sharedInstance
        monitor.startMonitoring(errorMessage: "The internet is not avaialble")

        
        //get the time, in this case the time an object was created.
        //format date
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MMMM HH:mm " //format style. Browse online to get a format that fits your needs.
        lblTime.text = dateFormatter.stringFromDate(post!.createdAt!)
        
        println("time = \(post!.createdAt)")
        
        lblPost.text = post!.valueForKey("content") as? String
        
        self.spinnerHelper = SpinnerHelper(parentViewController: self)
        
        getGeoPointFromPost()
        //        var latitude: Double = point.valueForKey("latitude") as! Double
        //        var longitude: Double = point.valueForKey("longitude") as! Double
        //        lblTime.text = "Longitude: \(longitude), Latitude: \(latitude)"
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getGeoPointFromPost(){
        self.spinnerHelper!.showModalIndicatorView()
        var args = (post!.valueForKey("point") as! PFObject).valueForKey("objectId") as! String
        var query = PFQuery(className: "Point", predicate: NSPredicate(format: "objectId = %@", args))
        
        return query.getFirstObjectInBackgroundWithBlock({ (point: PFObject?, err: NSError?) -> Void in
            
            if err == nil{
                var latitude: Double = point!.valueForKey("latitude") as! Double
                var longitude: Double = point!.valueForKey("longitude") as! Double
                self.lblLocation.text = "(\(longitude),  \(latitude))"
            }else{
                // TODO: Alert
                var alert = UIAlertView(title: "Notice", message: "Please check internet connection", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
            self.spinnerHelper!.removeIndicatorControllerFromView()
            
        })
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
  
}
