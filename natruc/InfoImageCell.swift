//
//  InfoImageCell.swift
//  natruc
//
//  Created by Jiri Dutkevic on 12/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import UIKit

internal final class InfoImageCell: InfoCell {

    override func setContent(content: InfoItem) {

        imageView!.image = UIImage(contentsOfFile: content.content)
        setNeedsUpdateConstraints()
    }

}
