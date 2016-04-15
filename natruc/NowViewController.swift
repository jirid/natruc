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
    private var timer: Timer?
    private let detailSegue = "ShowDetail"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stageView1: ProgressView!
    @IBOutlet weak var stageView2: ProgressView!
    @IBOutlet weak var stageView3: ProgressView!

    private var curItem: ProgramItem?
    private var s1Item: ProgramItem?
    private var s2Item: ProgramItem?
    private var s3Item: ProgramItem?

    //MARK: Initializers

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        deactivate()
    }

    //MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Natruc.backgroundBlue
        titleLabel.textColor = Natruc.white
        subtitleLabel.textColor = Natruc.foregroundBlue

        viewModel.dataChanged = {
            [weak self] in
            self?.update()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(NowViewController.activate),
            name: UIApplicationDidBecomeActiveNotification, object: .None)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(NowViewController.deactivate),
            name: UIApplicationWillResignActiveNotification, object: .None)
        activate()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIApplicationDidBecomeActiveNotification, object: .None)
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIApplicationWillResignActiveNotification, object: .None)
        deactivate()
    }

    @objc func activate() {
        update()
        deactivate()
        timer = Timer(interval: 10) {
            [weak self] in
            self?.update()
        }
    }

    @objc func deactivate() {
        if let t = timer {
            t.invalidate()
        }
        timer = .None
    }

    //MARK: Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == detailSegue {

            if let detail = segue.destinationViewController as? DetailViewController,
                let item = curItem {

                    detail.item = item

            } else {
                fatalError("Did not get the correct view controller type out of the storyboard.")
            }
        }
    }

    @IBAction func prepareForUnwindSegue(segue: UIStoryboardSegue) {

    }

    //MARK: Actions

    @IBAction func stage1ButtonTapped(sender: UIButton) {

        curItem = s1Item
        performSegueWithIdentifier(detailSegue, sender: .None)
    }

    @IBAction func stage2ButtonTapped(sender: UIButton) {

        curItem = s2Item
        performSegueWithIdentifier(detailSegue, sender: .None)
    }

    @IBAction func stage3ButtonTapped(sender: UIButton) {

        curItem = s3Item
        performSegueWithIdentifier(detailSegue, sender: .None)
    }

    //MARK: Private

    private func update() {
        switch viewModel.state() {
        case .NotLoaded:
            nothing()
        case .NotStarted:
            before()
        case .Progress(let s1, let s2, let s3):
            s1Item = s1
            s2Item = s2
            s3Item = s3
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

        titleLabel.text = NSLocalizedString("BeforeTitle",
            value: "The festival has not started yet",
            comment: "Title on the Now screen displayed before the start of the festival.")
        subtitleLabel.text = NSLocalizedString("BeforeSubtitle",
            value: "Looking forward to seeing you there",
            comment: "Subtitle on the now screen displayed before the start of the festival.")

        scrollView.hidden = true
        imageView.hidden = false
        imageView.image = UIImage(named: "smile")
    }

    private func progress(stage1: ProgramItem?, stage2: ProgramItem?, stage3: ProgramItem?) {

        titleLabel.text = NSLocalizedString("ProgressTitle",
            value: "Enjoy the festival!",
            comment: "Title on the Now screen displayed while the festival is in progress.")
        subtitleLabel.text = NSLocalizedString("ProgressSubtitle",
            value: "Now playing",
            comment: "Subtitle on the now screen displayed while the festival is in progress.")

        scrollView.hidden = false
        imageView.hidden = true
        imageView.image = .None

        setUpStageView(stageView1, stageItem: stage1)
        setUpStageView(stageView2, stageItem: stage2)
        setUpStageView(stageView3, stageItem: stage3)
    }

    private func setUpStageView(stageView: ProgressView, stageItem: ProgramItem?) {

        if let s = stageItem {
            stageView.setItem(s)
            stageView.hidden = false
        } else {
            stageView.hidden = true
        }
    }

    private func after() {

        titleLabel.text = NSLocalizedString("AfterTitle",
            value: "The festival is over",
            comment: "Title on the Now screen displayed after the end of the festival.")
        subtitleLabel.text = NSLocalizedString("AfterSubtitle",
            value: "Thanks for visiting!",
            comment: "Subtitle on the now screen displayed after the end of the festival.")

        scrollView.hidden = true
        imageView.hidden = false
        imageView.image = UIImage(named: "frown")
    }

}
