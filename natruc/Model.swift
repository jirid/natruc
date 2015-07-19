//
//  Model.swift
//  natruc
//
//  Created by Jiri Dutkevic on 19/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import Foundation

internal final class Model {

    //MARK: Properties

    internal let DataLoadedNotification = "DataLoadedNotification"

    internal var stages: [String]?
    internal var program: [[ProgramItem]]?
    internal var start: NSDate?
    internal var end: NSDate?
    internal var info: [InfoItem]?
    internal let mapURL: NSURL

    //MARK: Initializers

    internal init() {

        mapURL = NSBundle.mainBundle().URLForResource("map", withExtension: "jpg")!

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

            [weak self] in

            let programURL = NSBundle.mainBundle().URLForResource("bands", withExtension: "json")!
            if let (stages, program, start, end) = self?.loadProgram(programURL) {
                self?.stages = stages
                self?.program = program
                self?.start = start
                self?.end = end
            }

            let infoURL = NSBundle.mainBundle().URLForResource("info", withExtension: "json")!
            if let info = self?.loadInfo(infoURL) {
                self?.info = info
            }

            dispatch_async(dispatch_get_main_queue()) {

                if let s = self {
                    NSNotificationCenter.defaultCenter().postNotificationName(s.DataLoadedNotification, object: s)
                }
            }
        }
    }

    //MARK: Data Parsers

    internal func loadProgram(url: NSURL) -> ([String], [[ProgramItem]], NSDate, NSDate) {

        var items = [[ProgramItem]]()
        var stages = [String]()
        var gstart = NSDate.distantFuture() as! NSDate
        var gend = NSDate.distantPast() as! NSDate

        let data = NSData(contentsOfURL: url)!

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
                        let web = webPath == "" ? .None : NSURL(string: webPath)
                        let facebook = facebookPath == "" ? .None : NSURL(string: facebookPath)
                        let youtube = youtubePath == "" ? .None : NSURL(string: youtubePath)
                        let idx = stage.toInt()! - 1

                        let formatter = NSDateFormatter()
                        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZ"
                        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                        let startDate = formatter.dateFromString(start)!
                        let endDate = formatter.dateFromString(end)!
                        gstart = gstart.earlierDate(startDate)
                        gend = gend.laterDate(endDate)

                        let i = ProgramItem(name: name, brief: short, dark: dark, description: description, image: image, web: web, facebook: facebook, youtube: youtube, start: startDate, end: endDate, color: Color(rawValue: idx)!, stage: stages[idx])

                        var l = items[idx]
                        l.append(i)
                        items[idx] = l
                        
                    }
                }
            }
            
        }

        return (stages, items, gstart, gend)
    }

    internal func loadInfo(url: NSURL) -> [InfoItem] {

        var items = [InfoItem]()

        let data = NSData(contentsOfURL: url)!

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

        return items
    }
}
