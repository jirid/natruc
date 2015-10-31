//
//  ProgramCell.swift
//  natruc
//
//  Created by Jiri Dutkevic on 13/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import Foundation
import UIKit

internal class ProgramCell: UITableViewCell {

    internal func setColor(color: Color) {

        switch color {

        case .Blue:
            contentView.backgroundColor = Natruc.lightBlue
        case .Red:
            contentView.backgroundColor = Natruc.lightRed
        case .Green:
            contentView.backgroundColor = Natruc.lightGreen
        }
    }
}
