//
//  FirstViewController.swift
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/10/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var userSelection: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(SharedData.shared.numComments)
        print(SharedData.shared.numSubmitted)
        
        userSelection.target = self
        userSelection.action = #selector(returnToSelection)
        
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "BacK", style: .done, target: self, action: #selector(returnToSelection))
    }
    
    func returnToSelection() {
        print("pressed")
        performSegue(withIdentifier: "reselect", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

