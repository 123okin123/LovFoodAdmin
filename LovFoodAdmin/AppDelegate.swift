//
//  AppDelegate.swift
//  LovFoodAdmin
//
//  Created by Nikolai Kratz on 05.09.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import UIKit
import Firebase
import GeoFire


public let ref = FIRDatabase.database().reference()
public let storage = FIRStorage.storage()
public let storageRef = storage.reference()
public var geofireRef = ref.child("geoFire")
public var geoFire = GeoFire(firebaseRef: geofireRef)

public var lovFoodColor = UIColor(red: 237/255, green: 52/255, blue: 81/255, alpha: 1)
public var lovFoodSecondaryColor = UIColor(red: 249/255, green: 247/255, blue: 244/255, alpha: 1)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        window?.tintColor = lovFoodColor
        
        // Use Firebase library to configure APIs
        FIRApp.configure()
        FIRAuth.auth()?.signInAnonymouslyWithCompletion() { (user, error) in
            if error != nil {
            print(error)
            } else {
            print(user)
            print(user?.uid)
            
            }
        }
        return true
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

