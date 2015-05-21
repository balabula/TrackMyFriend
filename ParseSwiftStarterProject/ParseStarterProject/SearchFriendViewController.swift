//
//  SearchFriendViewController.swift
//  TrackYourFriends
//
//  Created by Yichao Zhao on 19/05/2015.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class SearchFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {
    
    
    private var currentUser: PFUser?
    private var friendFound: PFUser?
    
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        // Do any additional setup after loading the view.

        currentUser = PFUser.currentUser()
        println("Current user = \(currentUser)")
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
//        println("SearchBar Input = \(searchBar.text)")
//        searchBar.resignFirstResponder()
//    }
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//    }

   
    
    private func searchFriend(name: String){
        println("Search Friend")
        if(name != self.currentUser!.username){     // The current user is not searched
            var query = PFUser.queryWithPredicate(NSPredicate(format: "%K == %@", "username", name))
            
            // TODO: Check if already is your friends
            query?.getFirstObjectInBackgroundWithBlock(completionFetchUser)
        }
    }
    
    lazy var completionFetchUser: (PFObject?, NSError?) -> Void = {
       [unowned self] (user: PFObject?, error: NSError?) in
       
        if let err = error {
            println("error = \(error)")
        } else {
            println("User = \(user)")
            self.friendFound = user as? PFUser

            // Update Table View
            self.tableView.reloadData()
        }
        
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        println("SearchBar Input = \(searchBar.text)")
        searchFriend(searchBar.text)

    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.friendFound == nil) ? 0: 1
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        if (self.friendFound != nil){
            cell.textLabel!.text = self.friendFound?.username
        } else {
            cell.textLabel!.text = ""
        }

        return cell
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "requestFriendSegue"){
            var destViewController: SendFriendRequestViewController = segue.destinationViewController as! SendFriendRequestViewController
            destViewController.friendRequested = self.friendFound!
        }

    }
    
    
    @IBAction func unwindBySendButton(segue: UIStoryboardSegue) {
        
    }
}
