//
//  VerificationHelper.swift
//  AWSUserPoolsSwift3
//
//  Created by Matthew Pileggi on 10/31/16.
//  Copyright © 2016 Matthew Pileggi. All rights reserved.
//

import UIKit

class VerificationHelper {
    
    let viewController: UIViewController
    let username: String
    let completion: (()->Void)?
    
    init(viewController: UIViewController, username: String, completion: (()->Void)?) {
        self.viewController = viewController
        self.username = username
        self.completion = completion
    }
    
    func handleVerification(message: String = "You have successfully registered.  A verification code has been sent to your email.  Please enter it below"){
        let registerAlert = UIAlertController(title: "Login Demo", message: message)
        
        registerAlert.addTextField()
        
        registerAlert.addAction(withText: "Verify", isPreferred: true) { action in
            
            let verificationCode = registerAlert.textFields![0].text ?? "nil verification code"
            let user = AppDelegate.instance.pool?.getUser(self.username)
            
            user?.confirmSignUp(verificationCode).continue({task in
                
                if task.error != nil {
                    self.handleError(error: task.error!)
                } else {
                    self.handleSuccess()
                }
                
                return nil
            })
            
        }
        registerAlert.addAction(withText: "Later") { action in
            if self.completion != nil {
                self.completion!()
            }
        }

        DispatchQueue.main.async {
            self.viewController.present(registerAlert, animated: true, completion: nil)
        }
    }
    
    fileprivate func handleError(error: Error){
        let AWSError = error.getAWSError()
        self.handleVerification(message: AWSError.message)
    }
    
    fileprivate func handleSuccess(){
        let successAlert = UIAlertController(title: "Login Demo", message: "Verification successful")
        
        successAlert.addAction(withText: "Okay") { action in
            if self.completion != nil {
                self.completion!()
            }
        }
        
        DispatchQueue.main.async {
            self.viewController.present(successAlert,animated: true, completion: nil)
        }
    }
}

