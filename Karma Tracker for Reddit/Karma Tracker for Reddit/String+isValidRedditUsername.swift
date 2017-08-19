//
//  String+isValidRedditUsername.swift
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/17/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

extension String {
    
    func isValidRedditUsername() -> Bool {
        return self.range(of: AppConstants.RegexString.Username, options: [.regularExpression]) != nil
    }
    
}
