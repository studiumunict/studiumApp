//
//  StudiumBackend.swift
//  Studium
//
//  Created by Simone Scionti on 01/08/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import UIKit
import SOAPEngine64
import Foundation

@objcMembers class BackendAPI: NSObject {
    private var token = "4hu_mb@r3-m1_54-pr0pr10_c@-pp1_0gg1-4ccumud@mu,_kk1-d1c1_mb@ru77u,-1u_r1cu-d1_51!!!"
    private var requestURL : String! = "http://ws1.unict.it/wscea/wsstudium/StudentService.asmx"
    private var soapActionBaseURL : String! = "http://ws1.unict.it/stdata/"
  
    private static var obj : BackendAPI!  = nil
    private override init(){}
    public static func getUniqueIstance() -> BackendAPI{
        if(obj == nil){
            obj =  BackendAPI()
        }
        return obj
    }
    
    private func startRequest() -> SOAPEngine{
        var request : SOAPEngine!
        request = SOAPEngine()
        request.userAgent = "SOAPEngine"
        request.actionNamespaceSlash = true
        request.responseHeader = true // use only for non standard MS-SOAP service
        request.version = SOAPVersion.VERSION_1_1
        return request
    }

    
    public func getYears(completion: @escaping ([String]?) -> Void){
        let requestName = "GetYears"
        let request = startRequest()
        request.setValue(token, forKey: "token")
        request.requestURL(requestURL,
                           soapAction: soapActionBaseURL + requestName,
                           completeWithDictionary: { (statusCode : Int,
                            dict : [AnyHashable : Any]?) -> Void in
                            let response :Dictionary = dict! as Dictionary
                            let responseValue = self.parseResultToString(requestName: requestName, response: response)
                            var resultArray : [String] = [String]()
                            let json = try? JSONSerialization.jsonObject(with: responseValue.data(using: .utf8)!, options: [])
                            if let years = json as? [String] {
                                var i = years.count-1
                                while(i >= 0){
                                    let year = years[i]
                                    let elem = Int(year)!
                                    let prev = elem-1 //2019->2018
                                    let academicYearString = String(prev) + "/" + String(elem)
                                    resultArray.append(academicYearString)
                                    i-=1
                                }
                                completion(resultArray)
                            }
                            else{
                                completion(nil)
                            }
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            completion(nil)
        }
    }
    
    public func login(username: String, password: String, academicYear: String, completion : @escaping (Bool)->Void){
        let requestName = "LoginCompact"
        let request = startRequest()
        request.setValue(username, forKey: "username")
        let pin = PswEncryption.encode(s: password)
        request.setValue(pin, forKey: "password")
        let year =  getYearFromAcademicYear(academicYear: academicYear)
        request.setValue(year, forKey: "db")
        request.setValue(token, forKey: "token")
        request.requestURL(requestURL,
                        soapAction: soapActionBaseURL + requestName,
                        completeWithDictionary: { (statusCode : Int,
                            dict : [AnyHashable : Any]?) -> Void in
                            let response :Dictionary = dict! as Dictionary
                            let responseValue = self.parseResultToString(requestName: requestName, response: response)
                            if responseValue == "1" {
                                //save session
                                let session = Session.getUniqueIstance()
                                session.setActiveSessionParameters(username: username, encryptedPassword: pin, academicYear: academicYear)
                                completion(true)
                            }
                            else{ completion(false) }
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            completion(false)
        }
    }
    
    public func getCurrentUserData(completion: @escaping (Any?)->Void){
        let requestName = "Utente"
        let request = startRequest()
        let session =  Session.getUniqueIstance()
        request.setValue(session.username , forKey: "cf")
        request.requestURL(requestURL,
                        soapAction: soapActionBaseURL + requestName,
                        completeWithDictionary: { (statusCode : Int,
                            dict : [AnyHashable : Any]?) -> Void in
                            let response = dict! as Dictionary
                            let responseValue = self.parseResultToString(requestName: requestName, response: response)
                            if responseValue == "noSession"{
                                print("Restoring session")
                                session.restoreSession(completion: { (success) in
                                    if(success){
                                        self.getCurrentUserData() { (response) in
                                            completion(response)
                                        }
                                    }
                                    else{
                                        completion(nil)
                                    }
                                })
                            }
                            else{
                                let json = try? JSONSerialization.jsonObject(with: responseValue.data(using: .utf8)!, options: [])
                                completion(json)
                                //print(json)
                            }
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            completion(nil)
        }
    }
    
    public func getDepartments(completion: @escaping (Any?)->Void){
        let requestName = "Father"
        let request =  startRequest()
        request.requestURL(requestURL,
                           soapAction: soapActionBaseURL + requestName,
                           completeWithDictionary: { (statusCode : Int,
                            dict : [AnyHashable : Any]?) -> Void in
                            let response = dict! as Dictionary
                            let responseValue = self.parseResultToString(requestName: requestName, response: response)
                            if responseValue == "noSession"{
                                let session =  Session.getUniqueIstance()
                                session.restoreSession() { (success) in
                                    if success {
                                        self.getDepartments(completion: { (response) in
                                            completion(response)
                                        })
                                    }
                                    else{
                                        completion(nil)
                                    }
                                }
                            }
                            else{
                                let json = try? JSONSerialization.jsonObject(with: responseValue.data(using: .utf8)!, options: [])
                                completion(json)
                            }
                            
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            completion(nil)
        }
        
    }
    
    public func getCDL(departmentCode: String, completion: @escaping (Any?)->Void){
        let requestName = "ChildNew"
        let request =  startRequest()
        request.setValue(departmentCode, forKey: "id")
        request.requestURL(requestURL,
                           soapAction: soapActionBaseURL + requestName,
                           completeWithDictionary: { (statusCode : Int,
                            dict : [AnyHashable : Any]?) -> Void in
                            let response = dict! as Dictionary
                            let responseValue = self.parseResultToString(requestName: requestName, response: response)
                            if responseValue == "noSession"{
                                let session =  Session.getUniqueIstance()
                                session.restoreSession() { (success) in
                                    if success {
                                        self.getCDL(departmentCode: departmentCode ,completion: { (response) in
                                            completion(response)
                                        })
                                    }
                                    else{
                                        completion(nil)
                                    }
                                }
                            }
                            else{
                                let json = try? JSONSerialization.jsonObject(with: responseValue.data(using: .utf8)!, options: [])
                                completion(json)
                            }
                            
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            completion(nil)
        }
        
    }
    public func getTeachings(CDLCode: String, completion: @escaping (Any?)->Void){
        let requestName = "CoursesAdd"
        let request =  startRequest()
        request.setValue(CDLCode, forKey: "id")
        request.requestURL(requestURL,
                           soapAction: soapActionBaseURL + requestName,
                           completeWithDictionary: { (statusCode : Int,
                            dict : [AnyHashable : Any]?) -> Void in
                            let response = dict! as Dictionary
                            let responseValue = self.parseResultToString(requestName: requestName, response: response)
                            if responseValue == "noSession"{
                                let session =  Session.getUniqueIstance()
                                session.restoreSession() { (success) in
                                    if success {
                                        self.getTeachings(CDLCode: CDLCode ,completion: { (response) in
                                            completion(response)
                                        })
                                    }
                                    else{
                                        completion(nil)
                                    }
                                }
                            }
                            else{
                                let json = try? JSONSerialization.jsonObject(with: responseValue.data(using: .utf8)!, options: [])
                                completion(json)
                            }
                            
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            completion(nil)
        }
        
    }
    public func searchCourse(searchedText : String, completion: @escaping (Any?)->Void){
        let requestName = "CercaCorso"
        let request =  startRequest()
        request.setValue(searchedText, forKey: "stringa")
        request.requestURL(requestURL,
                           soapAction: soapActionBaseURL + requestName,
                           completeWithDictionary: { (statusCode : Int,
                            dict : [AnyHashable : Any]?) -> Void in
                            let response = dict! as Dictionary
                            let responseValue = self.parseResultToString(requestName: requestName, response: response)
                            if responseValue == "noSession"{
                                let session =  Session.getUniqueIstance()
                                session.restoreSession() { (success) in
                                    if success {
                                        self.searchCourse(searchedText: searchedText ,completion: { (response) in
                                            completion(response)
                                        })
                                    }
                                    else{
                                        completion(nil)
                                    }
                                }
                            }
                            else{
                                let json = try? JSONSerialization.jsonObject(with: responseValue.data(using: .utf8)!, options: [])
                                completion(json)
                            }
                            
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            completion(nil)
        }
        
    }
    
    
    private func getYearFromAcademicYear(academicYear: String) -> String{
        let index = academicYear.index(academicYear.startIndex, offsetBy: 5)
        let year = String(academicYear[index...])
        return year
    }
    
    private func parseResultToString(requestName: String, response: [AnyHashable : Any]) -> String{
        let bodyDict =  response["Body"] as! [String:Any]
        let utenteResult = bodyDict[requestName+"Response"] as! [String:Any]
        let responseValue = utenteResult[requestName+"Result"] as! String
        return responseValue
    }
    
}
