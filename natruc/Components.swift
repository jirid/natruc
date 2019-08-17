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

        NotificationCenter.default.addObserver(self,
            selector: #selector(Components.didReceiveMemoryWarning),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: .none)
    }

    deinit {

        NotificationCenter.default.removeObserver(self)
    }

    @objc func didReceiveMemoryWarning() {

        cachedDateParser = .none
    }

    //MARK: Model

    internal private(set) lazy var model = Model()
    internal private(set) lazy var resources = ResourceLoader()

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

    internal func now() -> Date {

        return Date()
    }
    
    internal let updateInterval: TimeInterval = 3600

    private var cachedDateParser: DateFormatter?
    internal func dateParser() -> DateFormatter {

        if let dp = cachedDateParser {

            return dp

        } else {

            let dp = DateFormatter()
            dp.locale = Locale(identifier: "en_US_POSIX")
            dp.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZ"
            dp.timeZone = TimeZone(secondsFromGMT: 0)
            cachedDateParser = dp
            return dp
        }
    }
}
