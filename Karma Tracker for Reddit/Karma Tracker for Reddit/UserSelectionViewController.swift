//
//  UserSelectionViewController.swift
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/10/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

import UIKit

class UserSelectionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var trackButton: UIButton!
    
    @IBOutlet weak var usernameInput: UITextField!
    
    @IBOutlet weak var warningLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameInput.delegate = self
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.endEditing))
        view.addGestureRecognizer(tapRecognizer)
        
        warningLabel.isHidden = true
        
        trackButton.layer.borderColor = UIColor.black.cgColor
        trackButton.layer.cornerRadius = trackButton.frame.height/2
        trackButton.layer.borderWidth = 1
    }
    
    func endEditing() {
        if (usernameInput.canResignFirstResponder) {
            usernameInput.resignFirstResponder()
        }
    }
    
    @IBAction func submitUsername(_ sender: Any) {
        usernameInput.resignFirstResponder()
        usernameInput.text = usernameInput.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        // username cannot be empty
        guard let username = usernameInput.text, username.isValidRedditUsername() else {
            warningLabel.isHidden = false
            return
        }
        
        warningLabel.isHidden = true
        performSegue(withIdentifier: "showLoading", sender: username)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (usernameInput.text?.isEmpty)! {
            return false
        }
        usernameInput.text = usernameInput.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if let username = usernameInput.text {
            if username.range(of: AppConstants.RegexString.Username, options: [.regularExpression]) != nil {
                warningLabel.isHidden = true
            }
        }
        textField.resignFirstResponder()
        return true
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        switch(segue.identifier ?? "") {
        case "showLoading":
            guard let loadingViewController = segue.destination as? LoadingViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let username = sender as? String else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            loadingViewController.username = username
        
        case "showInformation":
            // Do nothing
            return
            
        case "reselect":
            // Do nothing
            return
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    @IBAction func unwind(from segue: UIStoryboardSegue) {
        // Do nothing
    }

}
