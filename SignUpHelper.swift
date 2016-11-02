//
//  SignUpHelper.swift
//  AWSUserPoolsSwift3
//
//  Created by Matthew Pileggi on 11/1/16.
//  Copyright © 2016 Matthew Pileggi. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

class SignUpHelper {
    
    let viewController: UIViewController
    let username: String
    let password: String
    let completion: (Result)->Void
    let attributes: [AWSCognitoIdentityUserAttributeType]
    
    enum Result {
        case registered
        case unregistered
    }
    
    init(viewController: UIViewController, username: String, password: String, attributes: [AWSCognitoIdentityUserAttributeType], completion: @escaping (Result)->Void) {
        self.viewController = viewController
        self.username = username
        self.password = password
        self.attributes = attributes
        self.completion = completion
    }
    
    func signUp(){
        
        AppDelegate.instance.pool!.signUp(username, password: password, userAttributes: attributes, validationData: nil).continue({ task in
            
            if task.error != nil {
                self.handleError(error: task.error!)
            } else {
                self.completion(.registered)
            }
            
            return nil
        })
    }
    
    fileprivate func handleError(error: Error){
        
        let AWSError = error.getAWSError()
        let errorAlert = UIAlertController(title: "Login Demo", message: AWSError.message)
        
        errorAlert.addAction(withText: "Dismiss") { _ in
            self.completion(.unregistered)
        }
        
        viewController.presentOnMain(viewController: errorAlert)
    }
}
