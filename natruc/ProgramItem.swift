//
//  ProgramItem.swift
//  natruc
//
//  Created by Jiri Dutkevic on 13/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import Foundation

internal enum Color: Int {
    case Blue = 0
    case Red = 1
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
}
