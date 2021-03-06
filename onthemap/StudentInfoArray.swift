//
//  StudentInfoArray.swift
//  onthemap
//
//  Created by Matthew Rocco on 12/2/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import Foundation

struct StudentInfoArray {
    
    private var studentInfoArray = Array <StudentInformation>()
    
    init(studentInfoArray : Array <StudentInformation>) {
        self.studentInfoArray = studentInfoArray
    }
    
    mutating func setStudentArray(studentInfoArray : Array <StudentInformation>) {
        self.studentInfoArray = studentInfoArray
    }
    
    mutating func appendNewStudent(newStudentInfo : StudentInformation) {
        self.studentInfoArray.append(newStudentInfo)
    }
    
    func studentArray() -> Array <StudentInformation> {
        return studentInfoArray
    }
}