//
//  InfoImageCell.swift
//  natruc
//
//  Created by Jiri Dutkevic on 12/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import UIKit

internal final class InfoImageCell: InfoCell {

    @IBOutlet weak var imgView: UIImageView!

    private var constraint: NSLayoutConstraint?

    override func setContent(_ content: InfoItem) {

        imgView.image = UIImage(contentsOfFile: content.content)

        if let c = constraint {
            imgView.removeConstraint(c)
            constraint = .none
        }

        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        if let i = imgView.image {
            let c = NSLayoutConstraint(item: imgView!, attribute: .width, relatedBy: .equal,
                toItem: imgView, attribute: .height, multiplier: i.size.width / i.size.height,
                constant: 0)
            imgView.addConstraint(c)
            constraint = c
        }
        super.updateConstraints()
    }

}
