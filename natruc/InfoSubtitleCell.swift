//
//  InfoSubtitleCell.swift
//  natruc
//
//  Created by Jiri Dutkevic on 12/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import UIKit

internal final class InfoSubtitleCell: InfoCell {

    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        label.textColor = Natruc.sectionHeader
    }

    override func setContent(_ content: InfoItem) {

        label.text = content.content
        self.accessibilityIdentifier = content.content
    }

}
