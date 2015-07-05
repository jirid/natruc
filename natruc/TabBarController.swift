//
//  TabBarController.swift
//  natruc
//
//  Created by Jiri Dutkevic on 05/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {

        super.viewDidLoad()

        tabBar.backgroundColor = Natruc.backgroundGray
        tabBar.tintColor = Natruc.backgroundBlue
    }
}
