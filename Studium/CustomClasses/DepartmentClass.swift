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
    var code :String!
    var id: Int!
    
    init(depName:String!, depCode:String!, id: Int!) {
        self.name = depName
        self.code = depCode
        self.id = id
    }
    
    
}
