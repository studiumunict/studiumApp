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
    

    public static func buildStudent(studentJSONData: Any? = nil) -> Bool{
        if let dict =  studentJSONData as? [String: Any]{
            var phone : String!
            if dict["phone"] is NSNull || dict["phone"] as! String == ""{
                    phone = "Nessun numero telefonico specificato"
            }
            else{ phone = dict["phone"] as? String }
            if dict["id"] == nil{
                    // completion(false)
                    return false
            }
            obj = Student(id: String(dict["id"] as! Int), codFiscale: dict["username"] as? String , code: dict["officialcode"] as? String, name: dict["firstname"] as? String, surname: dict["lastname"] as? String,telNumber: phone, email: dict["email"] as? String, profileImage: UIImage.init(named: "logo"))
            
            if obj.name == nil && obj.surname == nil {
                obj.name = ""
                obj.surname = ""
            }
        }
        else{
            print("Nil student dict")
            return false
        }
        return true
    }
    public static func getUniqueIstance() -> Student{
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
