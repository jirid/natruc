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
        NotificationCenter.default.removeObserver(self)
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
            selector: #selector(NowViewController.activate),
            name: UIApplication.didBecomeActiveNotification, object: .none)
        NotificationCenter.default.addObserver(self,
            selector: #selector(NowViewController.deactivate),
            name: UIApplication.willResignActiveNotification, object: .none)
        activate()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self,
            name: UIApplication.didBecomeActiveNotification, object: .none)
        NotificationCenter.default.removeObserver(self,
            name: UIApplication.willResignActiveNotification, object: .none)
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
        timer = .none
    }

    //MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == detailSegue {

            if let detail = segue.destination as? DetailViewController,
                let item = curItem {

                    detail.item = item

            } else {
                fatalError("Did not get the correct view controller type out of the storyboard.")
            }
        }
    }

    @IBAction func prepareForUnwindSegue(_ segue: UIStoryboardSegue) {

    }

    //MARK: Actions

    @IBAction func stage1ButtonTapped(_ sender: UIButton) {

        curItem = s1Item
        performSegue(withIdentifier: detailSegue, sender: .none)
    }

    @IBAction func stage2ButtonTapped(_ sender: UIButton) {

        curItem = s2Item
        performSegue(withIdentifier: detailSegue, sender: .none)
    }

    @IBAction func stage3ButtonTapped(_ sender: UIButton) {

        curItem = s3Item
        performSegue(withIdentifier: detailSegue, sender: .none)
    }

    //MARK: Private

    private func update() {
        switch viewModel.state() {
        case .notLoaded:
            nothing()
        case .notStarted:
            before()
        case .progress(let s1, let s2, let s3):
            s1Item = s1
            s2Item = s2
            s3Item = s3
            progress(s1, stage2: s2, stage3: s3)
        case .ended:
            after()
        }
    }

    private func nothing() {

        titleLabel.text = ""
        subtitleLabel.text = ""
        scrollView.isHidden = true
        imageView.isHidden = true
    }

    private func before() {

        titleLabel.text = NSLocalizedString("BeforeTitle",
            value: "The festival has not started yet",
            comment: "Title on the Now screen displayed before the start of the festival.")
        subtitleLabel.text = NSLocalizedString("BeforeSubtitle",
            value: "Looking forward to seeing you there",
            comment: "Subtitle on the now screen displayed before the start of the festival.")

        scrollView.isHidden = true
        imageView.isHidden = false
        imageView.image = UIImage(named: "smile")
    }

    private func progress(_ stage1: ProgramItem?, stage2: ProgramItem?, stage3: ProgramItem?) {

        titleLabel.text = NSLocalizedString("ProgressTitle",
            value: "Enjoy the festival!",
            comment: "Title on the Now screen displayed while the festival is in progress.")
        subtitleLabel.text = NSLocalizedString("ProgressSubtitle",
            value: "Now playing",
            comment: "Subtitle on the now screen displayed while the festival is in progress.")

        scrollView.isHidden = false
        imageView.isHidden = true
        imageView.image = .none

        setUpStageView(stageView1, stageItem: stage1)
        setUpStageView(stageView2, stageItem: stage2)
        setUpStageView(stageView3, stageItem: stage3)
    }

    private func setUpStageView(_ stageView: ProgressView, stageItem: ProgramItem?) {

        if let s = stageItem {
            stageView.setItem(s)
            stageView.isHidden = false
        } else {
            stageView.isHidden = true
        }
    }

    private func after() {

        titleLabel.text = NSLocalizedString("AfterTitle",
            value: "The festival is over",
            comment: "Title on the Now screen displayed after the end of the festival.")
        subtitleLabel.text = NSLocalizedString("AfterSubtitle",
            value: "Thanks for visiting!",
            comment: "Subtitle on the now screen displayed after the end of the festival.")

        scrollView.isHidden = true
        imageView.isHidden = false
        imageView.image = UIImage(named: "frown")
    }

}
