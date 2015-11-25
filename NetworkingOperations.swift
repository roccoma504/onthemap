//
//  NetworkingOperations.swift
//  onthemap
//
//  Created by Matthew Rocco on 11/23/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import Foundation
import UIKit

class NetworkingOperations {
    
    struct JSONOutput {
        
        var error : Bool
        var alert : UIAlertController
        
        mutating func error(alert : UIAlertController)  {
            self.error = false
            self.alert = alert
        }
    }
    
    init() {
        print ("networking object created")
    }
    
    func retrieveJSON() -> JSONOutput {
        
        // If there was an error create an error object and set the
        // error.
        let jsonError = GenerateAlerts(title: "JSON Error!",
            contents: "There was an issue connecting to parse. Check your keys")
        var jsonOutput = JSONOutput(error: false, alert: jsonError.generateAlert())
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=2")!)
        request.addValue(parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print("JSON Error")
                jsonOutput.error = true
                return
            }
            //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            self.parseJSON(data!)
        }
        task.resume()
        
        return jsonOutput
    }
    
    func parseJSON(JSON : NSData) {
        

        do {
            var json = try NSJSONSerialization.JSONObjectWithData(JSON, options: []) as! Dictionary<String, AnyObject>
            
            let studentInformation = StudentInformation(studentDictionary: json)
            
            
            
//            for _ in 0...json["results"]!.count - 1 {
//                let dictAtIndex = json.popFirst() as! Dictionary<String, AnyObject>
//                print(dictAtIndex)
                
//                let currentStudentInfo = StudentInformation(studentDictionary: dictAtIndex)
//                studentPosts.append(currentStudentInfo)
//                print(studentPosts.count)
//            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        catch {
            print("Parsing error")
        }
    }
}
