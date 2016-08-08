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

        DispatchQueue.global().async {
            [weak self] in
            let i = Components.shared.resources.localUrl(.Map).flatMap {
                (try? Data(contentsOf: $0))
            }.flatMap {
                UIImage(data: $0)
            }
            DispatchQueue.main.async {
                self?.image = i
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
        NotificationCenter.default.addObserver(self, selector: #selector(setUp), name: NSNotification.Name(rawValue: Model.dataLoadedNotification), object: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setUp()
        NotificationCenter.default.addObserver(self, selector: #selector(setUp), name: NSNotification.Name(rawValue: Model.dataLoadedNotification), object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
        NotificationCenter.default.addObserver(self, selector: #selector(setUp), name: NSNotification.Name(rawValue: Model.dataLoadedNotification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
