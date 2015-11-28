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

        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue(parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"\(locationTextField.text!)\", \"mediaURL\": \"\(userLink!)\",\"latitude\": \"\(coordinates.latitude)\", \"longitude\": \"\(coordinates.longitude)\"}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            self.activityView.stopAnimating()

            if error != nil { // Handle error…
                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        task.resume()
        
    }
    
    func updateUI(transistion : Bool) {
        self.locationTextField.hidden = transistion
        self.searchButton.hidden = transistion
        self.submitButton.hidden = !transistion
        self.linkTextField.hidden = !transistion
    }
    
    
    @IBAction func searchButtonPress(sender: AnyObject) {
        
        let reviewGeocode = CLGeocoder()
        activityView.startAnimating()
        
        reviewGeocode.geocodeAddressString(self.locationTextField.text!, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            
            self.activityView.stopAnimating()
            
            // If there is an error alert the user. If not pick the first
            // location as we want to trust Apple in terms of the results.
            if (error != nil) {
                print("Error \(error!)")
            } else if let placemark = placemarks?[0] {
                
                self.coordinates = placemark.location!.coordinate
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