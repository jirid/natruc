//
//  NowViewController.swift
//  natruc
//
//  Created by Jiri Dutkevic on 04/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import UIKit

internal final class NowViewController: UIViewController {

    //MARK: Properties

    private let viewModel = Components.shared.nowViewModel()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stageView1: ProgressView!
    @IBOutlet weak var stageView2: ProgressView!
    @IBOutlet weak var stageView3: ProgressView!

    //MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Natruc.backgroundBlue
        titleLabel.textColor = Natruc.white
        subtitleLabel.textColor = Natruc.foregroundBlue

        update()

        viewModel.dataChanged = {
            [weak self] in
            self?.update()
        }
    }

    //MARK: Private

    private func update() {
        switch viewModel.state() {
        case .NotLoaded:
            nothing()
        case .NotStarted:
            before()
        case .Progress(let s1, let s2, let s3):
            progress(s1, stage2: s2, stage3: s3)
        case .Ended:
            after()
        }
    }

    private func nothing() {

        titleLabel.text = ""
        subtitleLabel.text = ""
        scrollView.hidden = true
        imageView.hidden = true
    }

    private func before() {

        titleLabel.text = NSLocalizedString("BeforeTitle", value: "The festival has not started yet", comment: "Title on the Now screen displayed before the start of the festival.")
        subtitleLabel.text = NSLocalizedString("BeforeSubtitle", value: "Looking forward to seeing you there", comment: "Subtitle on the now screen displayed before the start of the festival.")

        scrollView.hidden = true
        imageView.hidden = false
        imageView.image = UIImage(named: "smile")
    }

    private func progress(stage1: ProgramItem?, stage2: ProgramItem?, stage3: ProgramItem?) {

        titleLabel.text = NSLocalizedString("ProgressTitle", value: "Enjoy the festival!", comment: "Title on the Now screen displayed while the festival is in progress.")
        subtitleLabel.text = NSLocalizedString("ProgressSubtitle", value: "Now playing", comment: "Subtitle on the now screen displayed while the festival is in progress.")

        scrollView.hidden = false
        imageView.hidden = true
        imageView.image = .None

        if let s = stage1 {
            stageView1.setItem(s)
            stageView1.hidden = false
        } else {
            stageView1.hidden = true
        }

        if let s = stage2 {
            stageView2.setItem(s)
            stageView2.hidden = false
        } else {
            stageView2.hidden = true
        }

        if let s = stage3 {
            stageView3.setItem(s)
            stageView3.hidden = false
        } else {
            stageView3.hidden = true
        }
    }

    private func after() {

        titleLabel.text = NSLocalizedString("AfterTitle", value: "The festival is over", comment: "Title on the Now screen displayed after the end of the festival.")
        subtitleLabel.text = NSLocalizedString("AfterSubtitle", value: "Thanks for visiting!", comment: "Subtitle on the now screen displayed after the end of the festival.")

        scrollView.hidden = true
        imageView.hidden = false
        imageView.image = UIImage(named: "frown")
    }

}
