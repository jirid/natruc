//
//  Components.swift
//  natruc
//
//  Created by Jiri Dutkevic on 18/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import Foundation

internal final class Components {

    private struct Cache {
        static var shared = Components()
    }

    internal class var shared: Components { return Cache.shared }

    internal func now() -> NSDate {

        return NSDate()
    }
}
