//
//  SignUpViewController.swift
//  AWSUserPoolsSwift3
//
//  Created by Matthew Pileggi on 10/25/16.
//  Copyright © 2016 Matthew Pileggi. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

class SignUpViewController: UIViewController {

    
    //MARK: Outlets
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    
    //MARK: Actions
    
    @IBAction func finish() {
        signUp()
    }
    
    @IBAction func cancel() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Helper
    
    fileprivate func signUp() {
        
        let emailAttribute = AWSCognitoIdentityUserAttributeType()
        emailAttribute!.name = "email"
        emailAttribute!.value = emailField.text
        
        let signUpHelper = SignUpHelper(viewController: self, username: username.text!, password: password.text!, attributes: [emailAttribute!]) { result in
           
            switch result {
                
            case .registered: self.verify()
            case .unregistered: break //do nothing, let user try again
                
            }
            
        }
        signUpHelper.signUp()
    }
    
    fileprivate func verify() {
        
        let verificationHelper = VerificationHelper(viewController: self, username: username.text!) { result in
            
            if result == .verified {
                
                let successAlert = UIAlertController(title: "Login Demo", message: "You've successfully registered")
                
                successAlert.addAction(withText: "Go to login") { _ in
                    self.dismissSelfOnMain()
                }
                
                self.presentOnMain(viewController: successAlert)
            } else {
                self.dismissSelfOnMain()
            }
        }
        
        verificationHelper.verify()
    }
 
    
}
