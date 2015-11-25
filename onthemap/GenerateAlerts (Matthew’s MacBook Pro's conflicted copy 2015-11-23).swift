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
    func generateAlert(Title:String, Contents:String) -> UIAlertController
    {
        // Dispatch the alert controller on the main thread to prevent
        // the auto layout issues.
        dispatch_async(dispatch_get_main_queue(), {
            let alertController = UIAlertController(title: Title, message:
                Contents, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            return alertController
    }
}
