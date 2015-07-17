//
//  InfoViewController.swift
//  natruc
//
//  Created by Jiri Dutkevic on 04/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import UIKit

internal final class InfoViewController: UIViewController {

    //MARK: Properties

    private let viewModel = InfoViewModel()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var versionContent: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var authorsContent: UILabel!
    @IBOutlet weak var facebookLabel: UILabel!
    @IBOutlet weak var facebookContent: UILabel!
    @IBOutlet weak var webLabel: UILabel!
    @IBOutlet weak var webContent: UILabel!

    //MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = Natruc.backgroundBlue
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0

        aboutView.backgroundColor = Natruc.backgroundBlue
        aboutLabel.textColor = Natruc.yellow
        versionLabel.textColor = Natruc.white
        versionContent.textColor = Natruc.white
        authorsLabel.textColor = Natruc.white
        authorsContent.textColor = Natruc.white
        facebookLabel.textColor = Natruc.white
        facebookContent.textColor = Natruc.white
        webLabel.textColor = Natruc.white
        webContent.textColor = Natruc.white

        let version = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString")! as! String
        let build = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion")! as! String

        versionContent.text = "\(version) (\(build))"
    }

    //MARK: Actions

    @IBAction func facebookTapped(sender: UITapGestureRecognizer) {

        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/112926885403019")!)
    }

    @IBAction func webTapped(sender: UITapGestureRecognizer) {

        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.natruc.eu/")!)
    }

}

extension InfoViewController: UITableViewDataSource {

    //MARK: Table View Data Source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return viewModel.items.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let item = viewModel.items[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(item.type.rawValue) as! InfoCell
        cell.setContent(item)
        return cell
    }
}

extension InfoViewController: UITableViewDelegate {

    //MARK: Table View Delegate

    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {

        return .None
    }
}
