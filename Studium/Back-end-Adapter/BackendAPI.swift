//
//  StudiumBackend.swift
//  Studium
//
//  Created by Simone Scionti on 01/08/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

//TODO: Chiedere ad Angelo come capire se si è iscritti ad un corso o meno, ed in tal caso che cosa è possibile fare quando non si è iscritti(esempio: è possibile prenotarsi ad un esame di quel corso se non si è iscritti?)

import UIKit
import SOAPEngine64
import Foundation

@objcMembers class BackendAPI: NSObject {
    private var token = "4hu_mb@r3-m1_54-pr0pr10_c@-pp1_0gg1-4ccumud@mu,_kk1-d1c1_mb@ru77u,-1u_r1cu-d1_51!!!"
    private var requestURL : String! = "http://ws1.unict.it/wscea/wsstudium/StudentService.asmx"
    private var soapActionBaseURL : String! = "http://ws1.unict.it/stdata/"
    
    private static var obj : BackendAPI!  = nil
    weak var delegate : ConnectionErrorHandlerDelegate!
    private override init(){}
    public static func getUniqueIstance(fromController: UIViewController?) -> BackendAPI{
        if(obj == nil){
            obj =  BackendAPI()
        }
        obj.delegate = fromController
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
            //self.delegate?.connectionErrorHandle(error: error)
            completion(nil)
        }
    }
    
    //normal login function
    /*public func login(username: String, password: String, academicYear: String, completion : @escaping (Error?,Bool)->Void){
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
                                completion(nil,true)
                            }
                            else{ completion(nil,false) }
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            //self.delegate?.connectionErrorHandle(error: error)
            completion(error,false)
        }
    }*/
    
    //TODO: getCourse_v2
    //Se loading è 0 , è un corso normale. Se loading è valorizzato, quello è il codice del corso di base vero, e devo usare quello (Corsi mutuati). Se active  = false inutile scaricare le cose, solo sillabys.
    
    //visibility =1: solo se l'utente è iscritto al corso posso accedere 
    
    
    //ritorna tutti i dati in una volta la nuova chiamata
    
    //valorizationCode : se è valorizzato, è la password per registrarsi al corso ( Sempre chiamata corsi)
    public func login_v2(username: String, password: String, academicYear: String, completion : @escaping (Any?, Error?)->Void){
        let requestName = "V2_Login"
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
                            let json = try? JSONSerialization.jsonObject(with: responseValue.data(using: .utf8)!, options: [])
                            print(json)
                            completion(json,nil)
                                            
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            //self.delegate?.connectionErrorHandle(error: error)
            completion(nil,error)
        }
    }
    
    public func restoreStudentSession(username: String, password: String, academicYear: String, completion : @escaping (Any?, Error?)->Void){
        let requestName = "V2_RestoreStudentSession"
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
                            let json = try? JSONSerialization.jsonObject(with: responseValue.data(using: .utf8)!, options: [])
                            print(json)
                            completion(json,nil)
                                            
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            //self.delegate?.connectionErrorHandle(error: error)
            completion(nil,error)
        }
    }
    public func restoreCASSession(username: String, password: String, academicYear: String, completion : @escaping (Any?, Error?)->Void){
           let requestName = "V2_RestoreCasSession"
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
                               let json = try? JSONSerialization.jsonObject(with: responseValue.data(using: .utf8)!, options: [])
                               print(json)
                               completion(json,nil)
                                               
                               
           }) { (error : Error?) -> Void in
               print(error ?? "Error")
               //self.delegate?.connectionErrorHandle(error: error)
               completion(nil,error)
           }
       }
    public func restoreOtherSession(username: String, password: String, academicYear: String, completion : @escaping (Any?, Error?)->Void){
        let requestName = "V2_RestoreOtherSession"
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
                            let json = try? JSONSerialization.jsonObject(with: responseValue.data(using: .utf8)!, options: [])
                            print(json)
                            completion(json,nil)
                                            
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            //self.delegate?.connectionErrorHandle(error: error)
            completion(nil,error)
        }
    }
    

    
    //test login function. Test user : username: studente1 password: studente1
    /*public func login(username: String, password: String, academicYear: String, completion : @escaping (Error?,Bool)->Void){
        let requestName = "V2_LoginTest"
        let request = startRequest()
        request.setValue(username, forKey: "username")
        let pin = PswEncryption.encode(s: password)
        request.setValue(password, forKey: "password")
        let year =  getYearFromAcademicYear(academicYear: academicYear)
        //year
        request.setValue(year, forKey: "db")
        request.setValue(token, forKey: "token")
        request.requestURL(requestURL,
                        soapAction: soapActionBaseURL + requestName,
                        completeWithDictionary: { (statusCode : Int,
                            dict : [AnyHashable : Any]?) -> Void in
                            let response :Dictionary = dict! as Dictionary
                            let responseValue = self.parseResultToString(requestName: requestName, response: response)
                            let json = try? JSONSerialization.jsonObject(with: responseValue.data(using: .utf8)!, options: [])
                            
                            let dict = json as! [String:Any]
                            print(dict)
                            
                            if dict["status"] as! String != "no" {
                                if let _ = dict["user"] as? NSNull{
                                    completion(nil,false)
                                    return
                                }
                                //save session
                                let session = Session.getUniqueIstance()
                                session.setActiveSessionParameters(username: username, encryptedPassword: pin, academicYear: academicYear)
                                completion(nil,true)
                                return
                            }
                            else{
                                completion(nil,false)
                                return
                            }
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            //self.delegate?.connectionErrorHandle(error: error)
            completion(error,false)
        }
    }*/
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
               self.delegate?.connectionErrorHandle(error: error)
               completion(nil)
           }
       }
    
    public func getMyCourses_v2(completion: @escaping (Any?)->Void){
        let requestName = "V2_GetMyCourses"
        let request = startRequest()
        let session =  Session.getUniqueIstance()
        
       // request.setValue(Student.getUniqueIstance().id , forKey: "id")
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
                                        self.getMyCourses_v2() { (response) in
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
            self.delegate?.connectionErrorHandle(error: error)
            completion(nil)
        }
    }
    
    public func getMyCourses(completion: @escaping (Any?)->Void){
        let requestName = "MyCourses"
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
                            }
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            self.delegate?.connectionErrorHandle(error: error)
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
            self.delegate?.connectionErrorHandle(error: error)
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
                                completion(responseValue)
                                //print(json)
                            }
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            self.delegate?.connectionErrorHandle(error: error)
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
                                print("responseValue:", responseValue)
                                let json = try? JSONSerialization.jsonObject(with: responseValue.data(using: .utf8)!, options: [])
                                print("json:", json)
                                completion(responseValue)
                                //print(json)
                            }
                            
        }) { (error : Error?) -> Void in
            //print(error ?? "Error")
            print("HandleError")
            self.delegate?.connectionErrorHandle(error: error)
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
            self.delegate?.connectionErrorHandle(error: error)
            completion(nil)
        }
    }
    public func createCategory(catTitle: String, completion: @escaping (Any?)->Void){
        let requestName = "CreateCategory" //"MyCourses"
        let request = startRequest()
        let session =  Session.getUniqueIstance()
        //print("Creo categoria cod fisc : ", Student.getUniqueIstance().codFiscale)
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
            self.delegate?.connectionErrorHandle(error: error)
            completion(nil)
        }
    }
    public func getAvvisi_v2(dbName: String!, completion: @escaping (Error?,Any?)->Void){
        let requestName = "V2_GetAnnouncements"
        let request = startRequest()
        let session =  Session.getUniqueIstance()
        request.setValue(dbName, forKey: "dbName")
       // request.setValue(Student.getUniqueIstance().id, forKey: "userid")
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
                                        self.getAvvisi_v2(dbName: dbName) { (error,response) in
                                            completion(error,response)
                                        }
                                    }
                                    else{
                                        let error = NSError.init(domain: "Session error", code: -1, userInfo: nil)
                                        completion(error,nil)
                                    }
                                })
                            }
                            else{
                                let json = try? JSONSerialization.jsonObject(with: responseValue.data(using: .utf8)!, options: [])
                                completion(nil,json)
                                //print(json)
                            }
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            self.delegate?.connectionErrorHandle(error: error)
            completion(error,nil)
        }
    }
    
    public func getAvvisi(codCourse: String, completion: @escaping (Error?,Any?)->Void){
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
                                        self.getAvvisi(codCourse: codCourse) { (error,response) in
                                            completion(error,response)
                                        }
                                    }
                                    else{
                                        let error = NSError.init(domain: "Session error", code: -1, userInfo: nil)
                                        completion(error,nil)
                                    }
                                })
                            }
                            else{
                                let json = try? JSONSerialization.jsonObject(with: responseValue.data(using: .utf8)!, options: [])
                                completion(nil,json)
                                //print(json)
                            }
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            self.delegate?.connectionErrorHandle(error: error)
            completion(error,nil)
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
            self.delegate?.connectionErrorHandle(error: error)
            completion(nil)
        }
    }
    
    public func getCourseDescription_v2(dbName: String, completion: @escaping (Error?,Any?)->Void){
        let requestName = "V2_GetCourseDescription"
        let request = startRequest()
        let session =  Session.getUniqueIstance()
        request.setValue(dbName, forKey: "dbName")
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
                                        self.getCourseDescription_v2(dbName: dbName) { (error,response) in
                                            completion(error,response)
                                        }
                                    }
                                    else{
                                        let error = NSError.init(domain: "Session error", code: -1, userInfo: nil)
                                        completion(error,nil)
                                    }
                                })
                            }
                            else{
                                let json = try? JSONSerialization.jsonObject(with: responseValue.data(using: .utf8)!, options: [])
                                completion(nil,json)
                                //print(json)
                            }
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            self.delegate?.connectionErrorHandle(error: error)
            completion(error,nil)
        }
    }
    public func getCourseDescription(codCourse: String, completion: @escaping (Error?,Any?)->Void){
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
                                        self.getCourseDescription(codCourse: codCourse) { (error,response) in
                                            completion(error,response)
                                        }
                                    }
                                    else{
                                        let error = NSError.init(domain: "Session error", code: -1, userInfo: nil)
                                        completion(error,nil)
                                    }
                                })
                            }
                            else{
                                let json = try? JSONSerialization.jsonObject(with: responseValue.data(using: .utf8)!, options: [])
                                completion(nil,json)
                                //print(json)
                            }
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            self.delegate?.connectionErrorHandle(error: error)
            completion(error,nil)
        }
    }
    
    
    public func getCourseContent_v2(dbName: String,course: String, completion: @escaping (Error?,Any?)->Void){
          let requestName = "V2_GetCourseContent"
          let request = startRequest()
          let session =  Session.getUniqueIstance()
          request.setValue(dbName, forKey: "dbName")
          request.setValue(course, forKey: "course")
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
                                        self.getCourseContent_v2(dbName: dbName, course: course) { (error,response) in
                                              completion(error,response)
                                          }
                                      }
                                      else{
                                          let error = NSError.init(domain: "Session error", code: -1, userInfo: nil)
                                          completion(error,nil)
                                      }
                                  })
                              }
                              else{
                                  let json = try? JSONSerialization.jsonObject(with: responseValue.data(using: .utf8)!, options: [])
                                  completion(nil,json)
                                  //print(json)
                              }
                              
          }) { (error : Error?) -> Void in
              print(error ?? "Error")
              self.delegate?.connectionErrorHandle(error: error)
              completion(error,nil)
          }
      }
    
    
    public func getCourseDocuments_v2(dbName: String,path: String, completion: @escaping (Error?,Any?)->Void){
        let requestName = "V2_GetDocuments"
        let request = startRequest()
        let session =  Session.getUniqueIstance()
        request.setValue(dbName, forKey: "dbName")
        request.setValue(path, forKey: "p")
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
                                        self.getCourseDocuments_v2(dbName: dbName, path: path) { (error,response) in
                                            completion(error,response)
                                        }
                                    }
                                    else{
                                        let error = NSError.init(domain: "Session error", code: -1, userInfo: nil)
                                        completion(error,nil)
                                    }
                                })
                            }
                            else{
                                let json = try? JSONSerialization.jsonObject(with: responseValue.data(using: .utf8)!, options: [])
                                completion(nil,json)
                                //print(json)
                            }
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            self.delegate?.connectionErrorHandle(error: error)
            completion(error,nil)
        }
    }
    public func getCourseDocuments(codCourse: String,path: String, completion: @escaping (Error?,Any?)->Void){
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
                                        self.getCourseDocuments(codCourse: codCourse, path: path) { (error,response) in
                                            completion(error,response)
                                        }
                                    }
                                    else{
                                        let error = NSError.init(domain: "Session error", code: -1, userInfo: nil)
                                        completion(error,nil)
                                    }
                                })
                            }
                            else{
                                let json = try? JSONSerialization.jsonObject(with: responseValue.data(using: .utf8)!, options: [])
                                completion(nil,json)
                                //print(json)
                            }
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            self.delegate?.connectionErrorHandle(error: error)
            completion(error,nil)
        }
    }
   /* <prenotazione>string</prenotazione>
    <limit>string</limit>
    <prio>string</prio>
    <matricola>string</matricola>
    <note>string</note>
    
    V2_GetPrenotazioneToDo*/
    public func getBookingToDo(id: String, completion: @escaping (Error?,Any?)->Void){
        let requestName = "V2_GetPrenotazioneToDo"
        let request = startRequest()
        let session =  Session.getUniqueIstance()
        request.setValue(id, forKey: "id")
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
                                        self.getBookingToDo(id: id) { (error,response) in
                                            completion(error,response)
                                        }
                                    }
                                    else{
                                        let error = NSError.init(domain: "Session error", code: -1, userInfo: nil)
                                        completion(error,nil)
                                    }
                                })
                            }
                            else{
                                let json = try? JSONSerialization.jsonObject(with: responseValue.data(using: .utf8)!, options: [])
                                completion(nil,json)
                                //print(json)
                            }
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            self.delegate?.connectionErrorHandle(error: error)
            completion(error,nil)
        }
    }
    
    
    //TODO: questa chiamata non fa il suo dovere per adesso, da chiedere ad Angelo, non c'è corrispondenza tra il sito e ciò che torna la chiamata.
    public func doBooking(id: String,limit:String,prio:String,note:String, completion: @escaping (Error?,Any?)->Void){
        let requestName = "V2_AddPrenotazione"
        let request = startRequest()
        let session =  Session.getUniqueIstance()
        request.setValue(id, forKey: "prenotazione")
        request.setValue(limit, forKey: "limit")
        request.setValue(prio, forKey: "prio")
        request.setValue(Student.getUniqueIstance().code, forKey: "matricola")
        //print(id)
        request.setValue(note, forKey: "note")
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
                                        self.doBooking(id: id, limit: limit, prio: prio, note: note, completion: { (error,response) in
                                            completion(error,response)
                                        })
                                    }
                                    else{
                                        let error = NSError.init(domain: "Session error", code: -1, userInfo: nil)
                                        completion(error,nil)
                                    }
                                })
                            }
                            else{
                                let json = try? JSONSerialization.jsonObject(with: responseValue.data(using: .utf8)!, options: [])
                                completion(nil,json)
                                //print(json)
                            }
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            self.delegate?.connectionErrorHandle(error: error)
            completion(error,nil)
        }
    }
    
    public func cancelBooking(id: String, completion: @escaping (Error?,Any?)->Void){
        let requestName = "V2_CancelPrenotazione"
        let request = startRequest()
        let session =  Session.getUniqueIstance()
        request.setValue(id, forKey: "prenotazione")
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
                                        self.cancelBooking(id: id, completion: { (error,response) in
                                            completion(error,response)
                                        })
                                    }
                                    else{
                                        let error = NSError.init(domain: "Session error", code: -1, userInfo: nil)
                                        completion(error,nil)
                                    }
                                })
                            }
                            else{
                                let json = try? JSONSerialization.jsonObject(with: responseValue.data(using: .utf8)!, options: [])
                                completion(nil,json)
                                //print(json)
                            }
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            self.delegate?.connectionErrorHandle(error: error)
            completion(error,nil)
        }
    }
    
    public func getBooking(codCourse: String, completion: @escaping (Error?,Any?)->Void){
        let requestName = "V2_GetPrenotazioni"
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
                                        self.getBooking(codCourse: codCourse) { (error,response) in
                                            completion(error,response)
                                        }
                                    }
                                    else{
                                        let error = NSError.init(domain: "Session error", code: -1, userInfo: nil)
                                        completion(error,nil)
                                    }
                                })
                            }
                            else{
                                let json = try? JSONSerialization.jsonObject(with: responseValue.data(using: .utf8)!, options: [])
                                completion(nil,json)
                                //print(json)
                            }
                            
        }) { (error : Error?) -> Void in
            print(error ?? "Error")
            self.delegate?.connectionErrorHandle(error: error)
            completion(error,nil)
        }
    }
    
    
    public func getDepartments_v2(completion: @escaping (Any?)->Void){
        let requestName = "V2_GetDepartments"
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
                                        self.getDepartments_v2(completion: { (response) in
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
            print("Errore getting dep Connection")
            self.delegate?.connectionErrorHandle(error: error)
            completion(nil)
        }
        
    }
  /*  public func getDepartments(completion: @escaping (Any?)->Void){
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
            print("Errore getting dep Connection")
            self.delegate?.connectionErrorHandle(error: error)
            completion(nil)
        }
        
    }*/
    
    public func getCDL_v2(departmentCode: String, completion: @escaping (Any?)->Void){
           let requestName = "V2_GetDepartmentContent"
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
                                           self.getCDL_v2(departmentCode: departmentCode ,completion: { (response) in
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
               print("Errore getting CDL Connection")
               self.delegate?.connectionErrorHandle(error: error)
               completion(nil)
           }
           
       }
    
    public func getCDLToSubscribe_v2(departmentCode: String, completion: @escaping (Any?)->Void){
        let requestName = "V2_GetDepartmentContentToSubscribe"
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
                                        self.getCDLToSubscribe_v2(departmentCode: departmentCode ,completion: { (response) in
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
            print("Errore getting CDL Connection")
            self.delegate?.connectionErrorHandle(error: error)
            completion(nil)
        }
        
    }
    
    
    /*public func getCDL(departmentCode: String, completion: @escaping (Any?)->Void){
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
            print("Errore getting CDL Connection")
            self.delegate?.connectionErrorHandle(error: error)
            completion(nil)
        }
        
    }*/
    
    
    /*public func getTeachingsToSubscribe(CDLCode: String, completion: @escaping (Any?)->Void){
           let requestName = "V2_GetCoursesToSubscribe"
           let request =  startRequest()
           //let code = Int(CDLCode);
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
               print("Errore getting teachings Connection")
               self.delegate?.connectionErrorHandle(error: error)
               completion(nil)
           }
       }*/
    
    public func getTeachingsToSubscribe_v2(CDLCode: String, completion: @escaping (Any?)->Void){
           let requestName = "V2_GetCoursesToSubscribe"
           let request =  startRequest()
           //let code = Int(CDLCode);
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
                                           self.getTeachingsToSubscribe_v2(CDLCode: CDLCode ,completion: { (response) in
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
               print("Errore getting teachings Connection")
               self.delegate?.connectionErrorHandle(error: error)
               completion(nil)
           }
       }
    public func getTeachings_v2(CDLCode: String, completion: @escaping (Any?)->Void){
        let requestName = "V2_GetStudiumCourses"
        let request =  startRequest()
        //let code = Int(CDLCode);
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
                                        self.getTeachings_v2(CDLCode: CDLCode ,completion: { (response) in
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
            print("Errore getting teachings Connection")
            self.delegate?.connectionErrorHandle(error: error)
            completion(nil)
        }
    }
    
    public func searchCourseToSubscribe_v2(searchedText : String, completion: @escaping (Any?)->Void){
        let requestName = "V2_FindCourseToSubscribe"
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
                                        self.searchCourseToSubscribe_v2(searchedText: searchedText ,completion: { (response) in
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
            self.delegate?.connectionErrorHandle(error: error)
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
            self.delegate?.connectionErrorHandle(error: error)
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
