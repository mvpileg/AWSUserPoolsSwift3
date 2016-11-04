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
    @IBAction func forgotPassword() {
        handleForgotPassword()
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
            
            self.presentOnMain(viewController: alertController)
            
        } else {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //MARK: Unverified
    
    fileprivate func handleUnverifiedUser(){
        AppDelegate.instance.pool?.getUser(username.text!).resendConfirmationCode()
        
        let helper = VerificationHelper(viewController: self, username: username.text!) { result in
            if result == .verified {
                self.login()
            }//else do nothing
        }
        
        helper.verify(message: "\(username.text!) is unverified.  We've resent the verification code to your email on file.  Please enter it below.")
    }
    
    
    //MARK: Forgot Password
    
    fileprivate func handleForgotPassword(){
        
        let forgotPasswordHelper = ForgotPasswordHelper(viewController: self) { result in
        }
        forgotPasswordHelper.promptForUsername()
    }

    
}
