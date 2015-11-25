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
    
    var errorPresent : Bool = false;
    var studentInfoArray : Array <StudentInformation> = []
    
    
    init(errorPresent : Bool){
        self.errorPresent = errorPresent
    }
    
    // This function retrieves and parses the JSON. We use a completion
    // here as the call is async.
    func retrieveAndParseJSON(completion: (result: Bool) -> Void) {
        
        // Define the request, the API keys are pulled from the constnts.
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100")!)
        request.addValue(parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        // If the request failed for some reason set the error present flag.
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                self.errorPresent = true
                return
            }
            //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            do {
                // Retrieve and serialize the JSOn as a dictionary. What
                // we have here is a really a dictionary of dictionaries and
                // need to parse it accordingly.
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! Dictionary<String, AnyObject>
                // For each element of the dictionary (each student) create
                // a student object and retrieve the portions we need to make
                // a pin. Once finished, set the result.
                for i in 0...json["results"]!.count - 1 {
                    let singleStudentInfo = StudentInformation(studentDict:(json["results"]?.objectAtIndex(i))! as! Dictionary<String, AnyObject>)
                    self.studentInfoArray.append(singleStudentInfo)
                    //print(self.studentInfoArray.count)
                    //print("Name - " + self.studentInfoArray[i].getName())
                    //print("link - " + self.studentInfoArray[i].getLink())
                    //print("url - " + String((self.studentInfoArray[i].getLocaton())))
                    completion(result: true)
                    
                }
                
            }
            // If there is an error returned then print it to the console.
            catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            // If there was no error returned from the request but the process
            // still failed, assume there was a parsing error. (This should
            // only happen if the server returns something we're not expecting.
            catch {
                print("Parsing error")
            }
        }
        task.resume()
    }
    
    // Returns the student array.
    func getStudentArray() -> Array <StudentInformation>{
        return studentInfoArray
    }
}

