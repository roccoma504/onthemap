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
    
    override func viewDidLoad() {
        retrieveUserData()
        mapView.delegate = self
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
            self.formPins(networkingOperations.getStudentArray())
        }
    }
    
    // This function will form the pins for display on the map.
    func formPins (infoArray : Array <StudentInformation>) {
        
        // Loop around every student in the array and place their pin.
        for i in 0...infoArray.count - 1 {
            let newStudentPin = StudentPin(coordinate: infoArray[i].getLocaton(),
                title: infoArray[i].getName(), subtitle: infoArray[i].getLink())
            mapView.addAnnotation(newStudentPin)
            print(i)
        }
    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("pin touched")
    }
    
    @IBAction func refresh(sender: AnyObject) {
        retrieveUserData()
    }
    
}
