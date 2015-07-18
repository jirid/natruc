//
//  InfoImageCell.swift
//  natruc
//
//  Created by Jiri Dutkevic on 12/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import UIKit

internal final class InfoImageCell: InfoCell {

    @IBOutlet weak var iv: UIImageView!

    private var constraint: NSLayoutConstraint?

    override func setContent(content: InfoItem) {

        iv.image = UIImage(contentsOfFile: content.content)

        if let c = constraint {
            iv.removeConstraint(c)
            constraint = .None
        }

        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        if let i = iv.image {
            let c = NSLayoutConstraint(item: iv, attribute: .Width, relatedBy: .Equal, toItem: iv, attribute: .Height, multiplier: i.size.width / i.size.height, constant: 0)
            iv.addConstraint(c)
            constraint = c
        }
        super.updateConstraints()
    }

}
