//
//  UserInfo.swift
//  onthemap
//
//  Created by Matthew Rocco on 11/29/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import Foundation

struct UserInfo {
    
    private var firstName : String = ""
    private var lastName : String = ""
    private var ID : String = ""
    
    // Defines a setter that sets the user object. All user related
    // data is passed in during this call.
    mutating func setUserInfo (firstName : String, lastName: String, ID : String) {
        self.firstName = firstName
        self.lastName = lastName
        self.ID = ID
    }
    
    // The below functions all retrieve a specific portion of the public user
    // data object. The function return values are described in the method
    // name.

    func getFirstName() -> String {
        return firstName
    }
    
    func getLastName() -> String {
        return lastName
    }
    
    func getID() -> String {
        return ID
    }
}
