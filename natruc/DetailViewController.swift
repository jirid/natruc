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

    private var dark = false

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var webButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var youtubeButton: UIButton!

    //MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        dark = item.dark

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
            imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: imageView, attribute: .Height, multiplier: img.size.width / img.size.height, constant: 0))

        } else {

            imageView.removeFromSuperview()
            let views = ["view": view, "progress": progressView]
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-70-[progress]", options: .allZeros, metrics: .None, views: views))
            dark = false
        }

        setNeedsStatusBarAppearanceUpdate()

        progressView.setItem(item)
        textView.text = item.description
        textView.textColor = Natruc.black
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        view.setNeedsLayout()

        configureLinkButton(webButton, enabled: item.web != .None)
        configureLinkButton(facebookButton, enabled: item.facebook != .None)
        configureLinkButton(youtubeButton, enabled: item.youtube != .None)
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

    private func configureLinkButton(button: UIButton, enabled: Bool) {

        button.setTitleColor(Natruc.white, forState: .Normal)
        button.setTitleColor(Natruc.yellow, forState: .Highlighted)
        button.enabled = enabled
        button.setTitleColor(Natruc.foregroundGray, forState: .Disabled)
    }

}
