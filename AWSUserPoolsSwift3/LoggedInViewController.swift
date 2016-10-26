//
//  LoggedInViewController.swift
//  AWSUserPoolsSwift3
//
//  Created by Matthew Pileggi on 10/25/16.
//  Copyright © 2016 Matthew Pileggi. All rights reserved.
//

import UIKit

class LoggedInViewController: UIViewController {


    //MARK: Actions
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    //MARK: Stock
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
