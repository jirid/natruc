//
//  InfoViewModel.swift
//  natruc
//
//  Created by Jiri Dutkevic on 12/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import Foundation

internal final class InfoViewModel {

    private let model: Model

    internal var dataChanged: (Void -> Void)?

    internal var items: [InfoItem]

    internal init(model: Model) {

        self.model = model

        if let items = model.info {

            self.items = items

            if let dc = dataChanged {
                dc()
            }

        } else {

            items = [InfoItem]()

        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InfoViewModel.dataLoaded), name: Model.dataLoadedNotification, object: nil)
    }
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    @objc func dataLoaded() {

        if let items = model.info {

            self.items = items

            if let dc = dataChanged {
                dc()
            }
        }
    }
}
