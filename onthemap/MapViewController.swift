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
        print("form pin " + String(infoArray.count))
        print("form pin " + String(infoArray[0]))
        
        for i in 0...infoArray.count {
            let mapNotation = MKAnnotation(
            mapView.addAnnotation(mapNotation)
        }
    }
    
    @IBAction func refresh(sender: AnyObject) {
        retrieveUserData()
    }

}
