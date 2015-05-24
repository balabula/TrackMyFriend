//
//  MapViewController.swift
//  TrackYourFriends
//
//  Created by Yichao Zhao on 19/05/2015.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import MapKit
import Parse

class MapViewController: UIViewController {
    
    var counter = 0
    var selectFriend: PFUser?

    private var spinnerHelper: SpinnerHelper?
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var monitor = InternetStatusDetector.sharedInstance
        monitor.startMonitoring(errorMessage: "The internet is not avaialble")

        
        self.spinnerHelper = SpinnerHelper(parentViewController: self)
        retrievePost()
        
        //        self.mapView.addAnnotation(annotation)
        
    }
    
    private func retrievePost(){
        self.spinnerHelper!.showModalIndicatorView()
        var query = PFQuery(className: "Post", predicate: NSPredicate(format: "user = %@", self.selectFriend!))
        query.findObjectsInBackgroundWithBlock(completeRetrivingObjectsClosure)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getGeoPointFromPost(post: PFObject){
        
        
    }
    
    private func showPostOnMap(count: Int, post: PFObject){
        
        var args = (post.valueForKey("point") as! PFObject).valueForKey("objectId") as! String
        var query = PFQuery(className: "Point", predicate: NSPredicate(format: "objectId = %@", args))
        
        return query.getFirstObjectInBackgroundWithBlock({ (point: PFObject?, err: NSError?) -> Void in
            
            if err == nil{
                
                // Show on the map
                let location = CLLocationCoordinate2D(
                    latitude: point!.valueForKey("latitude") as! Double,
                    longitude: point!.valueForKey("longitude") as! Double
                )
                
                if(count == 1){
                    // Map setting up
                    let span = MKCoordinateSpanMake(0.05, 0.05)
                    let region = MKCoordinateRegion(center: location, span: span)
                    self.mapView.setRegion(region, animated: true)
                    self.mapView.setCenterCoordinate(location, animated: true)
                }
                
                
                // Add Annotation
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd/MMMM HH:mm " //format style. Browse online to get a format
                
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = dateFormatter.stringFromDate(post.createdAt!)
                annotation.subtitle = post.valueForKey("content") as! String
                self.mapView.addAnnotation(annotation)
                
            }else{
                // TODO: Alert
                var alert = UIAlertView(title: "Notice", message: "Please check internet connection", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
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
    
    
    lazy var completeRetrivingObjectsClosure: ([AnyObject]?, NSError?) -> Void = {
        [unowned self](objs: [AnyObject]?, err: NSError?) -> Void in
        
        self.spinnerHelper!.removeIndicatorControllerFromView()
        println("retrieve Post = \(objs)")
        if(err == nil){
            if objs!.count == 0{
                var alert = UIAlertView(title: "Notice", message: "Your friend hasn't posted anything yet.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }else{
                for obj in objs! {
                    self.counter += 1
                    self.showPostOnMap(self.counter, post: obj as! PFObject)
                }
            }
            
        }else{
            // TODO: Add alert
            var alert = UIAlertView(title: "Notice", message: "Please check internet connection", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
    }
    
   
    
}
