//
//  LoginViewController.swift
//  AWSUserPoolsSwift3
//
//  Created by Matthew Pileggi on 10/25/16.
//  Copyright © 2016 Matthew Pileggi. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

class LoginViewController: UIViewController, AWSCognitoIdentityPasswordAuthentication {

    
    //MARK: Outlets
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!


    //MARK: Actions
    
    @IBAction func login() {
        let authDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: username.text ?? "", password: password.text ?? "")
        self.passwordAuthenticationCompletion!.trySetResult(authDetails)
    }

    @IBAction func signUp() {
        self.performSegue(withIdentifier: "sign up", sender: nil)
    }
    

    //MARK: AWSCognitoIdentityPasswordAuthentication

    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?
    
    func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
        self.passwordAuthenticationCompletion = passwordAuthenticationCompletionSource
    }
    
    func didCompleteStepWithError(_ error: Error) {
        //the following is necessary because somehow error is coming back nil even though it's not listed as an optional.  AWS will probably fix this before the beta ends
        let optionalError: Error?
        optionalError = error
        
        if optionalError != nil {
            
            let AWSError = optionalError!.getAWSError()
            
            if AWSError.type == "UserNotConfirmedException" {
                handleUnverifiedUser()
                return
            }
            
            let alertController = UIAlertController(title: "Error", message: AWSError.message, preferredStyle: .alert)
            alertController.addDismissAction()
            
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
            
        } else {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //MARK: Helper
    
    fileprivate func handleUnverifiedUser(){
        
        let helper = VerificationHelper(viewController: self, username: username.text!) {
            self.login()
        }
        AppDelegate.instance.pool?.getUser(username.text!).resendConfirmationCode()
        helper.handleVerification(message: "\(username.text!) is unverified.  We've resent the verification code to your email on file.  Please enter it below.")
    }

}
