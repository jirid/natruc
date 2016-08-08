//
//  NowViewModel.swift
//  natruc
//
//  Created by Jiri Dutkevic on 19/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import Foundation

internal enum Progress {
    case notLoaded
    case notStarted
    case progress(ProgramItem?, ProgramItem?, ProgramItem?)
    case ended
}

internal final class NowViewModel {

    private let model: Model
    private var items: [[ProgramItem]]
    private var start: Date?
    private var end: Date?

    internal var dataChanged: ((Void) -> Void)?

    internal init(model: Model) {

        self.model = model

        if let items = model.program, let start = model.start, let end = model.end {

            self.items = items
            self.start = start as Date
            self.end = end as Date

            if let dc = dataChanged {
                dc()
            }

        } else {

            items = [[ProgramItem]]()
            start = .none
            end = .none
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(NowViewModel.dataLoaded), name: NSNotification.Name(rawValue: Model.dataLoadedNotification), object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }

    @objc func dataLoaded() {

        if let items = model.program, let start = model.start, let end = model.end {

            self.items = items
            self.start = start as Date
            self.end = end as Date

            if let dc = dataChanged {
                dc()
            }
        }
    }

    internal func state() -> Progress {

        if items.count == 3 {

            let now = Components.shared.now().timeIntervalSince1970
            let start = self.start!
            let end = self.end!

            if now < start.timeIntervalSince1970 {

                return .notStarted

            } else if now > end.timeIntervalSince1970 {

                return .ended

            } else {

                return .progress(currentBand(0), currentBand(1), currentBand(2))
            }

        } else {

            return .notLoaded
        }
    }

    internal func currentBand(_ stage: Int) -> ProgramItem? {

        let now = Components.shared.now().timeIntervalSince1970

        var band: ProgramItem?
        for i in items[stage] {
            if i.end.timeIntervalSince1970 > now {
                band = i
                break
            }
        }

        return band
    }
}
