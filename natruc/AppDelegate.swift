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

    private func customizeAppearance() {

        UITabBar.appearance().tintColor = Natruc.activeGray
        UITabBar.appearance().backgroundColor = Natruc.backgroundGray
        UITabBar.appearance().opaque = true
    }
}

extension AppDelegate: UIApplicationDelegate {

    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        customizeAppearance()
        return true
    }
}
