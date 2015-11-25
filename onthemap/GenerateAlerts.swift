//
//  GenerateAlerts.swift
//  onthemap
//
//  Created by Matthew Rocco on 11/23/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import Foundation
import UIKit

struct GenerateAlerts {
    
    // Alert object attribtues.
    let title : String
    let contents : String
    
    init (title:String, contents:String) {
        self.title = title
        self.contents = contents
    }
    
    // Generate an alert and return it to the client.
    func generateAlert() -> UIAlertController
    {
            let alertController = UIAlertController(title: self.title, message:
                self.contents, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            return alertController
    }
}
