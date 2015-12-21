//
//  Model.swift
//  natruc
//
//  Created by Jiri Dutkevic on 19/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import Foundation
import SwiftyJSON

internal final class Model {

    //MARK: Properties

    internal static let dataLoadedNotification = "DataLoadedNotification"

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
                    NSNotificationCenter.defaultCenter()
                        .postNotificationName(Model.dataLoadedNotification, object: s)
                }
            }
        }
    }

    //MARK: Data Parsers

    internal func loadProgram(url: NSURL) -> ([String], [[ProgramItem]], NSDate, NSDate) {

        var items = [[ProgramItem]]()
        var stages = [String]()
        var gstart = NSDate.distantFuture()
        var gend = NSDate.distantPast()
        let data = NSData(contentsOfURL: url)!
        let json = JSON(data: data)

        for (_, j) in json["stages"] {

            guard let name = j["name"].string else {
                continue
            }

            let locale = NSLocale(localeIdentifier: "cs-cz")
            stages.append(name.uppercaseStringWithLocale(locale))
            items.append([ProgramItem]())
        }

        for (_, j) in json["bands"] {

            guard let (i, idx) = parseProgramItem(j, stages: stages) else {
                continue
            }

            gstart = gstart.earlierDate(i.start)
            gend = gend.laterDate(i.end)

            var l = items[idx]
            l.append(i)
            items[idx] = l
        }

        return (stages, items, gstart.dateByAddingTimeInterval(-3600), gend)
    }

    private func parseProgramItem(json: JSON, stages: [String]) -> (ProgramItem, Int)? {

        let l = json["links"]
        guard let name = json["name"].string, let short = json["shortDesc"].string,
            let dark = json["darkStatusBar"].bool, let description = json["desc"].string,
            let imagePath = json["image"].string, let webPath = l["web"].string,
            let facebookPath = l["facebook"].string, let youtubePath = l["youtube"].string,
            let start = json["start"].string, let end = json["end"].string,
            let stage = json["stageId"].string else {

                return .None
        }

        let resource = NSURL(string: imagePath)?.lastPathComponent
        let image = resource == .None ? .None :
            NSBundle.mainBundle().URLForResource(resource!, withExtension: .None)
        let web = webPath == "" ? .None : NSURL(string: webPath)
        let facebook = facebookPath == "" ? .None : NSURL(string: facebookPath)
        let youtube = youtubePath == "" ? .None : NSURL(string: youtubePath)
        let idx = Int(stage)! - 1

        let formatter = Components.shared.dateParser()
        let startDate = formatter.dateFromString(start)!
        let endDate = formatter.dateFromString(end)!

        let result = (ProgramItem(name: name, brief: short, dark: dark,
            description: description, image: image, web: web, facebook: facebook,
            youtube: youtube, start: startDate, end: endDate, color: Color(rawValue: idx)!,
            stage: stages[idx]), idx)

        return result
    }

    internal func loadInfo(url: NSURL) -> [InfoItem] {

        var items = [InfoItem]()
        let data = NSData(contentsOfURL: url)!
        let json = JSON(data: data)

        for (_, j) in json["items"] {

            guard let rawType = j[InfoItemKey.TypeKey.rawValue].string,
                let type = InfoItemType(rawValue: rawType),
                let content = j[InfoItemKey.ContentKey.rawValue].string else {

                    continue
            }

            switch type {

            case .Image:
                let url = NSURL(string: content)!
                let path = NSBundle.mainBundle().URLForResource(url.lastPathComponent!,
                    withExtension: .None)!
                let i = InfoItem(type: type, content: path.path!)
                items.append(i)

            case .Title:
                let locale = NSLocale(localeIdentifier: "cs-cz")
                let i = InfoItem(type: type,
                    content: content.uppercaseStringWithLocale(locale))
                items.append(i)

            default:
                let i = InfoItem(type: type, content: content)
                items.append(i)
            }
        }

        return items
    }
}
