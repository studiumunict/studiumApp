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
    var mode : String!
    private var isActive: Bool!
    private static var obj : Session!
    
    private init(){
        isActive = false
    }
    public func setActiveSessionParameters(username: String, encryptedPassword: String,academicYear: String, mode: String){
        self.username = username
        self.academicYear = academicYear
        self.encryptedPassword = encryptedPassword
        self.mode = mode
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
        if mode == "LDAP"{
            self.restoreStudentSession { (flag) in
                completion(flag)
            }
        }
        else if mode == "CAS"{
            self.restoreCASSession { (flag) in
                completion(flag)
            }
        }
        else if mode == "DB"{
            self.restoreOtherSession { (flag) in
                completion(flag)
            }
        }
        /*api.login(username: username, password: PswEncryption.decode(str: encryptedPassword), academicYear: academicYear) { (error,success) in
            completion(success)
        }*/
        //TODO:
        //chiamare funzione restoreSessionv2
    }
    
    //TODO: il restore restituisce ok oppure no, bisogna fare il controllo ed in caso tornare false nel completion.
    private func restoreStudentSession(completion: @escaping (Bool) -> Void){
        let api = BackendAPI.getUniqueIstance(fromController: nil)
        api.restoreStudentSession(username: username, password: PswEncryption.decode(str: encryptedPassword), academicYear: academicYear) { (JSONResponse, Error) in
            print(JSONResponse)
            completion(true)
        }
        
    }
    private func restoreCASSession(completion: @escaping (Bool) -> Void){
        let api = BackendAPI.getUniqueIstance(fromController: nil)
        api.restoreCASSession(username: username, password: PswEncryption.decode(str: encryptedPassword), academicYear: academicYear) { (JSONResponse, Error) in
            print(JSONResponse)
            completion(true)
        }
        
    }
    private func restoreOtherSession(completion: @escaping (Bool) -> Void){
        let api = BackendAPI.getUniqueIstance(fromController: nil)
        api.restoreOtherSession(username: username, password: PswEncryption.decode(str: encryptedPassword), academicYear: academicYear) { (JSONResponse, Error) in
            print(JSONResponse)
            completion(true)
        }
        
    }
   
    
}
