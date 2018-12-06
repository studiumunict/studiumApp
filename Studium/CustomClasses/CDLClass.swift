//
//  CDLClass.swift
//  Studium
//
//  Created by Simone Scionti on 26/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import Foundation

class CDL{ //corsi di laurea (es. informatica l-31)
    
    var name :String!
    var code :Int!
    
    init() {
        self.name = nil
        self.code = nil
    }
    init(courseName:String!, courseCode:Int!) {
        self.name = courseName
        self.code = courseCode
    }
    
    
}
