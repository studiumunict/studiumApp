//
//  Session.swift
//  Studium
//
//  Created by Simone Scionti on 12/08/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation
class Session{
    var username : String!
    var encryptedPassword : String!
    var academicYear: String!
    private var isActive: Bool!
    private static var obj : Session!
    
    private init(){
        isActive = false
    }
    public func setActiveSessionParameters(username: String, encryptedPassword: String,academicYear: String){
        self.username = username
        self.academicYear = academicYear
        self.encryptedPassword = encryptedPassword
        isActive = true
    }
   
    public static func getUniqueIstance() -> Session{
        if obj == nil{
            obj =  Session()
        }
        return obj
    }
    
    public func restoreSession(completion: @escaping (Bool) -> Void){
        if isActive == false {
            completion(false)
            return 
        }
        let api = BackendAPI.getUniqueIstance()
        api.login(username: username, password: PswEncryption.decode(str: encryptedPassword), academicYear: academicYear) { (success) in
            completion(success)
        }
    }
    
    
}
