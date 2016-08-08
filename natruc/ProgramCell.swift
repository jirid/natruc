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

    internal func setColor(_ color: Color) {

        switch color {

        case .blue:
            contentView.backgroundColor = Natruc.lightBlue
        case .red:
            contentView.backgroundColor = Natruc.lightRed
        case .green:
            contentView.backgroundColor = Natruc.lightGreen
        }
    }
}
