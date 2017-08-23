//
//  SharedData.swift
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/15/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

import Foundation

class SharedData {
    
    private var comments: [Comment]?    // array of comments collected so far
    private var submissions: [Submission]? // array of submissions collected so far
    private var username: String? // username for the account
    
    // return number of comments so far
    var numComments: Int {
        get {
            return comments == nil ? 0 : comments!.count
        }
    }
    
    // return number of submissions so far
    var numSubmitted: Int {
        get {
            return submissions == nil ? 0 : submissions!.count
        }
    }
    
    private init() {} // private initializer for singleton instance
    static let shared = SharedData() // singleton instance handle
    
    /// add a new comment to array
    /// - Parameter comment: comment to add
    func add(comment: Comment) {
        if comments == nil {
            comments = [Comment]()
        }
        comments!.append(comment)
    }
    
    /// add a new submission to array
    /// - Parameter submission: submission to add
    func add(submission: Submission) {
        if submissions == nil {
            submissions = [Submission]()
        }
        submissions!.append(submission)
    }
    
    /// empty comments and submissions arrays
    /// set all loaded data to nil
    func clearAll() {
        username = nil
        comments = nil
        submissions = nil
    }

    /// return the comments array
    /// - Returns: array of comments collected so far
    func getComments() -> [Comment]? {
        return comments
    }
    
    /// return the submissions array
    /// - Returns: array of submissions collected so far
    func getSubmissions() -> [Submission]? {
        return submissions
    }
}
