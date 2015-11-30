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

class AddLocationViewController : UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    private var coordinates:CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        //Default the text fields to hidden.
        submitButton.hidden = true
        linkTextField.hidden = true
        
        // Set the delegate.
        mapView.delegate = self
        linkTextField.delegate = self
        locationTextField.delegate = self
    }
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        let userLink = linkTextField.text
        activityView.startAnimating()
        
        let restRequest = NetworkingOperations(errorPresent: false)
        restRequest.retrieveUserData({_ in
        let userInfo = restRequest.getUserPublicInfo()
        print(userInfo.getFirstName())
        })
        
        
    }
    
    // This function updates the GUI for the view. The location/search
    // elements are changed together as are the submit/link.
    func updateUI(transistion : Bool) {
        self.locationTextField.hidden = transistion
        self.searchButton.hidden = transistion
        self.submitButton.hidden = !transistion
        self.linkTextField.hidden = !transistion
    }
    
    // This function performs the search based on user input.
    @IBAction func searchButtonPress(sender: AnyObject) {
        
        // Define a CLGeocoder object.
        let reviewGeocode = CLGeocoder()
        
        // Start the activityview.
        activityView.startAnimating()
        
        // Search for the user's input.
        reviewGeocode.geocodeAddressString(self.locationTextField.text!,
            completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                
                // Once found, stop the activity view regardless.
                self.activityView.stopAnimating()
                
                // If there is an error alert the user. If not pick the first
                // location as we want to trust Apple in terms of the results.
                if (error != nil) {
                    print("Error \(error!)")
                } else if let placemark = placemarks?[0] {
                    
                    // Set the location based on results.
                    self.coordinates = placemark.location!.coordinate
                    
                    // Scope the mapview.
                    let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
                    let region:MKCoordinateRegion = MKCoordinateRegionMake(self.coordinates, span)
                    
                    // Create annotation.
                    let pointAnnotation:MKPointAnnotation = MKPointAnnotation()
                    pointAnnotation.coordinate = self.coordinates
                    pointAnnotation.title = "Your location"
                    
                    // Plot the annotation on the map and center the view
                    // on the newly created pin.
                    self.mapView.addAnnotation(pointAnnotation)
                    self.mapView.centerCoordinate = self.coordinates
                    self.mapView.setRegion(region, animated: true)
                    self.mapView.selectAnnotation(pointAnnotation, animated: true)
                    self.messageTextView.text = "Enter your website!"
                    
                    // Update the UI.
                    self.updateUI(true)
                }
        })
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}