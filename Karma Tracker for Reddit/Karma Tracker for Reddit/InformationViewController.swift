//
//  InformationViewController.swift
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/17/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

import UIKit

/// View controller that shows App information and instructions
class InformationViewController: UIViewController {

    @IBOutlet weak var versionLabel: UILabel! // label that shows app version
    
    override func viewDidLoad() {
        super.viewDidLoad()
        versionLabel.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        print("Tapped information button\n\tShowing information view")
    }

}
