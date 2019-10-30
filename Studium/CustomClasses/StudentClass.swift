//
//  StudentClass.swift
//  Studium
//
//  Created by Francesco Petrosino on 08/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import Foundation

class Student{
    private static var obj : Student! //singleton
    var id: String!
    var codFiscale: String!
    var code: String!
    var name: String!
    var surname: String!
    var telNumber: String!
    var email: String!
    var profileImage: UIImage!
    
    public static func getUniqueIstance(id: String! =  nil, codFiscale: String! = nil, code: String! = nil , name: String! = nil,  surname: String! = nil, telNumber: String! = nil, email: String! = nil, profileImage: UIImage! = nil) -> Student{
           if obj == nil{
            obj = Student(id: id, codFiscale: codFiscale, code: code, name: name, surname: surname, telNumber: telNumber, email: email, profileImage: profileImage)
           }
           return obj
       }
    
    private init(id: String!, codFiscale: String!, code: String!, name: String!, surname: String!, telNumber: String!, email: String!, profileImage: UIImage!){
        self.id = id
        self.codFiscale = codFiscale
        self.code = code
        self.name = name
        self.surname = surname
        self.telNumber = telNumber
        self.email = email
        self.profileImage = profileImage
    }
    
}
