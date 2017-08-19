//
//  InformationViewController.swift
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/17/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {

    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        versionLabel.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
