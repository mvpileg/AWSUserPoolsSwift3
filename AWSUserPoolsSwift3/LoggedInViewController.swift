//
//  LoggedInViewController.swift
//  AWSUserPoolsSwift3
//
//  Created by Matthew Pileggi on 10/25/16.
//  Copyright © 2016 Matthew Pileggi. All rights reserved.
//

import UIKit

class LoggedInViewController: UIViewController {

    
    //MARK: Outlets
    
    @IBOutlet weak var getInfoButton: UIButton!

    
    //MARK: Actions
    
    @IBAction func getInfo() {
        loadUser()
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        if let user = AppDelegate.instance.user {
            user.signOut()
            loadUser()
        }
    }

    
    //MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUIElements(hidden: true)
        
        loadUser()
        
        self.navigationItem.hidesBackButton = true
    }
    
    
    //MARK: Helper

    fileprivate func loadUser(){
        
        if let user = AppDelegate.instance.user {
            user.getDetails().continue({ task in
                DispatchQueue.main.async {
                    self.setUIElements(hidden: false)
                }
            })
        }
    }
    
    fileprivate func setUIElements(hidden: Bool){
        self.navigationController?.isNavigationBarHidden = hidden
        getInfoButton.isHidden = hidden
    }

}
