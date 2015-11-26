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
    
    private var pinArray : Array <StudentPin> = []
    private var selectedPinURL : String!
    private var studentInfoArray : Array <StudentInformation>= []
    
    override func viewDidLoad() {
        mapView.delegate = self
        retrieveUserData()
    }
    
    func pushStudentArray() {
        // Define a constant of all of the tabs embeded in the tab bar controller.
        let navControllers = self.tabBarController?.viewControllers
        
        // Define a constant of the collection view and pass the array
        // of memes to it. This table view is the first one to appear after
        // memes are added so we want to pass the data here.
        let tableNavViewController = navControllers![1] as! UINavigationController
        let tableViewController = tableNavViewController.viewControllers[0] as! PinTableViewController
        tableViewController.receivedStudentInfo = studentInfoArray
    }
    
    func processAnnotations(add : Bool, pin : Array <StudentPin>!) {
        
        if add {
            mapView.addAnnotations(pin)
            print("pins added")
            print("pin count - " + String(pin.count))
        }
        else{
            mapView.removeAnnotations(pin)
            print("pins removed")
            print("pin count - " + String(pin.count))
        }
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
        let networkingOperations = NetworkingOperations(errorPresent: false)
        networkingOperations.retrieveAndParseJSON() {_ in
            
            // Retrieve the student array.
            self.studentInfoArray = networkingOperations.getStudentArray()
            
            // Push the student array to the table. We do this here so that
            // anytime we refresh the student array the data gets pushed
            // to the table.
            self.pushStudentArray()

            // Loop around every student in the array and place their pin.
            for var i = 0; i < self.studentInfoArray.count - 1; ++i {
                let newStudentPin = StudentPin(coordinate: self.studentInfoArray[i].getLocaton(),
                    title: self.studentInfoArray[i].getName(), subtitle: self.studentInfoArray[i].getLink())
                print(i)
                self.pinArray.append(newStudentPin)
            }
            self.processAnnotations(true, pin: self.pinArray)
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

    @IBAction func logoutPress(sender: AnyObject) {
        let logoutObject = NetworkingOperations(errorPresent: false)
        logoutObject.logout()
    }
    
    
    @IBAction func refresh(sender: AnyObject) {
        processAnnotations(false, pin : pinArray)
        pinArray = []
        retrieveUserData()
    }
}
