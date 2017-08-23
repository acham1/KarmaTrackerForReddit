//
//  UserSelectionViewController.swift
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/10/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

import UIKit

class UserSelectionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var trackButton: UIButton! // user input submission button
    @IBOutlet weak var usernameInput: UITextField! // input text field for username
    @IBOutlet weak var warningLabel: UILabel! // label that appears if invalid name is entered

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameInput.delegate = self
        
        // close keyboard when tapped outside
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.endEditing))
        view.addGestureRecognizer(tapRecognizer)
        
        warningLabel.isHidden = true
        
        trackButton.layer.borderColor = UIColor.black.cgColor
        trackButton.layer.cornerRadius = trackButton.frame.height/2
        trackButton.layer.borderWidth = 1
        
        print("Checking UserDefaults for last search, with key 'lastSearch'")
        if let lastSearch = UserDefaults.standard.object(forKey: "lastSearch") as? String {
            print("\tInitializing name field to last search (\(lastSearch))")
            usernameInput.text = lastSearch
        } else {
            print("\tNone found")
        }
    }
    
    /// hide the keyboard
    func endEditing() {
        print("Tapped User Selection view")
        if (usernameInput.isFirstResponder) {
            usernameInput.resignFirstResponder()
            print("\tName field resigning first responder")
        }
    }
    
    /// segue to the loading view if the current username in text field is valid
    @IBAction func submitUsername(_ sender: Any) {
        print("Tapped submission button")
        usernameInput.resignFirstResponder()
        usernameInput.text = usernameInput.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        // username cannot be empty
        guard let username = usernameInput.text, username.isValidRedditUsername() else {
            print("\tShowing invalid name message")
            warningLabel.isHidden = false
            return
        }
        
        warningLabel.isHidden = true
        UserDefaults.standard.set(username, forKey: "lastSearch")
        print("\tPerforming segue to loading view")
        performSegue(withIdentifier: "showLoading", sender: username)
    }
    
    /// check validity of text field contents if user closes keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Pressed keyboard return button")
        if (usernameInput.text?.isEmpty)! {
            return false
        }
        usernameInput.text = usernameInput.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if let username = usernameInput.text {
            if username.range(of: AppConstants.RegexString.Username, options: [.regularExpression]) != nil {
                warningLabel.isHidden = true
            }
        }
        print("\tName field resigning first responder")
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
            
        case "showSplash":
            // Do nothing
            return
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

    /// return to this view controller from another higher in the stack
    @IBAction func unwind(from segue: UIStoryboardSegue) {
        // Do nothing
    }

}
