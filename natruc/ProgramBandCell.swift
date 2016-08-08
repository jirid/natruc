//
//  ProgramBandCell.swift
//  natruc
//
//  Created by Jiri Dutkevic on 13/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import Foundation
import UIKit

internal class ProgramBandCell: ProgramCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var briefLabel: UILabel!

    internal func setItem(_ item: ProgramItem) {

        titleLabel.text = item.name
        titleLabel.textColor = Natruc.white
        briefLabel.text = item.brief
        briefLabel.textColor = Natruc.white
        timeLabel.text = item.time()
        timeLabel.textColor = Natruc.white
        self.accessibilityIdentifier = item.name
    }
}
