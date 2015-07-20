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

    private let viewModel = Components.shared.programViewModel()
    private let detailSegue = "ShowDetail"
    private let stageCell = "stage"
    private let bandCell = "band"
    private let footerCell = "footer"

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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if let detail = segue.destinationViewController as? DetailViewController {

            detail.item = viewModel.bandForIndexPath(tableView.indexPathForSelectedRow()!)
        }
    }

    @IBAction func prepareForUnwindSegue(segue: UIStoryboardSegue) {

    }
}

extension ProgramViewController: UITableViewDataSource {

    //MARK: Table View Data Source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return viewModel.numberOfStages()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return viewModel.numberOfBands(section) + 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell: ProgramCell!

        if indexPath.row == 0 {

            let c = tableView.dequeueReusableCellWithIdentifier(stageCell) as! ProgramStageCell
            c.setTitle(viewModel.stages[indexPath.section])
            cell = c

        } else if indexPath.row == viewModel.numberOfBands(indexPath.section) {

            cell = tableView.dequeueReusableCellWithIdentifier(footerCell) as! ProgramCell

        } else {

            let c = tableView.dequeueReusableCellWithIdentifier(bandCell) as! ProgramBandCell
            c.setItem(viewModel.bandForIndexPath(indexPath))
            cell = c
        }

        cell.setColor(viewModel.colorForStage(indexPath.section))
        
        return cell
    }
}

extension ProgramViewController: UITableViewDelegate {

    //MARK: Table View Delegate

    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {

        return indexPath.row == 0 ? .None : .Some(indexPath)
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        performSegueWithIdentifier(detailSegue, sender: .None)
    }
}
