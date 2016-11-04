//
//  VerificationHelper.swift
//  AWSUserPoolsSwift3
//
//  Created by Matthew Pileggi on 10/31/16.
//  Copyright © 2016 Matthew Pileggi. All rights reserved.
//

import UIKit


//VerificationHelper will display an alert on the input UIViewController asking user to input the verification code sent to their email.  A successful verification or a user dismissal exits  the helper, while an error will be displayed to the user in the prompt and they will be able to try again

class VerificationHelper {
    
    let viewController: UIViewController
    let username: String
    let completion: (Result)->Void
    
    enum Result {
        case verified
        case unverified
    }
    
    init(viewController: UIViewController, username: String, completion: @escaping (Result)->Void) {
        self.viewController = viewController
        self.username = username
        self.completion = completion
    }
    
    fileprivate static let defaultVerificationMessage = "You have successfully registered.  A verification code has been sent to your email.  Please enter it below"
    
    func verify(message: String = defaultVerificationMessage){
        let registerAlert = UIAlertController(title: "Login Demo", message: message)
        
        registerAlert.addCustomTextField()
        
        registerAlert.addAction(withText: "Verify", isPreferred: true) { action in
            
            let verificationCode = registerAlert.textFields![0].text ?? "nil verification code"
            let user = AppDelegate.instance.pool?.getUser(self.username)
            
            user?.confirmSignUp(verificationCode).continue({task in
                
                if task.error != nil {
                    self.handleError(error: task.error!)
                } else {
                    self.completion(.verified)
                }
                
                return nil
            })
            
        }
        
        registerAlert.addAction(withText: "Later") { _ in
            self.completion(.unverified)
        }

        self.viewController.presentOnMain(viewController: registerAlert)
    }
    
    fileprivate func handleError(error: Error){
        //simplest form for handling error.  Passing error message to alert and displaying
        let AWSError = error.getAWSError()
        self.verify(message: AWSError.message)
    }
}

