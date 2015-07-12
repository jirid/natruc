//
//  InfoViewModel.swift
//  natruc
//
//  Created by Jiri Dutkevic on 12/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import Foundation

internal final class InfoViewModel {

    internal let items: [InfoItem]

    internal init() {

        var items = [InfoItem]()

        //TODO: replace with data from model
        let path = NSBundle.mainBundle().pathForResource("info", ofType: "json")!
        let data = NSData(contentsOfFile: path)!

        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0), error: nil)

        if let dict = json as? Dictionary<String,AnyObject>,
            let arr = dict["items"] as? Array<Dictionary<String,AnyObject>> {
            for item in arr {
                if let rawType = item[InfoItemKey.TypeKey.rawValue] as? String,
                    let type = InfoItemType(rawValue: rawType),
                    let content = item[InfoItemKey.ContentKey.rawValue] as? String {

                        switch type {
                        case .Image:
                            let url = NSURL(string: content)!
                            let path = NSBundle.mainBundle().URLForResource(url.lastPathComponent!, withExtension: .None)!
                            let i = InfoItem(type: type, content: path.path!)
                            items.append(i)

                        case .Title:
                            let locale = NSLocale(localeIdentifier: "cs-cz")
                            let i = InfoItem(type: type, content: content.uppercaseStringWithLocale(locale))
                            items.append(i)

                        default:
                            let i = InfoItem(type: type, content: content)
                            items.append(i)
                        }
                }
            }
        }

        self.items = items
    }
}
