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
    
    // Tableview outlet.
    @IBOutlet weak var tableView: UITableView!
    
    // Define the cell identifier for filling the table cells.
    private let textCellIdentifier = "tableCell"
    
    var receivedStudentInfo : Array <StudentInformation>!
    
    override func viewDidAppear(animated: Bool) {
        // Setup the tableview.
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //#MARK UITable subprograms
    
    // Defines the number of cells in the section, this scales depending on
    // the number of memes.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receivedStudentInfo.count
    }
    
    // Define the cell.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! StudentTableCell
        let row = indexPath.row
        cell.cellLabel.text = receivedStudentInfo[row].getName()
        return cell
    }
    
    // When the cell is chosen segue to the detil view.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tableToLogin" {
            let logoutObject = NetworkingOperations(errorPresent: false)
            logoutObject.logout()
        }
    }
    
    @IBAction func refresh(sender: AnyObject) {
    }
    
}
