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

    var posts = [PFObject]()
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        var mapCentre = CLLocationCoordinate2D(latitude: 12, longitude: 12)
        var viewRegion = MKCoordinateRegionMakeWithDistance(mapCentre, 1000, 1000)
        self.mapView.setRegion(viewRegion, animated: true)
        
        var annotation = MKPointAnnotation()
        annotation.coordinate = viewRegion.center
        annotation.title = "Title"
        annotation.subtitle = "Subtitle"
        self.mapView.addAnnotation(annotation)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addPostToUser(post: PFObject){
        
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
