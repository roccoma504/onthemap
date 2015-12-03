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
    
    private var studentInfoArray = StudentInfoArray(studentInfoArray: [])
    
    override func viewDidLoad() {
        loadTableData()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //#MARK UITable subprograms
    
    // Defines the number of cells in the section, this scales depending on
    // the number of memes.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInfoArray.studentArray().count
    }
    
    // Define the cell.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! StudentTableCell
        let row = indexPath.row
        let pinImage = UIImage(named: "pin.png")
        cell.cellLabel.text = studentInfoArray.studentArray()[row].getName()
        cell.cellImage.image = pinImage
        return cell
    }
    
    // When the cell is chosen open the link in safari
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Deselect the row so it's not highlighted when we get back.
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        // If the user touches the pin, load the page in safari.
        let signUpObject = SafariObject()
        signUpObject.openPage(studentInfoArray.studentArray()[indexPath.row].getLink())
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // When we segue back to login, log the user out.
        if segue.identifier == "tableToLogin" {
            let logoutObject = NetworkingOperations(alertPresent : false)
            logoutObject.logout({ (result) -> Void in
                if logoutObject.alertPreset() {
                    print("logout error")
                }
            })
        }
    }
    
    // This subprogram generates an alert for the user based upon conditions
    // in the application. This view controller can generate two different
    // alerts so this is here only for reuseability.
    func showAlert(message : String) {
        dispatch_async(dispatch_get_main_queue(),{
            let alertController = UIAlertController(title: "Error!", message:
                message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss",
                style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController,animated: true,completion: nil)
        })
    }
    
    func loadTableData() {
        // Wait for the JSON parsing to be comple via the completion
        // block. Once done set the newly formed array of student
        // infos to the form pin subprogram.
        let studentData = NetworkingOperations(alertPresent : false)
        studentData.retrieveAndParseJSON() {_ in
            
            // If the operation was successful perform processing that
            // will add student pins to the map. If unsuccessful, generate
            // the alert.
            if !studentData.alertPreset() {
                // Retrieve the student array.
                self.studentInfoArray = studentData.getStudentArray()
                dispatch_async(dispatch_get_main_queue(),{
                    self.tableView.reloadData()
                })
            }
            else {
                self.showAlert(studentData.getAlert())
            }
        }
    }
    
    @IBAction func refresh(sender: AnyObject) {
        // Set the student info to a null array and reload the table (so it
        // empties). Then attempt to reload the data in the table.
        studentInfoArray.setStudentArray([])
        self.tableView.reloadData()
        self.loadTableData()
    }
}
