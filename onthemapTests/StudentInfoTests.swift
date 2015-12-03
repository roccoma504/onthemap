//
//  StudentInfoTest.swift
//  onthemap
//
//  Created by Matthew Rocco on 12/2/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import Foundation
import XCTest
@testable import onthemap

class StudentInfoTests : XCTestCase {
    
    func testGetters() {
        
        var testDirectory = [String: AnyObject]()
        testDirectory["firstName"] = "first"
        testDirectory["lastName"] = "last"
        
        let studentInfo = StudentInformation(studentDict: testDirectory)
        XCTAssertEqual("first last", studentInfo.getName())
    }
}
