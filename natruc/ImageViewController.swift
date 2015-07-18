//
//  ImageViewController.swift
//  natruc
//
//  Created by Jiri Dutkevic on 18/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import UIKit

internal class ImageViewController: UIViewController {

    //MARK: Properties

    internal var image: UIImage!

    private var chromeVisible = true
    private var initializing = true

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton?

    //MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Natruc.yellow

        imageView.image = image
        imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1.0, constant: image.size.width))
        imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1.0, constant: image.size.height))
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

    override func prefersStatusBarHidden() -> Bool {

        return !chromeVisible
    }

    //MARK: Actions

    @IBAction func tapped(sender: UITapGestureRecognizer) {

        toggleChrome()
    }

    @IBAction func doubleTapped(sender: UITapGestureRecognizer) {

        scrollView.setZoomScale(midScale(), animated: true)
        hideChrome()
    }

    //MARK: Private

    private func minScale() -> CGFloat {
        return min(scrollView.bounds.width / imageView.image!.size.width, scrollView.bounds.height / imageView.image!.size.height)
    }

    private func midScale() -> CGFloat {
        return max(scrollView.bounds.width / imageView.image!.size.width, scrollView.bounds.height / imageView.image!.size.height)
    }

    private func maxScale() -> CGFloat {
        return max(0.5, midScale())
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
        navigationController?.navigationBar.hidden = !chromeVisible
        closeButton?.hidden = !chromeVisible
        setNeedsStatusBarAppearanceUpdate()
    }

}

extension ImageViewController: UIScrollViewDelegate {

    //MARK: Scroll View Delegate

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
}
