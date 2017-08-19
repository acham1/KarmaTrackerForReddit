//
//  Comment.swift
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/15/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

import Foundation

class Comment {
    let score: Int
    let unixTime: Int
    let subreddit: String
    
    init(score: Int, unixTime: Int, subreddit: String) {
        self.score = score
        self.unixTime = unixTime
        self.subreddit = subreddit
    }
}
