//
//  UserInfoTests.swift
//  onthemap
//
//  Created by Matthew Rocco on 11/30/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import Foundation
import XCTest
@testable import onthemap

class UserInfoTests : XCTestCase {
    
    func testGetters() {
    var testUser = UserInfo()
    testUser.setUserInfo("first", lastName: "last", ID: "1234")
        XCTAssertEqual("wrong", testUser.getFirstName())
    }
}



