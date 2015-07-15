//
//  DetailViewController.swift
//  natruc
//
//  Created by Jiri Dutkevic on 04/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import UIKit

internal final class DetailViewController: UIViewController {

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

        webButton.setTitleColor(Natruc.white, forState: .Normal)
        webButton.setTitleColor(Natruc.yellow, forState: .Highlighted)
        webButton.enabled = item.web != nil
        webButton.setTitleColor(Natruc.foregroundGray, forState: .Disabled)
        facebookButton.setTitleColor(Natruc.white, forState: .Normal)
        facebookButton.setTitleColor(Natruc.yellow, forState: .Highlighted)
        facebookButton.enabled = item.facebook != nil
        facebookButton.setTitleColor(Natruc.foregroundGray, forState: .Disabled)
        youtubeButton.setTitleColor(Natruc.white, forState: .Normal)
        youtubeButton.setTitleColor(Natruc.yellow, forState: .Highlighted)
        youtubeButton.enabled = item.youtube != nil
        youtubeButton.setTitleColor(Natruc.foregroundGray, forState: .Disabled)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {

        if dark {

            return .Default

        } else {

            return .LightContent
        }
    }

    @IBAction func webButtonTapped(sender: UIButton) {
        UIApplication.sharedApplication().openURL(item.web!)
    }

    @IBAction func facebookButtonTapped(sender: UIButton) {
        UIApplication.sharedApplication().openURL(item.facebook!)
    }

    @IBAction func youtubeButtonTapped(sender: UIButton) {
        UIApplication.sharedApplication().openURL(item.youtube!)
    }


}
