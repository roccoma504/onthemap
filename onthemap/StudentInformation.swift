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
    
    private var studentDictionary : Dictionary <String,AnyObject>
    private var studentArray : Array <AnyObject>
    
    // Initializer. Takes the dictionary input and parses it to
    // local variables.
    init(studentDictionary : Dictionary <String,AnyObject>, studentArray : Array <AnyObject>) {
        self.studentDictionary = studentDictionary
        self.studentArray = studentArray
        self.parseJSON(studentDictionary)
    }
    
    mutating func parseJSON (inputJSON : Dictionary <String,AnyObject>) {
        for i in 0...inputJSON["results"]!.count - 1 {
            self.studentArray.append((inputJSON["results"]?.objectAtIndex(i))!)
        }
    
    }
    
    // Returns the object.
    func getStudentInfoArray() -> Array <AnyObject> {
        return self.studentArray
    }
}
