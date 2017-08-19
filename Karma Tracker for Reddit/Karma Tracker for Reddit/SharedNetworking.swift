//
//  SharedNetworking.swift
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/12/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

import UIKit

class SharedNetworking {
    
    private init() {}
    
    static let shared = SharedNetworking()
    
    func getJSON(url: String, handledBy handler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let queryURL = URL(string: url)!
        let task = URLSession.shared.dataTask(with: queryURL, completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?) in
            handler(data, response, error)
        })
        task.resume()
    }
    
    static func networkingAlert(action: UIAlertAction) -> UIAlertController {
        let networkingAlert = UIAlertController(title: "Network Error", message: "Sorry! Please check device internet connection and try again later.", preferredStyle: .alert)
        networkingAlert.addAction(action)
        return networkingAlert
    }
}
