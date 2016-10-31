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

        let email = AWSCognitoIdentityUserAttributeType()
        
        email?.name = "email"
        email?.value = emailField.text
        
        let attributes = [email!]

        AppDelegate.instance.pool!.signUp(username.text!, password: password.text!, userAttributes: attributes, validationData: nil).continue({ task in
            
            if task.error != nil {
                self.handleError(error: task.error!)
            } else {
                self.handleSuccess()
            }

            return nil
        })
    }
    
    @IBAction func cancel() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    

    //MARK: Helper
    
    fileprivate func handleError(error: Error){

        let AWSError = error.getAWSError()
        let errorAlert = UIAlertController(title: "Login Demo", message: AWSError.message)
        errorAlert.addDismissAction()
        
        DispatchQueue.main.async {
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    fileprivate func handleSuccess(){
        
        let successHelper = VerificationHelper(viewController: self, username: username.text!) {
            DispatchQueue.main.async {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
        successHelper.handleVerification()
    }
    
}
