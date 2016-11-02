//
//  UIViewControllerExt.swift
//  AWSUserPoolsSwift3
//
//  Created by Matthew Pileggi on 11/1/16.
//  Copyright © 2016 Matthew Pileggi. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentOnMain(viewController: UIViewController){
        DispatchQueue.main.async {
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    func dismissSelfOnMain(){
        DispatchQueue.main.async {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
}
