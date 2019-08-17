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
        NotificationCenter.default.removeObserver(self)
        deactivate()
    }

    //MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        dark = item.dark

        configureBackground()
        configureImageView()
        configureTextView()
        configureLinkButton(webButton, enabled: item.web != .none)
        configureLinkButton(facebookButton, enabled: item.facebook != .none)
        configureLinkButton(youtubeButton, enabled: item.youtube != .none)

        setNeedsStatusBarAppearanceUpdate()
        view.setNeedsLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
            selector: #selector(DetailViewController.activate),
            name: UIApplication.didBecomeActiveNotification, object: .none)
        NotificationCenter.default.addObserver(self,
            selector: #selector(DetailViewController.deactivate),
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if dark {
            
            return .default
            
        } else {
            
            return .lightContent
        }
    }

    //MARK: Actions

    @IBAction func webButtonTapped(_ sender: UIButton) {
        if let url = item.web {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }

    @IBAction func facebookButtonTapped(_ sender: UIButton) {
        if let url = item.facebook {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }

    @IBAction func youtubeButtonTapped(_ sender: UIButton) {
        if let url = item.youtube {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }

    //MARK: Private

    private func update() {

        progressView.setItem(item)
    }

    private func configureBackground() {

        switch item.color {
        case .blue:
            view.backgroundColor = Natruc.lightBlue
            buttonContainer.backgroundColor = Natruc.lightBlue
        case .red:
            view.backgroundColor = Natruc.lightRed
            buttonContainer.backgroundColor = Natruc.lightRed
        case .green:
            view.backgroundColor = Natruc.lightGreen
            buttonContainer.backgroundColor = Natruc.lightGreen
        }
    }

    private func configureImageView() {

        if dark {

            let image = UIImage(named: "backdark")
            backButton.setImage(image, for: UIControl.State())

        } else {

            let image = UIImage(named: "backlight")
            backButton.setImage(image, for: UIControl.State())
        }

        let tmp = (item.image?.path).flatMap {
            UIImage(contentsOfFile: $0)
        }
        if let img = tmp {

            imageView.image = img
            imageView.addConstraint(NSLayoutConstraint(item: imageView!,
                attribute: .width, relatedBy: .equal, toItem: imageView,
                attribute: .height,
                multiplier: img.size.width / img.size.height, constant: 0))

        } else {

            imageView.removeFromSuperview()
            let views = ["view": view as AnyObject, "progress": progressView as AnyObject]
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-70-[progress]",
                options: [], metrics: .none, views: views))
            dark = false
        }
    }

    private func configureTextView() {

        textView.text = item.description
        textView.textColor = Natruc.black
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.setNeedsLayout()
    }

    private func configureLinkButton(_ button: UIButton, enabled: Bool) {

        button.setTitleColor(Natruc.white, for: .normal)
        button.setTitleColor(Natruc.yellow, for: .highlighted)
        button.isEnabled = enabled
        button.setTitleColor(Natruc.foregroundGray, for: .disabled)
    }

}
