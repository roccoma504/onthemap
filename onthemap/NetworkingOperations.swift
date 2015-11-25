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
    
    func retrieveAndParseJSON(completion: (result: String) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=1")!)
        request.addValue(parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                self.errorPresent = true
                return
            }
            //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! Dictionary<String, AnyObject>
                for i in 0...json["results"]!.count - 1 {
                    let singleStudentInfo = StudentInformation(studentDict:(json["results"]?.objectAtIndex(i))! as! Dictionary<String, AnyObject>)
                    self.studentInfoArray.append(singleStudentInfo)
                    print(self.studentInfoArray.count)
                    print("Name - " + self.studentInfoArray[i].getName())
                    print("link - " + self.studentInfoArray[i].getLink())
                    print("url - " + String((self.studentInfoArray[i].getLocaton())))
                    completion(result: "finished")
                    
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            catch {
                print("Parsing error")
            }
        }

    task.resume()
    }
    
    func getStudentArray() -> Array <StudentInformation>{
        return studentInfoArray
    }
}

