//
//  StudentInformation.swift
//  onthemap
//
//  Created by Matthew Rocco on 11/22/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

struct StudentInformation  {
    
    var studentDict : Dictionary <String, AnyObject>
    
    // Return the name of the user who dropped the pin.
    func getName() -> String {
        return (studentDict["firstName"] as? String)! + " " + (studentDict["lastName"] as? String)!
    }
    
    // Return the link that the user dropped.
    func getLink() -> String {
        return (studentDict["mediaURL"] as? String)!
    }
    
    // Return the location of the pin.
    func getLocaton() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: (studentDict["latitude"] as? Double)!, longitude: (studentDict["longitude"] as? Double)!)
    }
    
}
