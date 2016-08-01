//
//  Resource.swift
//  natruc
//
//  Created by Jiri Dutkevic on 24/07/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

import Foundation

internal enum Resource: String {
    case Info = "info"
    case Bands = "bands"
    case Map = "map"
    
    private var ext: String {
        switch self {
        case .Info, .Bands:
            return "json"
        case .Map:
            return "jpg"
        }
    }
    
    private var hash: String {
        switch self {
        case .Info:
            return "b9371ce9ec01318151d928714ab5378fae363f9f67a238e48c9ab49da3a3e9dd"
        case .Bands:
            return "fe479c66ea5babb13cd97b0d62f075ceaee54e28027075fec6c86580ef29102c"
        case .Map:
            return "b44c2ecc8907122dac284f7ae9eae84573a79230138ff624b98b58776d37acd9"
        }
    }
}

internal final class ResourceLoader {
    
    private let session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
    
    // base URLs
    private let remoteBaseURL = NSURL(string: "https://natruc.korejtko.cz/app/ios/")!
    private let localBaseURL: NSURL
    
    // hash
    private func getHash(resource: Resource) -> String {
        return NSUserDefaults.standardUserDefaults().stringForKey(resource.rawValue) ?? resource.hash
    }
    
    private func setHash(resource: Resource, hash: String) {
        NSUserDefaults.standardUserDefaults().setObject(hash, forKey: resource.rawValue)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    // last check
    
    private var lastUpdateCheck: NSTimeInterval {
        get {
            return NSUserDefaults.standardUserDefaults().doubleForKey("lastUpdateCheck")
        }
        set {
            NSUserDefaults.standardUserDefaults().setDouble(newValue, forKey: "lastUpdateCheck")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    // URL constructors
    private func url(resource: Resource, @noescape combinator: (String, String) -> NSURL?) -> NSURL? {
        return combinator(resource.rawValue, resource.ext)
    }
    
    internal func localUrl(resource: Resource) -> NSURL? {
        return url(resource) { localBaseURL.URLByAppendingPathComponent($0).URLByAppendingPathExtension($1) }
    }
    
    private func remoteUrl(resource: Resource) -> NSURL? {
        return url(resource) { remoteBaseURL.URLByAppendingPathComponent($0).URLByAppendingPathExtension($1) }
    }
    
    private func bundleUrl(resource: Resource) -> NSURL? {
        return url(resource) { NSBundle.mainBundle().URLForResource($0, withExtension: $1) }
    }
    
    // initializers
    internal init() {
        
        // init local storage
        localBaseURL = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask).first!.URLByAppendingPathComponent("natruc")
        if !NSFileManager.defaultManager().fileExistsAtPath(localBaseURL.path!) {
            let _ = try? NSFileManager.defaultManager().createDirectoryAtURL(localBaseURL, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    internal func load() {
        initResource(.Bands)
        initResource(.Map)
        initResource(.Info)
    }
    
    private func initResource(resource: Resource) {
        guard let lBands = localUrl(resource), let bBands = bundleUrl(resource) else {
            fatalError("missing bundle data")
        }
        if !NSFileManager.defaultManager().fileExistsAtPath(lBands.path!) {
            try! NSFileManager.defaultManager().copyItemAtURL(bBands, toURL: lBands)
        }
    }
    
    internal func updateIfNeeded() {
        let now = NSDate().timeIntervalSince1970
        if lastUpdateCheck <= now - Components.shared.updateInterval {
            lastUpdateCheck = now
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) {
                self.updateResourceIfNeeded(.Info) {
                    if $0 {
                        Components.shared.model.loadInfo()
                        dispatch_async(dispatch_get_main_queue()) {
                            NSNotificationCenter.defaultCenter().postNotificationName(Model.dataLoadedNotification, object: self)
                        }
                    }
                }
                self.updateResourceIfNeeded(.Map) {
                    if $0 {
                        dispatch_async(dispatch_get_main_queue()) {
                            NSNotificationCenter.defaultCenter().postNotificationName(Model.dataLoadedNotification, object: self)
                        }
                    }
                }
                self.updateResourceIfNeeded(.Bands) {
                    if $0 {
                        Components.shared.model.loadBands()
                        dispatch_async(dispatch_get_main_queue()) {
                            NSNotificationCenter.defaultCenter().postNotificationName(Model.dataLoadedNotification, object: self)
                        }
                    }
                }
            }
        }
    }
    
    private func updateResourceIfNeeded(resource: Resource, completion: (Bool) -> ()) {
        let complete = {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) {
                completion(false)
            }
        }
        guard let remoteUrl = remoteUrl(resource) else {
            complete()
            return
        }
        let request = NSMutableURLRequest(URL: remoteUrl)
        request.HTTPMethod = "HEAD"
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) in
            if error == nil, let response = response as? NSHTTPURLResponse where response.statusCode == 200, let remoteHash = response.allHeaderFields["Content-Hash"] as? String {
                let localHash = self.getHash(resource)
                if remoteHash == localHash {
                    complete()
                } else {
                    self.updateResource(resource, completion: completion)
                }
            } else {
                complete()
            }
        }
        task.resume()
    }
    
    private func updateResource(resource: Resource, completion: (Bool) -> ()) {
        let complete: (Bool) -> () = {
            result in
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) {
                completion(result)
            }
        }
        guard let remoteUrl = remoteUrl(resource), localUrl = localUrl(resource) else {
            complete(false)
            return
        }
        let request = NSMutableURLRequest(URL: remoteUrl)
        request.HTTPMethod = "GET"
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) in
            if error == nil, let response = response as? NSHTTPURLResponse where response.statusCode == 200, let hash = response.allHeaderFields["Content-Hash"] as? String, let data = data {
                data.writeToURL(localUrl, atomically: true)
                self.setHash(resource, hash: hash)
                complete(true)
            } else {
                complete(false)
            }
        }
        task.resume()
    }
    
    private func parseURL(url: NSURL) -> (String, String)? {
        if let ext = url.pathExtension, let tmp = url.URLByDeletingPathExtension, let name = tmp.lastPathComponent {
            return (name, ext)
        } else {
            return nil
        }
    }
    
    private func downloadResource(localUrl: NSURL, remoteUrl: NSURL) {
        let request = NSMutableURLRequest(URL: remoteUrl)
        request.HTTPMethod = "GET"
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) in
            if error == nil, let response = response as? NSHTTPURLResponse where response.statusCode == 200, let data = data {
                data.writeToURL(localUrl, atomically: true)
            }
        }
        task.resume()
    }
    
    internal func localUrlForRemoteUrl(url: NSURL) -> NSURL? {
        guard let (name, ext) = parseURL(url) else {
            return nil
        }
        if let bundleUrl = NSBundle.mainBundle().URLForResource(name, withExtension: ext) {
            return bundleUrl
        }
        let localUrl = localBaseURL.URLByAppendingPathComponent(name).URLByAppendingPathExtension(ext)
        if !NSFileManager.defaultManager().fileExistsAtPath(localUrl.path!) {
            downloadResource(localUrl, remoteUrl: url)
        }
        return localUrl
    }
}
