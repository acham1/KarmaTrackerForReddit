//
//  String+isValidRedditUsername.swift
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/17/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

/// extend String class to check if it is a valid reddit username or not
extension String {
    
    /// Check if string is a valid reddit username
    /// - Returns: true if string is a valid reddit username, false otherwise
    func isValidRedditUsername() -> Bool {
        return self.range(of: AppConstants.RegexString.Username, options: [.regularExpression]) != nil
    }
    
}
