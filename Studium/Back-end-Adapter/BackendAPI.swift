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
        request.licenseKey = "PPezHrHEFSTeJjlEJ9MX7PHySnjiX0yzoX/SFl3fu9hnAbzl8cUIt104fvU1khwuEQ7rXgJmQ1DOIXJRDUUjNA=="
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
                            print(responseValue)
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
    public func getMyCoursesCategories(completion: @escaping (Any?)->Void){
           let requestName = "Categoria" //"MyCourses"
           let request = startRequest()
           let session =  Session.getUniqueIstance()
           request.setValue(Student.getUniqueIstance().id , forKey: "id")
           request.requestURL(requestURL,
                           soapAction: soapActionBaseURL + requestName,
                           completeWithDictionary: { (statusCode : Int,
                               dict : [AnyHashable : Any]?) -> Void in
                               
                               let response = dict! as Dictionary
                               print(response)
                               let responseValue = self.parseResultToString(requestName: requestName, response: response)
                               if responseValue == "noSession"{
                                   print("Restoring session")
                                   session.restoreSession(completion: { (success) in
                                       if(success){
                                           self.getMyCoursesCategories() { (response) in
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
    public func getMyCourses(completion: @escaping (Any?)->Void){
        let requestName = "MyCourses"
        let request = startRequest()
        let session =  Session.getUniqueIstance()
        
       //print("ID = ***** ",Student.getUniqueIstance().id)
        request.setValue(Student.getUniqueIstance().id , forKey: "id")
        request.requestURL(requestURL,
                        soapAction: soapActionBaseURL + requestName,
                        completeWithDictionary: { (statusCode : Int,
                            dict : [AnyHashable : Any]?) -> Void in
                            
                            let response = dict! as Dictionary
                            print(response)
                            let responseValue = self.parseResultToString(requestName: requestName, response: response)
                            if responseValue == "noSession"{
                                print("Restoring session")
                                session.restoreSession(completion: { (success) in
                                    if(success){
                                        self.getMyCourses() { (response) in
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
    
    public func moveCourse(codCourse: String, newCat: String, completion: @escaping (Any?)->Void){
        let requestName = "MoveCourse"
        let request = startRequest()
        let session =  Session.getUniqueIstance()
        //Student.getUniqueIstance().codFiscale
        request.setValue(Student.getUniqueIstance().id, forKey: "id")
        request.setValue(codCourse, forKey: "code")
        request.setValue(newCat, forKey: "cat")
        request.requestURL(requestURL,
                        soapAction: soapActionBaseURL + requestName,
                        completeWithDictionary: { (statusCode : Int,
                            dict : [AnyHashable : Any]?) -> Void in
                            
                            let response = dict! as Dictionary
                            print(response)
                            let responseValue = self.parseResultToString(requestName: requestName, response: response)
                            if responseValue == "noSession"{
                                print("Restoring session")
                                session.restoreSession(completion: { (success) in
                                    if(success){
                                        self.moveCourse(codCourse: codCourse, newCat: newCat) { (response) in
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
    
    public func addCourse(codCourse: String, completion: @escaping (Any?)->Void){
        let requestName = "AddCourse"
        let request = startRequest()
        let session =  Session.getUniqueIstance()
        //Student.getUniqueIstance().codFiscale
        request.setValue(Student.getUniqueIstance().id, forKey: "user")
        request.setValue(codCourse, forKey: "course")
        request.requestURL(requestURL,
                        soapAction: soapActionBaseURL + requestName,
                        completeWithDictionary: { (statusCode : Int,
                            dict : [AnyHashable : Any]?) -> Void in
                            
                            let response = dict! as Dictionary
                            print(response)
                            let responseValue = self.parseResultToString(requestName: requestName, response: response)
                            if responseValue == "noSession"{
                                print("Restoring session")
                                session.restoreSession(completion: { (success) in
                                    if(success){
                                        self.addCourse(codCourse: codCourse) { (response) in
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
    public func deleteCourse(codCourse: String, completion: @escaping (Any?)->Void){
        let requestName = "RemoveCourse"
        let request = startRequest()
        let session =  Session.getUniqueIstance()
        //Student.getUniqueIstance().codFiscale
        request.setValue(Student.getUniqueIstance().id, forKey: "user")
        request.setValue(codCourse, forKey: "course")
        request.requestURL(requestURL,
                        soapAction: soapActionBaseURL + requestName,
                        completeWithDictionary: { (statusCode : Int,
                            dict : [AnyHashable : Any]?) -> Void in
                            
                            let response = dict! as Dictionary
                            print(response)
                            let responseValue = self.parseResultToString(requestName: requestName, response: response)
                            if responseValue == "noSession"{
                                print("Restoring session")
                                session.restoreSession(completion: { (success) in
                                    if(success){
                                        self.deleteCourse(codCourse: codCourse) { (response) in
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
    
    public func deleteCategory(idCat: String, completion: @escaping (Any?)->Void){
        let requestName = "DeleteCategory" //"MyCourses"
        let request = startRequest()
        let session =  Session.getUniqueIstance()
        //Student.getUniqueIstance().codFiscale
        request.setValue(Student.getUniqueIstance().id, forKey: "user")
        request.setValue(idCat, forKey: "id")
        request.requestURL(requestURL,
                        soapAction: soapActionBaseURL + requestName,
                        completeWithDictionary: { (statusCode : Int,
                            dict : [AnyHashable : Any]?) -> Void in
                            
                            let response = dict! as Dictionary
                            print(response)
                            let responseValue = self.parseResultToString(requestName: requestName, response: response)
                            if responseValue == "noSession"{
                                print("Restoring session")
                                session.restoreSession(completion: { (success) in
                                    if(success){
                                        self.deleteCategory(idCat: idCat) { (response) in
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
                            }
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            completion(nil)
        }
    }
    public func createCategory(catTitle: String, completion: @escaping (Any?)->Void){
        let requestName = "CreateCategory" //"MyCourses"
        let request = startRequest()
        let session =  Session.getUniqueIstance()
        print("Creo categoria cod fisc : ", Student.getUniqueIstance().codFiscale)
        request.setValue(Student.getUniqueIstance().id, forKey: "user")
        request.setValue(catTitle, forKey: "title")
        request.requestURL(requestURL,
                        soapAction: soapActionBaseURL + requestName,
                        completeWithDictionary: { (statusCode : Int,
                            dict : [AnyHashable : Any]?) -> Void in
                            
                            let response = dict! as Dictionary
                            print(response)
                            let responseValue = self.parseResultToString(requestName: requestName, response: response)
                            if responseValue == "noSession"{
                                print("Restoring session")
                                session.restoreSession(completion: { (success) in
                                    if(success){
                                        self.createCategory(catTitle: catTitle) { (response) in
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
                            }
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            completion(nil)
        }
    }
    
    public func getAvvisi(codCourse: String, completion: @escaping (Any?)->Void){
        let requestName = "Avvisi"
        let request = startRequest()
        let session =  Session.getUniqueIstance()
        request.setValue(codCourse, forKey: "course")
        request.setValue(Student.getUniqueIstance().id, forKey: "userid")
        request.requestURL(requestURL,
                        soapAction: soapActionBaseURL + requestName,
                        completeWithDictionary: { (statusCode : Int,
                            dict : [AnyHashable : Any]?) -> Void in
                            
                            let response = dict! as Dictionary
                            print(response)
                            let responseValue = self.parseResultToString(requestName: requestName, response: response)
                            if responseValue == "noSession"{
                                print("Restoring session")
                                session.restoreSession(completion: { (success) in
                                    if(success){
                                        self.getAvvisi(codCourse: codCourse) { (response) in
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
    public func getCurrentUserData(completion: @escaping (Any?)->Void){
        let requestName = "Utente"
        let request = startRequest()
        let session =  Session.getUniqueIstance()
        print("Username cf: ",session.username!)
        request.setValue(session.username! , forKey: "cf")
        request.requestURL(requestURL,
                        soapAction: soapActionBaseURL + requestName,
                        completeWithDictionary: { (statusCode : Int,
                            dict : [AnyHashable : Any]?) -> Void in
                            
                            let response = dict! as Dictionary
                            print(response)
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
                            }
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            completion(nil)
        }
    }
    
    public func getCourseDescription(codCourse: String, completion: @escaping (Any?)->Void){
        let requestName = "Description"
        let request = startRequest()
        let session =  Session.getUniqueIstance()
        request.setValue(codCourse, forKey: "course")
        //request.setValue(Student.getUniqueIstance().id, forKey: "userid")
        request.requestURL(requestURL,
                        soapAction: soapActionBaseURL + requestName,
                        completeWithDictionary: { (statusCode : Int,
                            dict : [AnyHashable : Any]?) -> Void in
                            
                            let response = dict! as Dictionary
                            print(response)
                            let responseValue = self.parseResultToString(requestName: requestName, response: response)
                            if responseValue == "noSession"{
                                print("Restoring session")
                                session.restoreSession(completion: { (success) in
                                    if(success){
                                        self.getCourseDescription(codCourse: codCourse) { (response) in
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
    
    public func getCourseDocuments(codCourse: String,path: String, completion: @escaping (Any?)->Void){
        let requestName = "Documents"
        let request = startRequest()
        let session =  Session.getUniqueIstance()
        request.setValue(codCourse, forKey: "course")
        request.setValue(path, forKey: "p")
        request.setValue(Student.getUniqueIstance().id, forKey: "userid")
        request.requestURL(requestURL,
                        soapAction: soapActionBaseURL + requestName,
                        completeWithDictionary: { (statusCode : Int,
                            dict : [AnyHashable : Any]?) -> Void in
                            
                            let response = dict! as Dictionary
                            print(response)
                            let responseValue = self.parseResultToString(requestName: requestName, response: response)
                            if responseValue == "noSession"{
                                print("Restoring session")
                                session.restoreSession(completion: { (success) in
                                    if(success){
                                        self.getCourseDocuments(codCourse: codCourse, path: path) { (response) in
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
        let result = bodyDict[requestName+"Response"] as! [String:Any]
        let responseValue = result[requestName+"Result"] as! String
        return responseValue
    }
    
}
