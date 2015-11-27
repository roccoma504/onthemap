//
//  AddLocationViewController.swift
//  onthemap
//
//  Created by Matthew Rocco on 11/27/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class AddLocationViewController : UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var locationTextField: UITextField!
    
    override func viewDidLoad() {
        //Default the text fields to hidden.
        submitButton.hidden = true
        linkTextField.hidden = true
        
        // Set the delegate.
        mapView.delegate = self
    }
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
    }
    @IBAction func searchButtonPress(sender: AnyObject) {
        
        let reviewGeocode = CLGeocoder()
        
        reviewGeocode.geocodeAddressString(locationTextField.text!) { (AnyObject, NSError) -> Void in
            print("search complete")
        }
        
    }
}