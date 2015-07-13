//
//  ProgramViewModel.swift
//  natruc
//
//  Created by Jiri Dutkevic on 13/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import Foundation

internal final class ProgramViewModel {

    internal func numberOfSections() -> Int {

        return 3
    }

    internal func numberOfRows(section: Int) -> Int {

        return section == 0 ? 2 : 0
    }

    internal func itemForIndexPath(indexPath: NSIndexPath) -> ProgramItem {

        return ProgramItem()
    }
}
