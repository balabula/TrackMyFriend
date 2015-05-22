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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //get the time, in this case the time an object was created.
        //format date
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MMMM HH:mm " //format style. Browse online to get a format that fits your needs.
        lblTime.text = dateFormatter.stringFromDate(post!.createdAt!)
        
        println("time = \(post!.createdAt)")
        
        lblPost.text = post!.valueForKey("content") as? String
        
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
        
        var args = (post!.valueForKey("point") as! PFObject).valueForKey("objectId") as! String
        var query = PFQuery(className: "Point", predicate: NSPredicate(format: "objectId = %@", args))
        
        return query.getFirstObjectInBackgroundWithBlock({ (point: PFObject?, err: NSError?) -> Void in
            
            if err == nil{
                var latitude: Double = point!.valueForKey("latitude") as! Double
                var longitude: Double = point!.valueForKey("longitude") as! Double
                self.lblLocation.text = "Longitude: \(longitude), Latitude: \(latitude)"
            }else{
                // TODO: Alert
            }
            
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
