//
//  AccountElement.swift
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/21/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

import Foundation

// A class representing one entity that contributes Karma points (e.g. comment or post)
protocol AccountElement {
    var score: Int {get}        // net score of element
    var unixTime: Int {get}     // creation timestamp
    var subreddit: String {get} // name of context subreddit

}
