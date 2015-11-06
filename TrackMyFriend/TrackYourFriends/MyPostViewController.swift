//
//  MyPostViewController.swift
//  TrackYourFriends
//
//  Created by Yichao Zhao on 19/05/2015.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import CoreLocation
import Parse

// TODO: Add GPS Enable Detection
class MyPostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtPost: UITextView!
    @IBOutlet weak var btnPost: UIButton!
    
    private var manager: OneShotLocationManager?
    private var currentUser: PFUser?
    private var location: CLLocationCoordinate2D?
    var posts = [PFObject]()
    var completionFlag = false
    //    var hasWifi: Bool = true
    
    private var spinnerHelper: SpinnerHelper?
    //    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.txtPost.delegate = self
        //        var network: InternetStatusDetector = InternetStatusDetector.sharedInstance
        //        network.startMonitoring(statusBlock: statusClosure)
        
        // Location Manager
        self.manager = OneShotLocationManager()
        self.currentUser = PFUser.currentUser()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        self.txtPost.layer.borderWidth = 1.0
        self.txtPost.layer.borderColor = UIColor.grayColor().CGColor
        
        self.spinnerHelper = SpinnerHelper(parentViewController: self)
        // Retrieving My Post Record
        
        if (self.tabBarController as! TabBarViewController).hasInternet{
            retrieveMyPostRecords()
        }
        
        //        // Ask for Authorisation from the User.
        //        self.locationManager.requestAlwaysAuthorization()
        //
        //        // For use in foreground
        //        self.locationManager.requestWhenInUseAuthorization()
        //
        //        println("load Location page")
        //        if CLLocationManager.locationServicesEnabled() {
        //
        //            locationManager.delegate = self
        //            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        //            locationManager.startUpdatingLocation()
        //        } else {
        //            println("Disabled")
        //        }
        
        
    }
    
    func retrieveMyPostRecords(){

        if(self.tableView != nil){
                   completionFlag = false
            self.spinnerHelper!.showModalIndicatorView()
            var query = PFQuery(className: "Post", predicate: NSPredicate(format: "user = %@", self.currentUser!))
            query.findObjectsInBackgroundWithBlock(completeRetrivingObjectsClosure)
        }
        
    }
    
    lazy var completeRetrivingObjectsClosure: ([AnyObject]?, NSError?) -> Void = {
        [unowned self](objs: [AnyObject]?, err: NSError?) -> Void in
        
        println("retrieve Post = \(objs)")
        if(err == nil){
            for obj in objs! {
                self.posts.append(obj as! PFObject)
            }
        }else{
            // TODO: Add alert
            var alert = UIAlertView(title: "Notice", message: "Please check internet connection", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            
        }
        println("post = \(self.posts)")
        
        // Refresh Table
        self.spinnerHelper!.removeIndicatorControllerFromView()
                self.completionFlag = true
        self.tableView.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        println("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completionFlag ? self.posts.count : 0
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        

        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        cell.textLabel!.text = self.posts[indexPath.row].valueForKey("content") as?  String
        return cell
        
    }
    
    @IBAction func didClickPostButton(sender: AnyObject) {
        
        //        println("hasWifi = \(self.hasWifi)")
        getCurrentLocation()
    }
    
    lazy var retrieveLocationClosure: (CLLocation?, NSError?) -> Void = {
        
        [unowned self] (location: CLLocation?, error: NSError?) in
        // fetch location or an error
        if let loc = location {
            self.location = loc.coordinate
            
            // Save the point
            var point = self.savePoint()
            self.savePost(point)
            
            self.tableView.reloadData()
            
            // Clear the text
            self.txtPost.text = ""
            
            println("location = \(loc.description), latitide = \(loc.coordinate.latitude)")
        } else if let err = error {
            println(err.localizedDescription)
            var alert = UIAlertView(title: "Notice", message: "Sorry, location service cannot be detected. Please turn on the GPS service to make a post", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
    }
    private func getCurrentLocation(){
        
        manager = OneShotLocationManager()
        manager!.fetchWithCompletion(retrieveLocationClosure)
        
    }
    
    private func savePoint() -> PFObject{
        
        
        self.spinnerHelper!.showModalIndicatorView()
        var point: PFObject = PFObject(className: "Point")
        point.setObject(self.location!.latitude, forKey: "latitude")
        point.setObject(self.location!.longitude, forKey: "longitude")
        var access = PFACL()
        access.setPublicReadAccess(true)
        access.setPublicWriteAccess(true)
        point.ACL = access
        
        point.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            self.spinnerHelper!.removeIndicatorControllerFromView()
            if(!success){
                var alert = UIAlertView(title: "Notice", message: "Please check internet connection", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
            
            
        }
        return point
        
    }
    
    private func savePost(point: PFObject){
        var post: PFObject = PFObject(className: "Post")
        post.setObject(self.txtPost.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()), forKey: "content")
        post.setObject(self.currentUser!, forKey: "user")
        post.setObject(point, forKey: "point")
        
        var access = PFACL()
        access.setPublicReadAccess(true)
        access.setPublicWriteAccess(true)
        post.ACL = access
        
        post.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if(success){
                var alert = UIAlertView(title: "Conguradulation", message: "You have successfully post a message", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                self.posts.append(post)
                self.tableView.reloadData()
            }
        }
        
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "segue"){
            var destViewController: PostDetailViewController = segue.destinationViewController as! PostDetailViewController
            destViewController.post = self.posts[self.tableView.indexPathForSelectedRow()!.row]
            
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {

        if(range.length == 0){
            if(text == "\n"){
                textView.resignFirstResponder()
                return false
            }
            
        }
        return true

    }
    

    //    lazy var statusClosure: (AFNetworkReachabilityStatus) -> Void = {
    //        [unowned self] in
    //        println("Detecting, 0 = \($0)")
    //        switch $0{
    //        case AFNetworkReachabilityStatus.NotReachable:
    //            var alert = UIAlertView(title: "Warning", message: "The internet is not avaliable", delegate: nil, cancelButtonTitle: "OK")
    //            alert.show()
    //            self.hasWifi = false
    //            // Disable UI
    //            self.enableTableByFlag()
    //        default:
    //            println("Friend table: has internet")
    //            // Enable UI
    //            self.hasWifi = false
    //            self.enableTableByFlag()
    //        }
    //
    //    }
    //
    //    func enableTableByFlag(){
    //        if(self.tableView != nil){
    //        println("tableview = \(self.tableView)")
    //        self.tableView.userInteractionEnabled = self.hasWifi
    //        }
    //    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        animateViewMoving(true, moveValue: 100)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        animateViewMoving(false, moveValue: 100)
    }
    
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        var movementDuration:NSTimeInterval = 0.3
        var movement:CGFloat = ( up ? -moveValue * 1.7 : moveValue * 1.7)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
}
