//
//  ForgotPasswordHelper.swift
//  AWSUserPoolsSwift3
//
//  Created by Matthew Pileggi on 11/1/16.
//  Copyright © 2016 Matthew Pileggi. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

class ForgotPasswordHelper {
    
    let viewController: UIViewController
    let completion: (Result)->Void
    var user: AWSCognitoIdentityUser?
    
    enum Result {
        case reset
        case error
    }
    
    init(viewController: UIViewController, completion: @escaping (Result)->Void) {
        self.viewController = viewController
        self.completion = completion
    }
    
    func promptForUsername(){
  
        let alertController = UIAlertController(title: "Login Demo", message: "Enter username below")
        
        alertController.addCustomTextField()
        
        alertController.addAction(withText: "Verify", isPreferred: true){ _ in
            let username = alertController.textFields![0].text ?? ""
            self.user = AppDelegate.instance.pool?.getUser(username)
            self.user!.forgotPassword().continue({ task in
                
                if task.error != nil {
                    self.presentErrorPrompt(message: task.error?.getAWSError().message ?? "An error occurred")
                } else {
                    self.promptForVerificationCode()
                }
                return nil
            })
        }
        alertController.addDismissAction()
        
        viewController.presentOnMain(viewController: alertController)
        
    }
    
    private func presentErrorPrompt(message: String){
        let alertController = UIAlertController(title: "Login Demo", message: message)
        alertController.addDismissAction()
        viewController.presentOnMain(viewController: alertController)
    }
    
    private static let defaultVerificationMessage = "We've sent a verification code to the email on file.  Please enter it and a new password below"
    
    func promptForVerificationCode(message: String = defaultVerificationMessage){
        
        let alertController = UIAlertController(title: "Login Demo", message: message)
        
        alertController.addCustomTextField(withPlaceHolder: "Verification code")
        alertController.addCustomTextField(withPlaceHolder: "New password", isSecure: true)
            
        alertController.addAction(withText: "Reset", isPreferred: true) { _ in
            
            self.user?.confirmForgotPassword(alertController.textFields![0].text!, password: alertController.textFields![1].text!).continue({ task in
                if task.error != nil {
                    let errorMessage = task.error!.getAWSError().message
                    self.promptForVerificationCode(message: errorMessage)
                } else {
                    self.showSuccessMessage()
                }
                return nil
            })
        }
        alertController.addDismissAction(text: "Cancel")
        
        viewController.presentOnMain(viewController: alertController)
    }
//    
//    private static let defaultNewPasswordMessage = "Enter new password below"
//    
//    func promptForNewPassword(message: String = defaultNewPasswordMessage){
//        
//        let alertController = UIAlertController(title: "Login Demo", message: message)
//        alertController.addTextField()
//        alertController.addAction(withText: "Reset") { _ in
//            self.user?.changePassword("test1234", proposedPassword: alertController.textFields![0].text!).continue({ task in
//                if task.error != nil {
//                    self.promptForNewPassword(message: task.error!.getAWSError().message)
//                }  else {
//                    self.showSuccessMessage()
//                }
//                
//                return nil
//            })
//        }
//        
//        viewController.presentOnMain(viewController: alertController)
//    }
    
    func showSuccessMessage(){
        let alertController = UIAlertController(title: "Login Demo", message: "Password reset!")
        alertController.addDismissAction(text: "Go to Login")
        viewController.presentOnMain(viewController: alertController)
    }
}
