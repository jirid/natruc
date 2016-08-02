//
//  ProgramItem.swift
//  natruc
//
//  Created by Jiri Dutkevic on 13/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import Foundation

internal enum Color: Int {
    case Blue = 1
    case Red = 0
    case Green = 2
}

internal struct ProgramItem {
    let name: String
    let brief: String
    let dark: Bool
    let description: String
    let image: NSURL?
    let web: NSURL?
    let facebook: NSURL?
    let youtube: NSURL?
    let start: NSDate
    let end: NSDate
    let color: Color
    let stage: String

    func progress() -> Double {

        let s = start.timeIntervalSince1970
        let n = Components.shared.now().timeIntervalSince1970
        let e = end.timeIntervalSince1970
        if s >= n {

            return 0

        } else if e <= n {

            return 1

        } else {

            return (n - s) / (e - s)
        }
    }

    func time() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH':'mm"
        let s = formatter.stringFromDate(start)
        let e = formatter.stringFromDate(end)
        return "\(s) - \(e)"
    }
}
