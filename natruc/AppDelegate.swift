//
//  AppDelegate.swift
//  natruc
//
//  Created by Jiri Dutkevic on 04/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder {

    var window: UIWindow?

    fileprivate func customizeAppearance() {

        UITabBar.appearance().tintColor = Natruc.activeGray
        UITabBar.appearance().backgroundColor = Natruc.backgroundGray
        UITabBar.appearance().isOpaque = true
    }
}

extension AppDelegate: UIApplicationDelegate {

    func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        Components.shared.resources.load()
        Components.shared.model.load()
        customizeAppearance()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        Components.shared.resources.updateIfNeeded()
    }
}
