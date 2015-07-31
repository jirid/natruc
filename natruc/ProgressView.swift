//
//  ProgressView.swift
//  natruc
//
//  Created by Jiri Dutkevic on 15/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import Foundation
import UIKit

internal final class ProgressView : UIView {

    private var darkView: UIView!
    private var stageLabel: UILabel!
    private var timeLabel: UILabel!
    private var nameLabel: UILabel!
    private var progressConstraint: NSLayoutConstraint?

    private func setUp() {

        darkView = UIView(frame: bounds)
        addSubview(darkView)

        stageLabel = UILabel()
        stageLabel.textColor = Natruc.yellow
        stageLabel.setContentCompressionResistancePriority(1000, forAxis: .Horizontal)
        stageLabel.setContentCompressionResistancePriority(1000, forAxis: .Vertical)
        addSubview(stageLabel)

        timeLabel = UILabel()
        timeLabel.textColor = Natruc.white
        timeLabel.setContentCompressionResistancePriority(1000, forAxis: .Horizontal)
        timeLabel.setContentCompressionResistancePriority(1000, forAxis: .Vertical)
        addSubview(timeLabel)

        nameLabel = UILabel()
        nameLabel.textColor = Natruc.white
        nameLabel.setContentCompressionResistancePriority(1000, forAxis: .Horizontal)
        nameLabel.setContentCompressionResistancePriority(1000, forAxis: .Vertical)
        addSubview(nameLabel)

        let views = ["view": self, "stage": stageLabel, "time": timeLabel, "name": nameLabel, "dark": darkView]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[stage]", options: [], metrics: .None, views: views))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[time]-[name]", options: [], metrics: .None, views: views))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[stage]-[time]-15-|", options: [], metrics: .None, views: views))
        addConstraint(NSLayoutConstraint(item: timeLabel, attribute: .Baseline, relatedBy: .Equal, toItem: nameLabel, attribute: .Baseline, multiplier: 1, constant: 0))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[dark]|", options: [], metrics: .None, views: views))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[dark]", options: [], metrics: .None, views: views))

        setProgress(0)

        translatesAutoresizingMaskIntoConstraints = false
        darkView.translatesAutoresizingMaskIntoConstraints = false
        stageLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    internal func setItem(item: ProgramItem) {

        switch item.color {
        case .Blue:
            backgroundColor = Natruc.lightBlue
            darkView.backgroundColor = Natruc.darkBlue
        case .Red:
            backgroundColor = Natruc.lightRed
            darkView.backgroundColor = Natruc.darkRed
        case .Green:
            backgroundColor = Natruc.lightGreen
            darkView.backgroundColor = Natruc.darkGreen
        }

        stageLabel.text = item.stage
        timeLabel.text = item.time()
        nameLabel.text = item.name
        setProgress(item.progress())
    }

    internal func setProgress(progress: Double) {
        if let c = progressConstraint {
            removeConstraint(c)
        }
        let c = NSLayoutConstraint(item: darkView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: CGFloat(progress), constant: 0)
        addConstraint(c)
        progressConstraint = c
        setNeedsLayout()
    }

}
