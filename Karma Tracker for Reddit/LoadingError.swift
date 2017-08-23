//
//  LoadingError.swift
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/18/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

import Foundation

/// Error that can be encounterd during parsing JSON from Reddit
enum LoadingError: Error {
    case couldNotCastToDictionary
}
