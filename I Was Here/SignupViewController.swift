//
//  SignupViewController.swift
//  iWasHere
//
//  Created by Ahmed Yakout on 8/11/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Constants
    
    let wallIdentifier = "signupToWall"
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    // MARK: - Actions
    
    @IBAction func signup(sender: UIButton?) {
        let emailField = email.text!
        let passwordField = password.text!
        
        FIRAuth.auth()?.createUserWithEmail(emailField, password: passwordField) { [weak self] (auth, error) in
            if error == nil {
                self?.addUserIntoDatabase(auth!)
                FIRAuth.auth()?.signInWithEmail(emailField, password: passwordField) {
                    (auth, error) -> Void in
                    if (error != nil) {
                        // print(error)
                        self?.showErrorView(error!)
                    } else {
                        self?.performSegueWithIdentifier((self?.wallIdentifier)!, sender: nil)
                    }
                }
            } else {
                // print(error)
                self?.showErrorView(error!)
            }
        }
    }
    
    
    // MARK: - Methods
    
    func addUserIntoDatabase(auth: FIRUser) {
        let ref = FIRDatabase.database().reference().child("users").child(auth.uid)
        let values = ["email": auth.email!, "uid": auth.uid]
        ref.updateChildValues(values) { (error,ref) in
            if error != nil {
                print(error)
            }
        }
    }
    
    
    // MARK: - UITextFieldDelegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == email {
            password.becomeFirstResponder()
        } else if textField == password {
            password.resignFirstResponder()
            self.signup(nil)
        }
        return true
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.email.delegate = self
        self.password.delegate = self
        email.becomeFirstResponder()
    }

}
