//
//  LoadingViewController.swift
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/10/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

import UIKit

/// View controller to be presented during loading data from Reddit
class LoadingViewController: UIViewController {

    @IBOutlet weak var image: UIImageView! // background image for loading screen
    
    @IBOutlet weak var currentLoadingItem: UILabel! // live label that shows current loaded item
    var username: String?   // username of account
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show network activity indicator
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // set up loading display, center activity indicator at middle of logo's circle
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        activityIndicator.activityIndicatorViewStyle = .gray
        
        let viewCenter = self.view.center
        let activityCenterX = viewCenter.x * 1.48
        let activityCenterY = viewCenter.y * 0.94
        activityIndicator.center = CGPoint(x: activityCenterX, y: activityCenterY)
        
        self.view.addSubview(activityIndicator)
        
        SharedData.shared.clearAll()
        loadUserData()
    }
    
    /// load user data into SharedData
    func loadUserData() {
        let ifFinish = {
            self.recursiveGetSubmittedListing(paramAfter: nil,
                                         ifNetworkFail: self.respondToNetworkFail,
                                         ifDataFail: self.respondToDataFail,
                                         ifFinish: self.finishLoading)
        }
        recursiveGetCommentsListing(paramAfter: nil,
                                    ifNetworkFail: self.respondToNetworkFail,
                                    ifDataFail: self.respondToDataFail,
                                    ifFinish: ifFinish)
    }
    
    /// if received invalid Reddit data, show an alert that will segue back to user selection view
    private func respondToDataFail() {
        let action = UIAlertAction(title: "OK", style: .default, handler: self.loadingErrorHandler)
        let alert =  UIAlertController(title: "Data Error", message: "Sorry! Please check that a valid Reddit username was entered.", preferredStyle: .alert)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    /// show alert that will segue to user selection view, if network fails
    private func respondToNetworkFail() {
        let action = UIAlertAction(title: "OK", style: .default, handler: self.loadingErrorHandler)
        self.present(SharedNetworking.networkingAlert(action: action), animated: true)
    }
    
    /// segue to charts tab controller when finished loading
    private func finishLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.performSegue(withIdentifier: "showUserDetails", sender: self)
    }
    
    /// recursively continue to pull data from user's comments
    /// - Parameter paramAfter: previous Reddit JSON's 'after' key
    /// - Parameter ifNetworkFail: to be performed if network error encountered
    /// - Parameter ifDataFail: to be performed if data error encountered
    /// - Parameter ifFinish: to be performed when finished loading
    func recursiveGetCommentsListing(paramAfter: String?,
                            ifNetworkFail: @escaping () -> Void,
                            ifDataFail: @escaping () -> Void,
                            ifFinish: @escaping () -> Void) {
        // get target url
        var commentsURL = AppConstants.APIURL.Head + username! + AppConstants.APIURL.CommentsTail + "?limit=100"
        if let paramAfter = paramAfter {
            commentsURL.append("&after=\(paramAfter)")
        }
        
        SharedNetworking.shared.getJSON(url: commentsURL, handledBy: {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print(String(describing: error))
                return ifNetworkFail()
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                guard let jsonData = (json as? [String:Any])?["data"] as? [String:Any],
                    let children = jsonData["children"] as? [[String:Any]] else {
                    throw LoadingError.couldNotCastToDictionary
                }
                // process children data
                for comment in children {
                    guard let commentData = comment["data"] as? [String:Any] else {
                        throw LoadingError.couldNotCastToDictionary
                    }
                    
                    // create a comment and add to data
                    let score = commentData["score"] as! Int
                    let unixTime = commentData["created_utc"] as! Int
                    let subreddit = commentData["subreddit_name_prefixed"] as! String
                    SharedData.shared.add(comment: Comment(score: score, unixTime: unixTime, subreddit: subreddit))
                    DispatchQueue.main.sync {
                        self.currentLoadingItem.text = "\(score > 0 ? "+" : "")\(score): \(subreddit)"
                    }
                }
                if let after = jsonData["after"] as? String {
                    self.recursiveGetCommentsListing(paramAfter: after, ifNetworkFail: ifNetworkFail, ifDataFail: ifDataFail, ifFinish: ifFinish)
                } else {
                    return ifFinish()
                }
            } catch {
                ifDataFail()
            }
        })
    }
    
    /// recursively continue to pull data from user's posts
    /// - Parameter paramAfter: previous Reddit JSON's 'after' key
    /// - Parameter ifNetworkFail: to be performed if network error encountered
    /// - Parameter ifDataFail: to be performed if data error encountered
    /// - Parameter ifFinish: to be performed when finished loading
    func recursiveGetSubmittedListing(paramAfter: String?,
                                     ifNetworkFail: @escaping () -> Void,
                                     ifDataFail: @escaping () -> Void,
                                     ifFinish: @escaping () -> Void) {
        // get target url
        var submittedURL = AppConstants.APIURL.Head + username! + AppConstants.APIURL.SubmittedTail + "?limit=100"
        if let paramAfter = paramAfter {
            submittedURL.append("&after=\(paramAfter)")
        }
        
        SharedNetworking.shared.getJSON(url: submittedURL, handledBy: {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print(String(describing: error))
                return ifNetworkFail()
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                guard let jsonData = (json as? [String:Any])?["data"] as? [String:Any],
                    let children = jsonData["children"] as? [[String:Any]] else {
                        throw LoadingError.couldNotCastToDictionary
                }
                // process children data
                for submitted in children {
                    guard let submittedData = submitted["data"] as? [String:Any] else {
                        throw LoadingError.couldNotCastToDictionary
                    }
                    
                    // create a submission and add to data
                    let score = submittedData["score"] as! Int
                    let unixTime = submittedData["created_utc"] as! Int
                    let subreddit = submittedData["subreddit_name_prefixed"] as! String
                    SharedData.shared.add(submission: Submission(score: score, unixTime: unixTime, subreddit: subreddit))
                    DispatchQueue.main.sync {
                        self.currentLoadingItem.text = "\(score > 0 ? "+" : "")\(score): \(subreddit)"
                    }
                }
                if let after = jsonData["after"] as? String {
                    self.recursiveGetSubmittedListing(paramAfter: after, ifNetworkFail: ifNetworkFail, ifDataFail: ifDataFail, ifFinish: ifFinish)
                } else {
                    return ifFinish()
                }
            } catch {
                ifDataFail()
            }
        })
    }

    /// handle error during loading by returning to user selection view
    /// - Parameter alert: the alert that is calling this action
    func loadingErrorHandler(alert: UIAlertAction) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        performSegue(withIdentifier: "failedLoading", sender: self)
    }
    
}
