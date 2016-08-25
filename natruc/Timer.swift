//
//  Timer.swift
//  natruc
//
//  Created by Jiri Dutkevic on 22/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import Foundation

internal final class Timer {

    var timer: Foundation.Timer?
    let callback: () -> ()

    internal init(interval: TimeInterval, callback: @escaping () -> ()) {

        self.callback = callback
        timer = Foundation.Timer.scheduledTimer(timeInterval: interval, target: self,
            selector: #selector(Timer.timerElapsed), userInfo: .none, repeats: true)
    }

    internal func invalidate() {

        timer?.invalidate()
    }

    @objc func timerElapsed() {

        callback()
    }
}
