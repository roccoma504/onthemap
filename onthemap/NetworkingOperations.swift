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
    var userPublicInfo : UserInfo
    
    init(errorPresent : Bool) {
        let defaultUserPublicInfo = UserInfo()
        self.errorPresent = errorPresent
        userPublicInfo = defaultUserPublicInfo
    }
    
    // This function retrieves and parses the JSON. We use a completion
    // here as the call is async.
    func retrieveAndParseJSON(completion: (result: Bool) -> Void) {
        
        // Define the request, the API keys are pulled from the constnts.
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit="+queryAmount)!)
        request.addValue(parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("-createdAt", forHTTPHeaderField: "order")
        let session = NSURLSession.sharedSession()
        // If the request failed for some reason set the error present flag.
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                self.errorPresent = true
                return
            }
            
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
                }
                print("JSON complete")
                completion(result: true)
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
    
    // This function logs the user out of their session.
    func logout() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as [NSHTTPCookie]! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-Token")
        }
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            //print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        
        task.resume()
    }
    
    func retrieveUserData(completion: (result: Bool) -> Void) {
        
        // Define the request, the API keys are pulled from the constnts.
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/5226920848")!)
        let session = NSURLSession.sharedSession()
        // If the request failed for some reason set the error present flag.
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                self.errorPresent = true
                return
            }
            //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            do {
                let receivedData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
                
                let json = try NSJSONSerialization.JSONObjectWithData(receivedData, options: []) as! Dictionary<String, AnyObject>
                let userDict = json["user"] as! Dictionary<String, AnyObject>
                self.userPublicInfo.setUserInfo((
                    userDict["first_name"] as? String)!,
                    lastName: (userDict["last_name"] as? String)!,
                    ID:(userDict["key"] as? String)!)
                completion(result: true)
            }
            catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            catch {
                print("Parsing error")
            }
        }
        task.resume()
    }
    
    func postUserData(key : String, firstName : String, lastName : String,
        mapString : String, url : String, lat : Double, long : Double,
        completion: (result: Bool) -> Void) {
            
            var json = [String: AnyObject]()
            json["uniqueKey"] = key
            json["firstName"] = firstName
            json["lastName"] = lastName
            json["mapString"] = mapString
            json["mediaURL"] = url
            json["latitude"] = lat
            json["longitude"] = long
            
            do {
                let convertedData = try NSJSONSerialization.dataWithJSONObject(json, options: [])
                let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
                request.HTTPMethod = "POST"
                request.addValue(parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
                request.addValue(restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.HTTPBody = convertedData
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithRequest(request) { data, response, error in
                    completion(result: true)
                    if error != nil { // Handle error…
                        return
                    }
                    print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                    
                }
                task.resume()
            }
            catch {
                print("JSON conversion failed")
            }
    }
    
    
    // Returns the student array.
    func getUserPublicInfo() -> UserInfo {
        return userPublicInfo
    }
    
    // Returns the student array.
    func getStudentArray() -> Array <StudentInformation> {
        return studentInfoArray
    }
    
}

