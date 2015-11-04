//
//  Friend.swift
//  TrackYourFriends
//
//  Created by Yichao Zhao on 20/05/2015.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse

class Friend: PFObject{
    
    var user: PFUser?
    var friend: PFUser?
    
    override func parseClassName: String { get }-> String{
    
    }
    
}
