//
//  ProgramStageCell.swift
//  natruc
//
//  Created by Jiri Dutkevic on 13/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import Foundation
import UIKit

internal class ProgramStageCell: ProgramCell {

    @IBOutlet weak var label: UILabel!

    internal func setTitle(title: String) {

        label.text = title
        label.textColor = Natruc.yellow
    }
}
