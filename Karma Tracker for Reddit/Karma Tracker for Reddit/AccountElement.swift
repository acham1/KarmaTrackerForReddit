//
//  AccountElement.swift
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/21/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

import Foundation

protocol AccountElement {
    var score: Int {get}
    var unixTime: Int {get}
    var subreddit: String {get}

}
