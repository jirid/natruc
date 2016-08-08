//
//  NavigationController.swift
//  natruc
//
//  Created by Jiri Dutkevic on 18/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import UIKit

// re-enabling pop gesture when back button is hidden
// due to http://keighl.com/post/ios7-interactive-pop-gesture-custom-back-button/

internal final class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        weak var weakSelf = self
        delegate = weakSelf
        interactivePopGestureRecognizer?.delegate = weakSelf
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {

        interactivePopGestureRecognizer?.isEnabled = false
        super.pushViewController(viewController, animated: animated)
    }

}

extension NavigationController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController,
        didShow viewController: UIViewController, animated: Bool) {

        interactivePopGestureRecognizer?.isEnabled = viewControllers.count > 1
    }
}

extension NavigationController: UIGestureRecognizerDelegate {

}
