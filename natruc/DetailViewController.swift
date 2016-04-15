//
//  DetailViewController.swift
//  natruc
//
//  Created by Jiri Dutkevic on 04/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import UIKit

internal final class DetailViewController: UIViewController {

    //MARK: Properties

    internal var item: ProgramItem!
    private var timer: Timer?

    private var dark = false

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var webButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var youtubeButton: UIButton!

    //MARK: Initializers

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        deactivate()
    }

    //MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        dark = item.dark

        configureBackground()
        configureImageView()
        configureTextView()
        configureLinkButton(webButton, enabled: item.web != .None)
        configureLinkButton(facebookButton, enabled: item.facebook != .None)
        configureLinkButton(youtubeButton, enabled: item.youtube != .None)

        setNeedsStatusBarAppearanceUpdate()
        view.setNeedsLayout()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(DetailViewController.activate),
            name: UIApplicationDidBecomeActiveNotification, object: .None)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(DetailViewController.deactivate),
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {

        if dark {

            return .Default

        } else {

            return .LightContent
        }
    }

    //MARK: Actions

    @IBAction func webButtonTapped(sender: UIButton) {
        if let url = item.web {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    @IBAction func facebookButtonTapped(sender: UIButton) {
        if let url = item.facebook {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    @IBAction func youtubeButtonTapped(sender: UIButton) {
        if let url = item.youtube {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    //MARK: Private

    private func update() {

        progressView.setItem(item)
    }

    private func configureBackground() {

        switch item.color {
        case .Blue:
            view.backgroundColor = Natruc.lightBlue
            buttonContainer.backgroundColor = Natruc.lightBlue
        case .Red:
            view.backgroundColor = Natruc.lightRed
            buttonContainer.backgroundColor = Natruc.lightRed
        case .Green:
            view.backgroundColor = Natruc.lightGreen
            buttonContainer.backgroundColor = Natruc.lightGreen
        }
    }

    private func configureImageView() {

        if dark {

            let image = UIImage(named: "backdark")
            backButton.setImage(image, forState: .Normal)

        } else {

            let image = UIImage(named: "backlight")
            backButton.setImage(image, forState: .Normal)
        }

        if let image = item.image {

            let img = UIImage(contentsOfFile: image.path!)!
            imageView.image = img
            imageView.addConstraint(NSLayoutConstraint(item: imageView,
                attribute: .Width, relatedBy: .Equal, toItem: imageView,
                attribute: .Height,
                multiplier: img.size.width / img.size.height, constant: 0))

        } else {

            imageView.removeFromSuperview()
            let views = ["view": view, "progress": progressView]
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-70-[progress]",
                options: [], metrics: .None, views: views))
            dark = false
        }
    }

    private func configureTextView() {

        textView.text = item.description
        textView.textColor = Natruc.black
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.setNeedsLayout()
    }

    private func configureLinkButton(button: UIButton, enabled: Bool) {

        button.setTitleColor(Natruc.white, forState: .Normal)
        button.setTitleColor(Natruc.yellow, forState: .Highlighted)
        button.enabled = enabled
        button.setTitleColor(Natruc.foregroundGray, forState: .Disabled)
    }

}
