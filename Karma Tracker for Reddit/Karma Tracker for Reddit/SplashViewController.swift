//
//  SplashViewController.swift
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/21/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var tapPrompt: UILabel! // label that tells user to tap to close splash screen

    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.closeSplash))
        self.view.addGestureRecognizer(gestureRecognizer)
        
        tapPrompt.layer.cornerRadius = tapPrompt.frame.height/2
        tapPrompt.layer.borderColor = UIColor.black.cgColor
        tapPrompt.layer.borderWidth = 1        
    }

    /// perform a segue away from splash to the user selection view
    func closeSplash() {
        print("Tapped splash view\n\tClosing splash view")
        performSegue(withIdentifier: "closeSplash", sender: self)
    }

}
