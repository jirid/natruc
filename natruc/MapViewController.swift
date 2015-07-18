//
//  MapViewController.swift
//  natruc
//
//  Created by Jiri Dutkevic on 04/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import UIKit

internal final class MapViewController: ImageViewController {

    //MARK: Initializers

    private func setUp() {
        //TODO: replace with data from view model
        let path = NSBundle.mainBundle().pathForResource("map", ofType: "jpg")!
        image = UIImage(contentsOfFile: path)!
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setUp()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
}
