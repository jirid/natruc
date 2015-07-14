//
//  ProgramViewController.swift
//  natruc
//
//  Created by Jiri Dutkevic on 04/07/15.
//  Copyright (c) 2015 Jiri Dutkevic. All rights reserved.
//

import UIKit

internal final class ProgramViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let viewModel = ProgramViewModel()
    private let detailSegue = "ShowDetail"
    private let stageCell = "stage"
    private let bandCell = "band"

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = Natruc.backgroundBlue
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if let detail = segue.destinationViewController as? DetailViewController {

            detail.item = viewModel.itemForIndexPath(tableView.indexPathForSelectedRow()!)
        }
    }

    @IBAction func prepareForUnwindSegue(segue: UIStoryboardSegue) {

    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return viewModel.numberOfSections()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return viewModel.numberOfRows(section)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell: ProgramCell!

        if (indexPath.row == 0) {

            let c = tableView.dequeueReusableCellWithIdentifier(stageCell) as! ProgramStageCell
            c.setTitle(viewModel.stages[indexPath.section])
            cell = c

        } else {

            let c = tableView.dequeueReusableCellWithIdentifier(bandCell) as! ProgramBandCell
            c.setItem(viewModel.itemForIndexPath(indexPath))
            cell = c
        }

        cell.setColor(viewModel.colorForSection(indexPath.section))

        return cell
    }

    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {

        return indexPath.row == 0 ? .None : .Some(indexPath)
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        performSegueWithIdentifier(detailSegue, sender: .None)
    }

}
