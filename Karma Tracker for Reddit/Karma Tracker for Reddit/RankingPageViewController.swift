//
//  RankingViewController.swift
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/21/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

import UIKit

class RankingPageViewController: UIPageViewController, UIPageViewControllerDataSource {

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
    
    private static func getBarViewController(sourceType: KarmaSource) -> RankingBarViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "\(sourceType)Ranking") as! RankingBarViewController
        viewController.sourceType = sourceType
        return viewController
    }

    
    @available(iOS 5.0, *)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if barViewControllers.index(of: viewController as! RankingBarViewController) == 0 {
            return barViewControllers[1]
        }
        return nil
    }

    @available(iOS 5.0, *)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if barViewControllers.index(of: viewController as! RankingBarViewController) == 1 {
            return barViewControllers[0]
        }
        return nil
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 2
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = barViewControllers.index(of: firstViewController as! RankingBarViewController) else {
                return 0
        }
        return firstViewControllerIndex
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
