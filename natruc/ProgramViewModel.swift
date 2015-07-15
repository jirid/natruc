//
//  ProgramViewModel.swift
//  natruc
//
//  Created by Jiri Dutkevic on 13/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import Foundation
import UIKit

internal final class ProgramViewModel {

    internal let stages: [String]
    private let items: [[ProgramItem]]

    internal init() {

        var items = [[ProgramItem]]()
        var stages = [String]()

        //TODO: replace with data from model
        let path = NSBundle.mainBundle().pathForResource("bands", ofType: "json")!
        let data = NSData(contentsOfFile: path)!

        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0), error: nil)

        if let dict = json as? Dictionary<String,AnyObject> {

            if let s = dict["stages"] as? Array<Dictionary<String,AnyObject>> {

                for item in s {

                    if let name = item["name"] as? String {

                        let locale = NSLocale(localeIdentifier: "cs-cz")
                        stages.append(name.uppercaseStringWithLocale(locale))
                        items.append([ProgramItem]())
                    }
                }
            }

            if let b = dict["bands"] as? Array<Dictionary<String,AnyObject>> {

                for item in b {

                    if let name = item["name"] as? String, let short = item["shortDesc"] as? String, let dark = item["darkStatusBar"] as? Bool, let description = item["desc"] as? String, let imagePath = item["image"] as? String, let links = item["links"] as? Dictionary<String, String>, let webPath = links["web"], let facebookPath = links["facebook"], let youtubePath = links["youtube"], let start = item["start"] as? String, let end = item["end"] as? String, let stage = item["stageId"] as? String {

                        let resource = NSURL(string: imagePath)?.lastPathComponent
                        let image = resource == .None ? .None : NSBundle.mainBundle().URLForResource(resource!, withExtension: .None)
                        let web = webPath == "" ? nil : NSURL(string: webPath)
                        let facebook = facebookPath == "" ? nil : NSURL(string: facebookPath)
                        let youtube = youtubePath == "" ? nil : NSURL(string: youtubePath)
                        let idx = stage.toInt()! - 1

                        let formatter = NSDateFormatter()
                        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZ"
                        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                        let startDate = formatter.dateFromString(start)!
                        let endDate = formatter.dateFromString(end)!

                        let i = ProgramItem(name: name, brief: short, dark: dark, description: description, image: image, web: web, facebook: facebook, youtube: youtube, start: startDate, end: endDate, color: Color(rawValue: idx)!, stage: stages[idx])

                        var l = items[idx]
                        l.append(i)
                        items[idx] = l

                    }
                }
            }

        }

        self.stages = stages
        self.items = items
    }

    internal func numberOfSections() -> Int {

        return stages.count
    }

    internal func colorForSection(section: Int) -> Color {

        switch (section) {

        case 0:
            return .Blue
        case 1:
            return .Red
        case 2:
            return .Green
        default:
            return .Blue
        }
    }

    internal func numberOfRows(section: Int) -> Int {

        return items[section].count + 1
    }

    internal func itemForIndexPath(indexPath: NSIndexPath) -> ProgramItem {

        return items[indexPath.section][indexPath.row - 1]
    }
}
