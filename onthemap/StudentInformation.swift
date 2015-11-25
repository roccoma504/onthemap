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
    
    
    private var studentDictionary : Dictionary <String,Any>
    
    
    // Initializer. Takes the dictionary input and parses it to
    // local variables.
    init(studentDictionary : Dictionary <String,Any>) {
        self.studentDictionary = studentDictionary
    }
    
    func processJson() {
        var fullStudentArray = InfoArray(fullStudentArray: [])
        fullStudentArray.fullStudentArray.append(studentDictionary)
        
    }
    
    // Returns the object.
    func getStudentInfo() -> StudentInformation {
        return self
    }
}
