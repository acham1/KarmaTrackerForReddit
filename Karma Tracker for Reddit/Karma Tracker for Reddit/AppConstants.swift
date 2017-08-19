//
//  AppConstants.swift
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/12/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

import Foundation

struct AppConstants {
    struct RegexString {
        static let Username = "^[a-zA-Z0-9_-]+$"
    }
    
    struct APIURL {
        static let Head = "https://reddit.com/user/"
        static let SubmittedTail = "/submitted.json"
        static let CommentsTail = "/comments.json"
        
    }
}
