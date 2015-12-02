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
    private var location:String!
    
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
        activityView.startAnimating()
        
        let restRequest = NetworkingOperations(alertPresent : false)
        restRequest.retrieveUserData({_ in
            let userInfo = restRequest.getUserPublicInfo()
            restRequest.postUserData(userInfo.getID(), firstName: userInfo.getFirstName(), lastName: userInfo.getLastName(), mapString: self.location, url: self.linkTextField.text!, lat: self.coordinates.latitude, long: self.coordinates.longitude, completion: {(result) -> Void in
                print("data posted")
                dispatch_async(dispatch_get_main_queue(),{
                    self.updateUI(false)
                    self.activityView.stopAnimating()
                    
                })

            })
        })
    }
    
    // This function updates the GUI for the view. The location/search
    // elements are changed together as are the submit/link.
    func updateUI(transistion : Bool) {
        self.locationTextField.hidden = transistion
        self.searchButton.hidden = transistion
        self.submitButton.hidden = !transistion
        self.linkTextField.hidden = !transistion
        
        if transistion {
            messageTextView.text = "Enter your website!"
        }
        else {
            messageTextView.text = "Where are you studying today???"
        }
    }
    
    // This function performs the search based on user input.
    @IBAction func searchButtonPress(sender: AnyObject) {
        
        // Define a CLGeocoder object.
        let reviewGeocode = CLGeocoder()
        
        // Start the activityview.
        activityView.startAnimating()
        
        location = self.locationTextField.text!
        
        // Search for the user's input.
        reviewGeocode.geocodeAddressString(location,
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