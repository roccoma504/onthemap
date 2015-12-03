//
//  MapViewController.swift
//  onthemap
//
//  Created by Matthew Rocco on 11/22/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class MapViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    private var pinArray : Array <StudentPin> = []
    private var selectedPinURL : String!
    private var studentInfoArray : Array <StudentInformation>= []
    
    // On load set all delegates, retrieve the user data, and start the
    // activity view.
    override func viewDidLoad() {
        mapView.delegate = self
        activityView.startAnimating()
        retrieveUserData()
    }
    
    func processAnnotations(add : Bool, pin : Array <StudentPin>!) {
        // If add is high then add the pins. If add is low, remove the pins.
        dispatch_async(dispatch_get_main_queue(),{
            if add { self.mapView.addAnnotations(pin) }
            else { self.mapView.removeAnnotations(pin) }})
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // Set up the custom bins. Add an animation, the callout, and a button.
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        pin.animatesDrop = true
        pin.canShowCallout = true
        let btn = UIButton(type: .DetailDisclosure)
        pin.rightCalloutAccessoryView = btn
        return pin
    }
    
    // This funtion will start the JSON processing.
    func retrieveUserData() {
        // Wait for the JSON parsing to be comple via the completion
        // block. Once done set the newly formed array of student
        // infos to the form pin subprogram.
        let studentData = NetworkingOperations(alertPresent : false)
        studentData.retrieveAndParseJSON() {_ in
            
            self.stopActivityView()
            
            // If the operation was successful perform processing that
            // will add student pins to the map. If unsuccessful, generate
            // the alert.
            if !studentData.alertPreset() {
                
                // Retrieve the student array.
                self.studentInfoArray = studentData.getStudentArray()
                
                // Loop around every student in the array and place their pin.
                for var i = 0; i < self.studentInfoArray.count; ++i {
                    let newStudentPin =
                    StudentPin(coordinate: self.studentInfoArray[i].getLocaton(),
                               title: self.studentInfoArray[i].getName(),
                               subtitle: self.studentInfoArray[i].getLink())
                    self.pinArray.append(newStudentPin)
                }
                self.processAnnotations(true, pin: self.pinArray)
            }
            else {
                self.showAlert(studentData.getAlert())
            }
        }
    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // If the user touches the pin, load the page in safari.
        let signUpObject = SafariObject()
        signUpObject.openPage(((annotationView.annotation?.subtitle)!)!)
    }
    
    func getStudentInfoArray() -> Array <StudentInformation> {
        return studentInfoArray
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mapToLogin" {
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
    
    // If the user hits refresh, reload the pins.
    @IBAction func refresh(sender: AnyObject) {
        processAnnotations(false, pin : pinArray)
        self.activityView.startAnimating()
        pinArray = []
        retrieveUserData()
    }
    
    // This function stops the activity view.
    func stopActivityView() {
        dispatch_async(dispatch_get_main_queue(),{
            self.activityView.stopAnimating()})
    }
}
