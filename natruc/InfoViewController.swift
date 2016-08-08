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

    private let viewModel = Components.shared.infoViewModel()

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

    private let imageSegue = "ShowImage"

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

        if let version = Bundle.main
            .object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
            let build = Bundle.main
                .object(forInfoDictionaryKey: "CFBundleVersion") as? String {

                versionContent.text = "\(version) (\(build))"

        } else {

            versionContent.text = ""
        }

        viewModel.dataChanged = {
            [weak self] in
            self?.tableView.reloadData()
        }
    }

    //MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == imageSegue {

            if let c = segue.destination as? ImageViewController {

                let item = viewModel.items[(tableView.indexPathForSelectedRow! as NSIndexPath).row]
                c.image = UIImage(contentsOfFile: item.content)

            } else {
                fatalError("Did not get the correct view controller type out of the storyboard.")
            }
        }
    }

    @IBAction func prepareForUnwindSegue(_ segue: UIStoryboardSegue) {

    }

    //MARK: Actions

    @IBAction func facebookTapped(_ sender: UITapGestureRecognizer) {

        if let url = URL(string: "https://www.facebook.com/112926885403019") {

            UIApplication.shared.openURL(url)
        }
    }

    @IBAction func webTapped(_ sender: UITapGestureRecognizer) {

        UIApplication.shared.openURL(URL(string: "http://www.natruc.eu/")!)
    }

}

extension InfoViewController: UITableViewDataSource {

    //MARK: Table View Data Source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return viewModel.items.count
    }

    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = viewModel.items[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.type.rawValue)!
        if let c = cell as? InfoCell {

            c.setContent(item)

        } else {
            fatalError("Did not get the correct cell type out of the storyboard.")
        }
        return cell
    }
}

extension InfoViewController: UITableViewDelegate {

    //MARK: Table View Delegate

    func tableView(_ tableView: UITableView,
        willSelectRowAt indexPath: IndexPath) -> IndexPath? {

        let item = viewModel.items[(indexPath as NSIndexPath).row]
        if item.type == .Image {
            return indexPath
        } else {
            return .none
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: imageSegue, sender: .none)
    }
}
