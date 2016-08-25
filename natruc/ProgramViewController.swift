//
//  ProgramViewController.swift
//  natruc
//
//  Created by Jiri Dutkevic on 04/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import UIKit

internal final class ProgramViewController: UIViewController {

    //MARK: Properties

    fileprivate let viewModel = Components.shared.programViewModel()
    fileprivate let detailSegue = "ShowDetail"
    fileprivate let stageCell = "stage"
    fileprivate let bandCell = "band"
    fileprivate let footerCell = "footer"

    @IBOutlet weak var tableView: UITableView!

    //MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = Natruc.backgroundBlue
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0

        viewModel.dataChanged = {
            [weak self] in
            self?.tableView.reloadData()
        }
    }

    //MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == detailSegue {

            if let detail = segue.destination as? DetailViewController {

                detail.item = viewModel.bandForIndexPath(tableView.indexPathForSelectedRow!)

            } else {
                fatalError("Did not get the correct view controller type out of the storyboard.")
            }
        }
    }

    @IBAction func prepareForUnwindSegue(_ segue: UIStoryboardSegue) {

    }
}

extension ProgramViewController: UITableViewDataSource {

    //MARK: Table View Data Source

    func numberOfSections(in tableView: UITableView) -> Int {

        return viewModel.numberOfStages()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return viewModel.numberOfBands(section) + 1
    }

    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: UITableViewCell

        if (indexPath as NSIndexPath).row == 0 {

            cell = tableView.dequeueReusableCell(withIdentifier: stageCell)!
            if let c = cell as? ProgramStageCell {

                c.setTitle(viewModel.stages[(indexPath as NSIndexPath).section])

            } else {
                fatalError("Did not get the correct cell type out of the storyboard.")
            }

        } else if (indexPath as NSIndexPath).row == viewModel.numberOfBands((indexPath as NSIndexPath).section) {

            cell = tableView.dequeueReusableCell(withIdentifier: footerCell)!

        } else {

            cell = tableView.dequeueReusableCell(withIdentifier: bandCell)!
            if let c = cell as? ProgramBandCell {

                c.setItem(viewModel.bandForIndexPath(indexPath))

            } else {
                fatalError("Did not get the correct cell type out of the storyboard.")
            }
        }

        if let c = cell as? ProgramCell {

            c.setColor(viewModel.colorForStage((indexPath as NSIndexPath).section))

        } else {
            fatalError("Did not get the correct cell type out of the storyboard.")
        }

        return cell
    }
}

extension ProgramViewController: UITableViewDelegate {

    //MARK: Table View Delegate

    func tableView(_ tableView: UITableView,
        willSelectRowAt indexPath: IndexPath) -> IndexPath? {

        return (indexPath as NSIndexPath).row == 0 || (indexPath as NSIndexPath).row == viewModel.numberOfBands((indexPath as NSIndexPath).section) ? .none : .some(indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: detailSegue, sender: .none)
    }
}
