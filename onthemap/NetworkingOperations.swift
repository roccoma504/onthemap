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
    
    var studentInfoArray : Array <StudentInformation> = []
    var userPublicInfo : UserInfo
    
    private var alertPresent : Bool
    private var alertMessage : String = ""
    
    init(alertPresent : Bool) {
        let defaultUserPublicInfo = UserInfo()
        userPublicInfo = defaultUserPublicInfo
        self.alertPresent = alertPresent
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
                // Set the alert flag high and set the message.
                self.alertPresent = true
                self.alertMessage = "There was an error retrieving the student data from Parse, check your connection."
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
            }
                // If there is an error returned then print it to the console.
            catch let error as NSError {
                self.alertPresent = true
                self.alertMessage = "The data retrieved was in an unexpected format. Please try again."
            }
                // If there was no error returned from the request but the process
                // still failed, assume there was a parsing error. (This should
                // only happen if the server returns something we're not expecting.
            catch {
                self.alertPresent = true
                self.alertMessage = "There was a parsing error. Please try again."
            }
            completion(result: true)
        }
        task.resume()
    }
    
    func login(userName : String, passWord : String, completion: (result: Bool) -> Void) {
        
        // Define the HTTP POST request.
        let request =
        NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(userName)\", \"password\": \"\(passWord)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        // Define the session.
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {data, response, error in
            
            // If task fails then there was a connection error.
            if error != nil {
                // Set the alert flag high and set the message.
                self.alertPresent = true
                self.alertMessage = "There doesn't appear to be an internet connection. Please check your network."
            }
                // If we could make connection then check the API message.
                // If there is a 403 error then the username or password were wrong.
                // If there is a non 403 error then alert the user that an unknown
                // error occured.
            else {
                let receivedData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
                if (NSString(data: receivedData, encoding: NSUTF8StringEncoding)!.containsString("403")) {
                    self.alertPresent = true
                    self.alertMessage = "There appears to be an issue with your username/password."
                }
                else if (NSString(data: receivedData, encoding: NSUTF8StringEncoding)!.containsString("error")) {
                    self.alertPresent = true
                    self.alertMessage = "An unknown error occured. Please try again."
                }
            }
            completion(result: true)
        }
        task.resume()
    }
    
    // This function logs the user out of their session.
    func logout(completion: (result: Bool) -> Void) {
        
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
            if error != nil {
                self.alertPresent = true
                self.alertMessage = "Connection was lost during logout. You may have been logged out incorrectly. Please check your data the next time you login."
            }
            completion(result: true)
        }
        task.resume()
    }
    
    func retrieveUserData(completion: (result: Bool) -> Void) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // Define the request, the API keys are pulled from the constnts.
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/"+appDelegate.userID)!)
        let session = NSURLSession.sharedSession()
        // If the request failed for some reason set the error present flag.
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                self.alertPresent = true
                self.alertMessage = "There was an error retrieving user public data."
                return
            }
            do {
                let receivedData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
                
                let json = try NSJSONSerialization.JSONObjectWithData(receivedData, options: []) as! Dictionary<String, AnyObject>
                let userDict = json["user"] as! Dictionary<String, AnyObject>
                self.userPublicInfo.setUserInfo((
                    userDict["first_name"] as? String)!,
                    lastName: (userDict["last_name"] as? String)!,
                    ID:(userDict["key"] as? String)!)
            }
            catch let error as NSError {
                self.alertPresent = true
                self.alertMessage = "There was a parsing error please try again."
            }
            catch {
                self.alertPresent = true
                self.alertMessage = "There was an unknown error"
            }
            completion(result: true)
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
                    if error != nil {
                        self.alertPresent = true
                        self.alertMessage = "There was an error posting data to parse. Please check your connection."
                    }
                    completion(result: true)
                }
                task.resume()
            }
            catch {
                self.alertPresent = true
                self.alertMessage = "The data posted was in an unexpected format. Please try again."
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
    
    // Returns a flag denoting if there is an alert present.
    func alertPreset() -> Bool {
        return self.alertPresent
    }
    
    func getAlert() -> String {
        return alertMessage
    }
}

