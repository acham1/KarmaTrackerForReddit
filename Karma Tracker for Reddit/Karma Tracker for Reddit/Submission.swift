//
//  Submission.swift
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/15/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

import Foundation

/// A reddit post
class Submission: AccountElement {
    let score: Int          // net score of post
    let unixTime: Int       // unix timestamp of post creation
    let subreddit: String   // subreddit enclosing post
    
    /// Constructor sets values for all properties
    /// - Parameter score: net score of post
    /// - Parameter unixTime: unix timestamp of post creation
    /// - Parameter subreddit: subreddit enclosing post
    init(score: Int, unixTime: Int, subreddit: String) {
        self.score = score
        self.unixTime = unixTime
        self.subreddit = subreddit
    }
}
