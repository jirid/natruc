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

    @objc private func setUp() {

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            [weak self] in
            let i = Components.shared.resources.localUrl(.Map).flatMap {
                NSData(contentsOfURL: $0)
            }.flatMap {
                UIImage(data: $0)
            }
            dispatch_async(dispatch_get_main_queue()) {
                self?.image = i
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setUp), name: Model.dataLoadedNotification, object: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setUp()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setUp), name: Model.dataLoadedNotification, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setUp), name: Model.dataLoadedNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
