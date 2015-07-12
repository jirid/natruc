//
//  MapViewController.swift
//  natruc
//
//  Created by Jiri Dutkevic on 04/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import UIKit

internal final class MapViewController: UIViewController, UIScrollViewDelegate {

    private var chromeVisible = true
    private var initializing = true

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Natruc.yellow

        //TODO: replace with data from view model
        let path = NSBundle.mainBundle().pathForResource("map", ofType: "jpg")!
        let map = UIImage(contentsOfFile: path)!

        imageView.image = map
        imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: map.size.width))
        imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: map.size.height))
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if (initializing) {

            scrollView.maximumZoomScale = maxScale()
            scrollView.minimumZoomScale = minScale()
            scrollView.zoomScale = midScale()

            initializing = false
        }

        scrollView.flashScrollIndicators()
    }

    private func minScale() -> CGFloat {
        return min(scrollView.bounds.width / imageView.image!.size.width, scrollView.bounds.height / imageView.image!.size.height)
    }

    private func midScale() -> CGFloat {
        return max(scrollView.bounds.width / imageView.image!.size.width, scrollView.bounds.height / imageView.image!.size.height)
    }

    private func maxScale() -> CGFloat {
        return 0.5
    }

    @IBAction func tapped(sender: UITapGestureRecognizer) {

        toggleChrome()
    }
    
    @IBAction func doubleTapped(sender: UITapGestureRecognizer) {

        scrollView.setZoomScale(midScale(), animated: true)
        hideChrome()
    }

    override func prefersStatusBarHidden() -> Bool {

        return !chromeVisible
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {

        return imageView
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {

        if (!initializing) {
            hideChrome()
        }
    }

    func scrollViewDidZoom(scrollView: UIScrollView) {

        if (!initializing) {
            hideChrome()
        }
    }

    private func hideChrome() {

        if (chromeVisible) {
            chromeVisible = false
            updateChrome()
        }
    }

    private func toggleChrome() {

        chromeVisible = !chromeVisible
        updateChrome()
    }

    private func updateChrome() {

        tabBarController?.tabBar.hidden = !chromeVisible
        setNeedsStatusBarAppearanceUpdate()
    }

}
