//
//  StudentClass.swift
//  Studium
//
//  Created by Francesco Petrosino on 08/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import Foundation

class Student{
    
    var codFiscale: String!
    var code: String!
    var name: String!
    var surname: String!
    var telNumber: String!
    var email: String!
    var profileImage: UIImage!
    
    init(codFiscale: String!, code: String!, name: String!, surname: String!, telNumber: String!, email: String!, profileImage: UIImage!){
        self.codFiscale = codFiscale
        self.code = code
        self.name = name
        self.surname = surname
        self.telNumber = telNumber
        self.email = email
        self.profileImage = profileImage
    }
}
