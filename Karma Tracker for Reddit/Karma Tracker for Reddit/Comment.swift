//
//  Comment.swift
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/15/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

import Foundation

// A reddit comment
class Comment: AccountElement {
    let score: Int
    let unixTime: Int
    let subreddit: String
    
    /// Constructor sets values for all properties
    /// - Parameter score: net score of comment
    /// - Parameter unixTime: unix timestamp of comment creation
    /// - Parameter subreddit: subreddit enclosing comment
    init(score: Int, unixTime: Int, subreddit: String) {
        self.score = score
        self.unixTime = unixTime
        self.subreddit = subreddit
    }
}
