//
//  UIApplicationExt.swift
//  AWSUserPoolsSwift3
//
//  Created by Matthew Pileggi on 10/27/16.
//  Copyright © 2016 Matthew Pileggi. All rights reserved.
//

import UIKit

extension UIApplication {
    
    //used to find the current view controller
    func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController)->UIViewController{
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base!
    }
    
}
