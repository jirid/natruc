//
//  InfoItem.swift
//  natruc
//
//  Created by Jiri Dutkevic on 12/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import Foundation

internal enum InfoItemKey : String {
    case TypeKey = "type"
    case ContentKey = "content"
}

internal enum InfoItemType : String {
    case Title = "title1"
    case Text = "text"
    case Subtitle = "title2"
    case Image = "image"
}

internal struct InfoItem {
    let type: InfoItemType
    let content: String
}
