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

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            [weak self] in
            let i = UIImage(data: NSData(contentsOfURL: Components.shared.model.mapURL)!)!
            dispatch_async(dispatch_get_main_queue()) {
                self?.image = i
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
}
