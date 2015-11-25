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
    
    var pinArray : Array <StudentPin> = []
    
    override func viewDidLoad() {
        retrieveUserData()
        mapView.delegate = self
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

            let studentInfoArray = networkingOperations.getStudentArray()
            
            var count = studentInfoArray.count - 1
            
            // Loop around every student in the array and place their pin.
            for var i = 0; i < studentInfoArray.count - 1; ++i {
                let newStudentPin = StudentPin(coordinate: studentInfoArray[i].getLocaton(),
                    title: studentInfoArray[i].getName(), subtitle: studentInfoArray[i].getLink())
                print(i)
                self.pinArray.append(newStudentPin)
            }
            self.processAnnotations(true, pin: self.pinArray)
        }
    }
    
    // This function will form the pins for display on the map.
    func formPins (infoArray : Array <StudentInformation>) {

    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("pin touched")
    }
    
    @IBAction func refresh(sender: AnyObject) {
        processAnnotations(false, pin : pinArray)
        pinArray = []
        retrieveUserData()
    }
}
