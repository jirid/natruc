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

    private let model: Model

    internal var dataChanged: (() -> ())?

    internal var stages: [String]
    private var items: [[ProgramItem]]

    internal init(model: Model) {

        self.model = model

        if let stages = model.stages, let items = model.program {

            self.stages = stages
            self.items = items

            if let dc = dataChanged {
                dc()
            }

        } else {

            stages = [String]()
            items = [[ProgramItem]]()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProgramViewModel.dataLoaded), name: NSNotification.Name(rawValue: Model.dataLoadedNotification), object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }

    @objc func dataLoaded() {

        if let stages = model.stages, let items = model.program {

            self.stages = stages
            self.items = items

            if let dc = dataChanged {
                dc()
            }
        }
    }

    internal func numberOfStages() -> Int {

        return stages.count
    }

    internal func colorForStage(_ section: Int) -> Color {

        switch section {

        case 0:
            return .red
        case 1:
            return .blue
        case 2:
            return .green
        default:
            return .blue
        }
    }

    internal func numberOfBands(_ stage: Int) -> Int {

        return items[stage].count + 1
    }

    internal func bandForIndexPath(_ indexPath: IndexPath) -> ProgramItem {

        return items[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row - 1]
    }
}
