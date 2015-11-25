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

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        retrieveUserData()
    }
    
    func retrieveUserData(){
        // Define an instance of networking operations.
        let parseData = NetworkingOperations()
                
        // If there was not an issue handle the JSON, else generate an
        // alert to the screen.
        if (parseData.retrieveJSON().error) {
            print("map view json error")
            self.presentViewController(parseData.retrieveJSON().alert, animated: true, completion: nil)
        }
        else {
            parseData.retrieveJSON()
        }
    }

    @IBAction func refresh(sender: AnyObject) {
        retrieveUserData()
    }

}
