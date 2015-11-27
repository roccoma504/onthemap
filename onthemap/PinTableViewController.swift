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
        let pinImage = UIImage(named: "pin.png")
        cell.cellLabel.text = receivedStudentInfo[row].getName()
        cell.cellImage.image = pinImage
        return cell
    }
    
    // When the cell is chosen open the link in safari
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Deselect the row so it's not highlighted when we get back.
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        // If the user touches the pin, load the page in safari.
        let signUpObject = SafariObject()
        signUpObject.openPage(receivedStudentInfo[indexPath.row].getLink())
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // When we segue back to login, log the user out.
        if segue.identifier == "tableToLogin" {
            let logoutObject = NetworkingOperations(errorPresent: false)
            logoutObject.logout()
        }
    }
    
    @IBAction func refresh(sender: AnyObject) {
    }
    
}
