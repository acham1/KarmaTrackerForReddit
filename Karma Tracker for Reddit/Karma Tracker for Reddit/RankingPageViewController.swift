//
//  RankingViewController.swift
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/21/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

import UIKit

/// Page view controller for two bar chart pages, showing top subreddits for comments and posts, respectively
class RankingPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    // array of bar view controllers this page view controller manages
    let barViewControllers = [
        RankingPageViewController.getBarViewController(sourceType: .comments),
        RankingPageViewController.getBarViewController(sourceType: .posts)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if let postsPage = barViewControllers.first {
            setViewControllers([postsPage], direction: .forward, animated: true, completion: nil)
        }
    }
    
    /// get the bar view controller from storyboard
    /// - Parameter sourceType: karma-contributing entity that the view presents (e.g. posts or comments)
    /// - Returns: RankingBarViewController from storyboard
    private static func getBarViewController(sourceType: KarmaSource) -> RankingBarViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(sourceType)Ranking") as! RankingBarViewController
        viewController.sourceType = sourceType
        return viewController
    }

    /// if currently on the first page, then the second is on the right
    /// - Parameter: pageViewController: page view controller
    /// - Parameter: current page
    /// - Returns: UIViewController that comes after the current one
    @available(iOS 5.0, *)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if barViewControllers.index(of: viewController as! RankingBarViewController) == 0 {
            return barViewControllers[1]
        }
        return nil
    }

    /// if currently on the second page, then the first is to the left
    /// - Parameter pageViewController: page view controller
    /// - Parameter viewControllerBefore: current page
    /// - Returns: UIViewController that comes before the current one
    @available(iOS 5.0, *)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if barViewControllers.index(of: viewController as! RankingBarViewController) == 1 {
            return barViewControllers[0]
        }
        return nil
    }

    /// number of pages
    /// - Parameter for: pageViewController whose count of pages is returned
    /// - Returns: number of pages
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 2
    }
    
    /// set first page as initial page for hte pageViewController
    /// - Parameter for: pageViewController whose first page is specified here
    /// - Returns: index of first page
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = barViewControllers.index(of: firstViewController as! RankingBarViewController) else {
                return 0
        }
        return firstViewControllerIndex
    }
    
}
