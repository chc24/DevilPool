//
//  AppDelegate.swift
//  DevilPool
//
//  Created by Administrator on 7/16/15.
//  Copyright (c) 2015 oncloudcal.com. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseUI


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var parseLoginHelper: ParseLoginHelper!
    
    override init() {
        super.init()
        
        parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
            // Initialize the ParseLoginHelper with a callback
            println("after callback")
            if let error = error {
                // 1
                
                //ADD ERROR HANDLING
                
                println("Erorr is being handled")
            } else if let user = user {
                // if login was successful, display the TabBarController
                // 2
                print("log in successful!")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewControllerWithIdentifier("Verify") as! UIViewController
                // 3
                self.window?.rootViewController!.presentViewController(viewController, animated:true, completion:nil)
            }
        }
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //DevilPool App ID
        println("setting app id")
        Parse.setApplicationId("gtHkCYwo0dz39D4IHCvXP2Qla01l8uXSQ3OtzXMP", clientKey: "HOdrbc5lUHERw0hKd7B6BW2kA4PkkLYq1s3XO3r0")
        
        //PFUser.logInWithUsername("test", password: "test")

        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        let user = PFUser.currentUser()
        let startViewController: UIViewController;
        
        if (user != nil) {
            
            //User already logged in
            println("we have a user")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            startViewController = storyboard.instantiateViewControllerWithIdentifier("HomeView") as! UITabBarController
            
        } else {
            println("No current user")
            
            let loginViewController = PFLogInViewController()
            
//            var loginLogoTitle = UILabel()
//            loginLogoTitle.text = "DevilPool"
//            loginViewController.logInView!.logo = loginLogoTitle
            
            loginViewController.fields =  .Facebook
            loginViewController.delegate = parseLoginHelper
            
            startViewController = loginViewController
            
            
            
            //No Current, user, direct to FB login View
            println("no current user asdfas")
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            startViewController = storyboard.instantiateViewControllerWithIdentifier("FacebookLogin") as! UIViewController
            
        }
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = startViewController;
        self.window?.makeKeyAndVisible()
        
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

