//
//  AppDelegate.swift
//  MemeMe 2.0
//
//  Created by Satveer Singh on 7/23/17.
//  Copyright © 2017 Satveer Singh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //Initialize array for Meme object
    var memes = [Meme]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

}

