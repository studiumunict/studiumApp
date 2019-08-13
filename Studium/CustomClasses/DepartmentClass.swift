//
//  DepartmentsClass.swift
//  Studium
//
//  Created by Simone Scionti on 26/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import Foundation
class Department{
    
    var name :String!
    var code :Int!
    var id: Int!
    
    init(depName:String!, depCode:Int!, id: Int!) {
        self.name = depName
        self.code = depCode
        self.id = id
    }
    
    
}
