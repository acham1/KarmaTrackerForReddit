//
//  SharedData.swift
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/15/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

import Foundation

class SharedData {
    
    private var comments: [Comment]?
    private var submissions: [Submission]?
    private var username: String?
    
    var numComments: Int {
        get {
            return comments == nil ? 0 : comments!.count
        }
    }
    
    var numSubmitted: Int {
        get {
            return submissions == nil ? 0 : submissions!.count
        }
    }
    
    private init() {}
    
    static let shared = SharedData()
    
    func add(comment: Comment) {
        if comments == nil {
            comments = [Comment]()
        }
        comments!.append(comment)
        print(comment.subreddit)
    }
    
    func add(submission: Submission) {
        if submissions == nil {
            submissions = [Submission]()
        }
        submissions!.append(submission)
        print(submission.subreddit)
    }
    
    /// empty comments and submissions arrays
    func clearAll() {
        username = nil
        comments = nil
        submissions = nil
    }
    
    func commit() {
        
    }
}
