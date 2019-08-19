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
    
    fileprivate var ext: String {
        switch self {
        case .Info, .Bands:
            return "json"
        case .Map:
            return "jpg"
        }
    }
    
    fileprivate var hash: String {
        switch self {
        case .Info:
            return "d957097e12425763718ea408b478e091347661ec73e81817be868cfa3cb49d93"
        case .Bands:
            return "49e0e258890055769f758b999ccd8039ed027c3ac51c4ca9b97b83c650c0af23"
        case .Map:
            return "1161391ad97fba7014314281bebaac15787e2a12afe4ec6d033e3e5d2c072df4"
        }
    }
}

internal final class ResourceLoader {
    
    private let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
    
    // base URLs
    private let remoteBaseURL = URL(string: "https://natruc.korejtko.cz/app/ios/")!
    private let localBaseURL: URL
    
    // hash
    private func getHash(_ resource: Resource) -> String {
        return UserDefaults.standard.string(forKey: resource.rawValue) ?? resource.hash
    }
    
    private func setHash(_ resource: Resource, hash: String) {
        UserDefaults.standard.set(hash, forKey: resource.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    // last check
    
    private var lastUpdateCheck: TimeInterval {
        get {
            return UserDefaults.standard.double(forKey: "lastUpdateCheck")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastUpdateCheck")
            UserDefaults.standard.synchronize()
        }
    }
    
    // URL constructors
    private func url(_ resource: Resource, combinator: (String, String) -> URL?) -> URL? {
        return combinator(resource.rawValue, resource.ext)
    }
    
    internal func localUrl(_ resource: Resource) -> URL? {
        return url(resource) { localBaseURL.appendingPathComponent($0).appendingPathExtension($1) }
    }
    
    private func remoteUrl(_ resource: Resource) -> URL? {
        return url(resource) { remoteBaseURL.appendingPathComponent($0).appendingPathExtension($1) }
    }
    
    private func bundleUrl(_ resource: Resource) -> URL? {
        return url(resource) { Bundle.main.url(forResource: $0, withExtension: $1) }
    }
    
    // initializers
    internal init() {
        
        // init local storage
        localBaseURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("natruc")
        if !FileManager.default.fileExists(atPath: localBaseURL.path) {
            let _ = try? FileManager.default.createDirectory(at: localBaseURL, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    internal func load() {
        initResource(.Bands)
        initResource(.Map)
        initResource(.Info)
    }
    
    private func initResource(_ resource: Resource) {
        guard let lBands = localUrl(resource), let bBands = bundleUrl(resource) else {
            fatalError("missing bundle data")
        }
        if !FileManager.default.fileExists(atPath: lBands.path) {
            try! FileManager.default.copyItem(at: bBands, to: lBands)
        }
    }
    
    internal func updateIfNeeded() {
        let now = Date().timeIntervalSince1970
        if lastUpdateCheck <= now - Components.shared.updateInterval || now < lastUpdateCheck {
            lastUpdateCheck = now
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                self.updateResourceIfNeeded(.Info) {
                    if $0 {
                        Components.shared.model.loadInfo()
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: Model.dataLoadedNotification), object: self)
                        }
                    }
                }
                self.updateResourceIfNeeded(.Map) {
                    if $0 {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: Model.dataLoadedNotification), object: self)
                        }
                    }
                }
                self.updateResourceIfNeeded(.Bands) {
                    if $0 {
                        Components.shared.model.loadBands()
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: Model.dataLoadedNotification), object: self)
                        }
                    }
                }
            }
        }
    }
    
    private func updateResourceIfNeeded(_ resource: Resource, completion: @escaping (Bool) -> ()) {
        let complete = {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                completion(false)
            }
        }
        guard let remoteUrl = remoteUrl(resource) else {
            complete()
            return
        }
        let request = NSMutableURLRequest(url: remoteUrl)
        request.httpMethod = "HEAD"
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if error == nil, let response = response as? HTTPURLResponse, response.statusCode == 200, let remoteHash = response.allHeaderFields["Content-Hash"] as? String {
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
    
    private func updateResource(_ resource: Resource, completion: @escaping (Bool) -> ()) {
        let complete: (Bool) -> () = {
            result in
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                completion(result)
            }
        }
        guard let remoteUrl = remoteUrl(resource), let localUrl = localUrl(resource) else {
            complete(false)
            return
        }
        let request = NSMutableURLRequest(url: remoteUrl)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if error == nil, let response = response as? HTTPURLResponse, response.statusCode == 200, let hash = response.allHeaderFields["Content-Hash"] as? String, let data = data {
                try? data.write(to: localUrl, options: [.atomic])
                self.setHash(resource, hash: hash)
                complete(true)
            } else {
                complete(false)
            }
        }
        task.resume()
    }
    
    private func parseURL(_ url: URL) -> (String, String) {
        return (url.deletingPathExtension().lastPathComponent, url.pathExtension)
    }
    
    private func downloadResource(_ localUrl: URL, remoteUrl: URL) {
        let request = NSMutableURLRequest(url: remoteUrl)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if error == nil, let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                try? data.write(to: localUrl, options: [.atomic])
            }
        }
        task.resume()
    }
    
    internal func localUrlForRemoteUrl(_ url: URL) -> URL? {
        let (name, ext) = parseURL(url)
        if let bundleUrl = Bundle.main.url(forResource: name, withExtension: ext) {
            return bundleUrl
        }
        let localUrl = localBaseURL.appendingPathComponent(name).appendingPathExtension(ext)
        if !FileManager.default.fileExists(atPath: localUrl.path) {
            downloadResource(localUrl, remoteUrl: url)
        }
        return localUrl
    }
}
