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
    var signedUp : Bool!
    var teacherName: String!
    var haveShowcase: Bool!
    var haveDescription: Bool!
    var haveDocuments: Bool!
    var haveBooking: Bool!
    var descriptionText: String!
    //...
    
    init(teachingName: String, teachingCode: Int, teacherName: String, signedUp :Bool) {
        self.name = teachingName
        self.code = teachingCode
        self.teacherName = teacherName
        self.signedUp = signedUp
    }
    
    init(teachingName: String, teachingCode: Int, teacherName: String, haveShowcase: Bool?, haveDescription: Bool?, haveDocuments: Bool?, haveBooking: Bool?, descriptionText: String?){
        self.name = teachingName;
        self.code = teachingCode;
        self.teacherName = teacherName;
        
        if let val = haveShowcase {
            self.haveShowcase = val
        }
        
        if let val = haveDescription {
            self.haveDescription = val
        }
        
        if let val = haveDocuments {
            self.haveDocuments = val
        }
        
        if let val = haveBooking {
            self.haveBooking = val
        }
        
        if let val = descriptionText {
            self.descriptionText = val
        }
    }
    
    
    func completeDataSource(teacherName: String?, haveShowcase: Bool?, haveDescription: Bool?, haveDocuments: Bool?, haveBooking: Bool?, descriptionText: String?){
        
        if let val = teacherName {
            self.teacherName = val;
        }
        
        if let val = haveShowcase {
            self.haveShowcase = val
        }
        
        if let val = haveDescription {
            self.haveDescription = val
        }
        
        if let val = haveDocuments {
            self.haveDocuments = val
        }
        
        if let val = haveBooking {
            self.haveBooking = val
        }
        
        if let val = descriptionText {
            self.descriptionText = val
        }
    }
    
    
    
}

