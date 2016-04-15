//
//  Components.swift
//  natruc
//
//  Created by Jiri Dutkevic on 18/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import Foundation
import UIKit

internal final class Components {

    //MARK: Instance

    internal static var shared = Components()

    //MARK: Initialization

    private init() {

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(Components.didReceiveMemoryWarning),
            name: UIApplicationDidReceiveMemoryWarningNotification,
            object: .None)
    }

    deinit {

        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    @objc func didReceiveMemoryWarning() {

        cachedDateParser = .None
    }

    //MARK: Model

    internal let model = Model()

    //MARK: View Model

    internal func nowViewModel() -> NowViewModel {

        return NowViewModel(model: model)
    }

    internal func programViewModel() -> ProgramViewModel {

        return ProgramViewModel(model: model)
    }

    internal func infoViewModel() -> InfoViewModel {

        return InfoViewModel(model: model)
    }

    //MARK: Utils

    internal func now() -> NSDate {

        return NSDate()
    }

    private var cachedDateParser: NSDateFormatter?
    internal func dateParser() -> NSDateFormatter {

        if let dp = cachedDateParser {

            return dp

        } else {

            let dp = NSDateFormatter()
            dp.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            dp.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZ"
            dp.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            cachedDateParser = dp
            return dp
        }
    }
}
