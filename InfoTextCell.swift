//
//  InfoTextCell.swift
//  natruc
//
//  Created by Jiri Dutkevic on 12/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import UIKit

internal final class InfoTextCell: InfoCell {

    @IBOutlet weak var textView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()

        textView.textColor = Natruc.black
    }

    override func setContent(content: InfoItem) {

        textView.text = content.content
    }

}
