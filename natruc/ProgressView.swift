//
//  ProgressView.swift
//  natruc
//
//  Created by Jiri Dutkevic on 15/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import Foundation
import UIKit

internal final class ProgressView: UIView {

    private var darkView: UIView!
    private var stageLabel: UILabel!
    private var timeLabel: UILabel!
    private var nameLabel: UILabel!
    private var progressConstraint: NSLayoutConstraint?

    private func setUp() {

        translatesAutoresizingMaskIntoConstraints = false

        darkView = UIView(frame: bounds)
        darkView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(darkView)

        stageLabel = configureLabel(Natruc.yellow)
        timeLabel = configureLabel(Natruc.white)
        nameLabel = configureLabel(Natruc.white)

        configureConstraints()

        setProgress(0)
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

    internal func setItem(_ item: ProgramItem) {

        switch item.color {
        case .blue:
            backgroundColor = Natruc.lightBlue
            darkView.backgroundColor = Natruc.darkBlue
        case .red:
            backgroundColor = Natruc.lightRed
            darkView.backgroundColor = Natruc.darkRed
        case .green:
            backgroundColor = Natruc.lightGreen
            darkView.backgroundColor = Natruc.darkGreen
        }

        stageLabel.text = item.stage
        timeLabel.text = item.time()
        nameLabel.text = item.name
        setProgress(item.progress())
    }

    internal func setProgress(_ progress: Double) {
        if let c = progressConstraint {
            removeConstraint(c)
        }
        let c = NSLayoutConstraint(item: darkView!, attribute: .width, relatedBy: .equal,
            toItem: self, attribute: .width, multiplier: CGFloat(progress), constant: 0)
        addConstraint(c)
        progressConstraint = c
        setNeedsLayout()
    }

    private func configureLabel(_ color: UIColor) -> UILabel {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = color
        label.adjustsFontSizeToFitWidth = true
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        addSubview(label)

        return label
    }

    private func configureConstraints() {

        let views = ["view": self as AnyObject, "stage": stageLabel as AnyObject, "time": timeLabel as AnyObject,
            "name": nameLabel as AnyObject, "dark": darkView as AnyObject]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[stage]",
            options: [], metrics: .none, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[time]-[name]->=15-|",
            options: [], metrics: .none, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[stage]-[time]-15-|",
            options: [], metrics: .none, views: views))
        addConstraint(NSLayoutConstraint(item: timeLabel!, attribute: .lastBaseline, relatedBy: .equal,
            toItem: nameLabel, attribute: .lastBaseline, multiplier: 1, constant: 0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dark]|", options: [],
            metrics: .none, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[dark]", options: [],
            metrics: .none, views: views))
    }
}
