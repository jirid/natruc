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

    internal static let dataLoadedNotification = "DataLoadedNotification"

    internal var stages: [String]?
    internal var program: [[ProgramItem]]?
    internal var start: Date?
    internal var end: Date?
    internal var info: [InfoItem]?

    //MARK: Initializers

    internal init() {

    }
    
    internal func load() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            
            [weak self] in
            
            self?.loadBands()
            self?.loadInfo()
            
            DispatchQueue.main.async {
                
                if let s = self {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: Model.dataLoadedNotification), object: s)
                }
            }
        }
    }
    
    internal func loadBands() {
        guard let programURL = Components.shared.resources.localUrl(.Bands) else {
            return
        }
        let (stages, program, start, end) = loadProgram(programURL)
        self.stages = stages
        self.program = program
        self.start = start
        self.end = end
    }
    
    internal func loadInfo() {
        guard let infoURL = Components.shared.resources.localUrl(.Info) else {
            return
        }
        info = loadInfo(infoURL)
    }

    //MARK: Data Parsers

    internal func loadProgram(_ url: URL) -> ([String], [[ProgramItem]], Date, Date) {

        var items = [[ProgramItem]]()
        var stages = [String]()
        var gstart = Date.distantFuture
        var gend = Date.distantPast
        let data = try! Data(contentsOf: url)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
        let jsonStages = json["stages" as NSString] as! NSArray
        let jsonBands = json["bands" as NSString] as! NSArray

        for l in jsonStages {

            guard let j = l as? NSDictionary, let name = j["name" as NSString] as? String else {
                continue
            }

            let locale = Locale(identifier: "cs-cz")
            stages.append(name.uppercased(with: locale))
            items.append([ProgramItem]())
        }

        for k in jsonBands {
            
            let j = k as! NSDictionary

            guard let (i, idx) = parseProgramItem(j, stages: stages) else {
                continue
            }

            gstart = (gstart as NSDate).earlierDate(i.start)
            gend = (gend as NSDate).laterDate(i.end)

            var l = items[idx]
            l.append(i)
            items[idx] = l
        }

        return (stages, items, gstart.addingTimeInterval(-3600), gend)
    }

    private func parseProgramItem(_ json: NSDictionary, stages: [String]) -> (ProgramItem, Int)? {

        let l = json["links" as NSString] as! NSDictionary
        guard let name = json["name" as NSString] as? String, let short = json["shortDesc" as NSString] as? String,
            let dark = json["darkStatusBar" as NSString] as? NSNumber, let description = json["desc" as NSString] as? String,
            let imagePath = json["image" as NSString] as? String, let webPath = l["web" as NSString] as? String,
            let facebookPath = l["facebook" as NSString] as? String, let youtubePath = l["youtube" as NSString] as? String,
            let start = json["start" as NSString] as? String, let end = json["end" as NSString] as? String,
            let stage = json["stageId" as NSString] as? String else {

                return .none
        }

        let image = URL(string: imagePath).flatMap {
            Components.shared.resources.localUrlForRemoteUrl($0)
        }
        let web = webPath == "" ? .none : URL(string: webPath)
        let facebook = facebookPath == "" ? .none : URL(string: facebookPath)
        let youtube = youtubePath == "" ? .none : URL(string: youtubePath)
        let idx = Int(stage)! - 1

        let formatter = Components.shared.dateParser()
        let startDate = formatter.date(from: start)!
        let endDate = formatter.date(from: end)!

        let result = (ProgramItem(name: name, brief: short, dark: dark.boolValue,
            description: description, image: image, web: web, facebook: facebook,
            youtube: youtube, start: startDate, end: endDate, color: Color(rawValue: idx)!,
            stage: stages[idx]), idx)

        return result
    }

    internal func loadInfo(_ url: URL) -> [InfoItem] {

        var items = [InfoItem]()
        let data = try! Data(contentsOf: url)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
        let jsonItems = json["items" as NSString] as! NSArray

        for k in jsonItems {
            
            let j = k as! NSDictionary

            guard let rawType = j[InfoItemKey.TypeKey.rawValue as NSString] as? String,
                let type = InfoItemType(rawValue: rawType),
                let content = j[InfoItemKey.ContentKey.rawValue as NSString] as? String else {

                    continue
            }

            switch type {

            case .Image:
                let url = Components.shared.resources.localUrlForRemoteUrl(URL(string: content)!)!
                let i = InfoItem(type: type, content: url.path)
                items.append(i)

            case .Title:
                let locale = Locale(identifier: "cs-cz")
                let i = InfoItem(type: type,
                    content: content.uppercased(with: locale))
                items.append(i)

            default:
                let i = InfoItem(type: type, content: content)
                items.append(i)
            }
        }

        return items
    }
}
