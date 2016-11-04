//
//  UIAlertControllerExt.swift
//  AWSUserPoolsSwift3
//
//  Created by Matthew Pileggi on 10/28/16.
//  Copyright © 2016 Matthew Pileggi. All rights reserved.
//

import UIKit

extension UIAlertController {

    convenience init(title: String, message: String) {
        self.init(title: title, message: message, preferredStyle: .alert)
    }

    func addAction(withText: String = "Done", withStyle: UIAlertActionStyle = .`default`, isPreferred: Bool = false, handler: ((UIAlertAction)->Void)?){
        let action = UIAlertAction(title: withText, style: withStyle, handler: handler)
        self.addAction(action)
        
        if isPreferred {
            self.preferredAction = action
        }
    }
    
    func addDismissAction(text: String = "Dismiss") {
        let dismissAction = UIAlertAction(title: text, style: .default, handler: nil)
        self.addAction(dismissAction)
    }
    
    func addCustomTextField(withPlaceHolder: String = "", isSecure: Bool = false) {
        self.addTextField { textField in
            textField.placeholder = withPlaceHolder
            textField.isSecureTextEntry = isSecure
        }
    }
    


}
