//
//  StudentPinTest.swift
//  onthemap
//
//  Created by Matthew Rocco on 12/2/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import Foundation
import MapKit
import XCTest
@testable import onthemap

class StudentPinTest : XCTestCase {
    
    func testPin() {
        let location = CLLocationCoordinate2D(latitude: 0.0, longitude : 0.0)
        let testPin = StudentPin(coordinate: location, title: "title", subtitle: "substring")
        XCTAssertEqual("title",testPin.getPin().title)
        XCTAssertEqual("substring",testPin.getPin().subtitle)
        XCTAssertEqual(0.0,testPin.getPin().coordinate.latitude)
        XCTAssertEqual(0.0,testPin.getPin().coordinate.longitude)
    }
}
