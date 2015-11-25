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
    
    private var firstName : String
    private var lastName : String
    private var link : NSURL
    private var location : CLLocationCoordinate2D
    
    func getStudentInformation() -> StudentInformation {
        return self
    }
    
}
