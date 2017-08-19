//
//  LoadingViewController.swift
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/10/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    var username: String?
    
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
    
    private func respondToDataFail() {
        let action = UIAlertAction(title: "OK", style: .default, handler: self.loadingErrorHandler)
        let alert =  UIAlertController(title: "Data Error", message: "Sorry! Please check that a valid Reddit username was entered.", preferredStyle: .alert)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    private func respondToNetworkFail() {
        let action = UIAlertAction(title: "OK", style: .default, handler: self.loadingErrorHandler)
        self.present(SharedNetworking.networkingAlert(action: action), animated: true)
    }
    
    private func finishLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.performSegue(withIdentifier: "showUserDetails", sender: self)
    }
    
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
                    let score = commentData["score"] as! Int
                    let unixTime = commentData["created_utc"] as! Int
                    let subreddit = commentData["subreddit_name_prefixed"] as! String
                    SharedData.shared.add(comment: Comment(score: score, unixTime: unixTime, subreddit: subreddit))
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
                    let score = submittedData["score"] as! Int
                    let unixTime = submittedData["created_utc"] as! Int
                    let subreddit = submittedData["subreddit_name_prefixed"] as! String
                    SharedData.shared.add(submission: Submission(score: score, unixTime: unixTime, subreddit: subreddit))
                    print("submitted: \(subreddit)")
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

    func loadingErrorHandler(alert: UIAlertAction) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        performSegue(withIdentifier: "failedLoading", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
