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
    
    func retrieveUserData(){
        // Define an instance of networking operations.
        let parseData = NetworkingOperations(studentInfoArray: [],error: false, alert: )
                
        // If there was not an issue handle the JSON, else generate an
        // alert to the screen.
        if (parseData.error) {
            print("map view json error")
            self.presentViewController(parseData.alert, animated: true, completion: nil)
        }
        else {
            print(parseData.studentInfoArray)
            print(parseData.studentInfoArray.count)


        }
    }
    
    

    @IBAction func refresh(sender: AnyObject) {
        retrieveUserData()
    }

}
