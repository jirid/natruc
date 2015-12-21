//
//  Timer.swift
//  natruc
//
//  Created by Jiri Dutkevic on 22/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import Foundation

internal final class Timer {

    var timer: NSTimer?
    let callback: () -> ()

    internal init(interval: NSTimeInterval, callback: () -> ()) {

        self.callback = callback
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self,
            selector: Selector("timerElapsed"), userInfo: .None, repeats: true)
    }

    internal func invalidate() {

        timer?.invalidate()
    }

    @objc func timerElapsed() {

        callback()
    }
}
