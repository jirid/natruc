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

    internal func setItem(item: ProgramItem) {

        titleLabel.text = item.name
        titleLabel.textColor = Natruc.white
        briefLabel.text = item.brief
        briefLabel.textColor = Natruc.white

        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH':'mm"
        let start = formatter.stringFromDate(item.start)
        let end = formatter.stringFromDate(item.end)
        timeLabel.text = "\(start) - \(end)"
        timeLabel.textColor = Natruc.white
    }
}
