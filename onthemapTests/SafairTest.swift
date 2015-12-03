//
//  SafariTest.swift
//  onthemap
//
//  Created by Matthew Rocco on 12/2/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import Foundation
import XCTest
@testable import onthemap

class SafariTest : XCTestCase {
    
    func testPage() {
        let testPage = SafariObject()
        testPage.openPage("www.google.com")
    }
}
