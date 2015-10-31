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

    internal var dataChanged: (Void -> Void)?

    internal var stages: [String]
    private var items: [[ProgramItem]]

    internal init(model: Model) {

        self.model = model

        if let stages = model.stages, items = model.program {

            self.stages = stages
            self.items = items

            if let dc = dataChanged {
                dc()
            }

        } else {

            stages = [String]()
            items = [[ProgramItem]]()

            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: Selector("dataLoaded"), name: Model.dataLoadedNotification, object: model)
        }
    }

    @objc func dataLoaded() {

        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: Model.dataLoadedNotification, object: model)

        if let stages = model.stages, items = model.program {

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

    internal func colorForStage(section: Int) -> Color {

        switch section {

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

    internal func numberOfBands(stage: Int) -> Int {

        return items[stage].count + 1
    }

    internal func bandForIndexPath(indexPath: NSIndexPath) -> ProgramItem {

        return items[indexPath.section][indexPath.row - 1]
    }
}
