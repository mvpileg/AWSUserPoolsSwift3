//
//  ErrorExt.swift
//  AWSUserPoolsSwift3
//
//  Created by Matthew Pileggi on 10/31/16.
//  Copyright © 2016 Matthew Pileggi. All rights reserved.
//

import Foundation

struct AWSError {
    let type: String
    let message: String
}

extension Error {
    
    func getAWSError()->AWSError{
        let error = self as NSError
        
        let type = error.userInfo["__type"] as? String ?? "Unknown error type"
        let message = error.userInfo["message"] as? String ?? "Empty error message"
        
        return AWSError(type: type, message: message)
    }
  
}
