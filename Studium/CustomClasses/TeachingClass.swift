//
//  TeachingClass.swift
//  Studium
//
//  Created by Simone Scionti on 06/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import Foundation

class Teaching{
    var name: String!
    var code: Int!
    var teacherName: String!
    var haveShowcase: Bool! = false
    var haveDescription: Bool! = false
    var haveDocuments: Bool! = false
    var haveBooking: Bool! = false
    var descriptionText: String! = nil
    //...
    
    init(teachingName: String, teachingCode: Int) {
        self.name = teachingName
        self.code = teachingCode
    }
    
    init(teachingName: String, teachingCode: Int, teacherName: String){
        self.name = teachingName;
        self.code = teachingCode;
        self.teacherName = teacherName;
    }
    
}
