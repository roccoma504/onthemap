//
//  StudentInfoTest.swift
//  onthemap
//
//  Created by Matthew Rocco on 12/2/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import Foundation
import XCTest
import MapKit
@testable import onthemap

class StudentInfoTests : XCTestCase {
    
    func testGetters() {
        
        let location = CLLocationCoordinate2D(latitude: 0.0, longitude : 0.0)
        
        var testDirectory = [String: AnyObject]()
        testDirectory["firstName"] = "first"
        testDirectory["lastName"] = "last"
        testDirectory["mediaURL"] = "www.google.com"
        testDirectory["latitude"] = location.latitude
        testDirectory["longitude"] = location.longitude

        let studentInfo = StudentInformation(studentDict: testDirectory)
        XCTAssertEqual("first last", studentInfo.getName())
        XCTAssertEqual("www.google.com", studentInfo.getLink())
        XCTAssertEqual(location.latitude, studentInfo.getLocaton().latitude)
        XCTAssertEqual(location.longitude, studentInfo.getLocaton().longitude)


    }
}
