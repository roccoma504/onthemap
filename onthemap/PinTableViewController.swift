//
//  PinTableViewController.swift
//  onthemap
//
//  Created by Matthew Rocco on 11/25/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import Foundation
import UIKit

class PinTableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    // Define the cell identifier for filling the table cells.
    private let textCellIdentifier = "tableCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // When the view appears we want to set up the view. Because the view is not
    // unloaded when switching between tabs we need to do this here instead of
    // viewDidLoad.
    override func viewDidAppear(animated: Bool) {

    }
    
    //#MARK UITable subprograms
    
    // Defines the number of cells in the section, this scales depending on
    // the number of memes.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    // Define the cell.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        return cell
    }
    
    // When the cell is chosen segue to the detil view.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
}
