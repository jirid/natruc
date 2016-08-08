//
//  ProgramItem.swift
//  natruc
//
//  Created by Jiri Dutkevic on 13/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import Foundation

internal enum Color: Int {
    case blue = 1
    case red = 0
    case green = 2
}

internal struct ProgramItem {
    let name: String
    let brief: String
    let dark: Bool
    let description: String
    let image: URL?
    let web: URL?
    let facebook: URL?
    let youtube: URL?
    let start: Date
    let end: Date
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
        let formatter = DateFormatter()
        formatter.dateFormat = "HH':'mm"
        let s = formatter.string(from: start)
        let e = formatter.string(from: end)
        return "\(s) - \(e)"
    }
}
