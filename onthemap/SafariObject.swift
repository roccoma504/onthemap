//
//  SafariObject.swift
//  onthemap
//
//  Created by Matthew Rocco on 11/22/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import Foundation
import UIKit

struct SafariObject {
    func openPage(URL : String) {
        UIApplication.sharedApplication().openURL(NSURL(string:URL)!)
    }
}