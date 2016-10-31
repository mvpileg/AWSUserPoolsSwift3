//
//  AppDelegate.swift
//  AWSUserPoolsSwift3
//
//  Created by Matthew Pileggi on 10/25/16.
//  Copyright © 2016 Matthew Pileggi. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AWSCognitoIdentityInteractiveAuthenticationDelegate {

    var window: UIWindow?
    
    var pool: AWSCognitoIdentityUserPool?
    var user: AWSCognitoIdentityUser?

    var loginViewController: LoginViewController?
    
    static var instance: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .usEast1, identityPoolId: AWSConstants.COGNITO_POOL_ID)
        
        let serviceConfiguration = AWSServiceConfiguration(region: .usEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = serviceConfiguration
        
        let userPoolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: AWSConstants.APP_ID, clientSecret: nil, poolId: AWSConstants.USER_POOL_ID)
        AWSCognitoIdentityUserPool.registerCognitoIdentityUserPool(with: userPoolConfiguration, forKey: AWSConstants.USER_POOL_KEY)
        
        
        self.pool = AWSCognitoIdentityUserPool(forKey: AWSConstants.USER_POOL_KEY)
        self.pool!.delegate = self
        self.user = self.pool!.currentUser()
        
        return true
    }
    
    func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {
        setAndPresentLoginViewController()
        return loginViewController!
    }
    
    func setAndPresentLoginViewController() {
        
        if loginViewController == nil {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            loginViewController = (mainStoryboard.instantiateViewController(withIdentifier: "login") as! LoginViewController)
        }
        
        DispatchQueue.main.async {
            //presents the login from the current top view controller
            //when dismissing you will return to the top view controller
            let presentingViewController = UIApplication.shared.topViewController()
            presentingViewController.present(self.loginViewController!, animated: true, completion: nil)
        }
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

