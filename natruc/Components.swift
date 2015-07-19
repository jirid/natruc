//
//  Components.swift
//  natruc
//
//  Created by Jiri Dutkevic on 18/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import Foundation

internal final class Components {

    //MARK: Instance

    private struct Cache {
        static var shared = Components()
    }

    internal class var shared: Components { return Cache.shared }

    //MARK: Model

    internal let model = Model()

    //MARK: View Model

    internal func nowViewModel() -> NowViewModel {
        return NowViewModel(model: model)
    }

    internal func programViewModel() -> ProgramViewModel {
        return ProgramViewModel(model: model)
    }

    internal func infoViewModel() -> InfoViewModel {
        return InfoViewModel(model: model)
    }

    //MARK: Utils

    internal func now() -> NSDate {

        return NSDate()
    }
}
