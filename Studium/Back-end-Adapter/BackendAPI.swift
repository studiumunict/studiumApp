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
        let request = startRequest()
        request.setValue(token, forKey: "token")
        request.requestURL(requestURL,
                           soapAction: soapActionBaseURL + "GetYears",
                           completeWithDictionary: { (statusCode : Int,
                            dict : [AnyHashable : Any]?) -> Void in
                            let response :Dictionary = dict! as Dictionary
                            let bodyDict =  response["Body"] as! [String:Any]
                            let getYearsResult = bodyDict["GetYearsResponse"] as! [String:Any]
                            let responseValue = getYearsResult["GetYearsResult"] as! String
                            var resultArray : [String] = [String]()
                            let json = try? JSONSerialization.jsonObject(with: responseValue.data(using: .utf8)!, options: [])
                            if let array = json as? [String] {
                                for year in array {
                                    // access all objects in array
                                    let elem = Int(year)!
                                    let prev = elem-1 //2019->2018
                                    let academicYearString = String(prev) + "/" + String(elem)
                                    resultArray.append(academicYearString)
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
        let request = startRequest()
        request.setValue(username, forKey: "username")
        let pin = PswEncryption.encode(s: password)
        request.setValue(pin, forKey: "password")
        let year =  getYearFromAcademicYear(academicYear: academicYear)
        request.setValue(year, forKey: "db")
        request.setValue(token, forKey: "token")
        request.requestURL(requestURL,
                        soapAction: soapActionBaseURL + "LoginCompact",
                        completeWithDictionary: { (statusCode : Int,
                            dict : [AnyHashable : Any]?) -> Void in
                            let response :Dictionary = dict! as Dictionary
                            let bodyDict =  response["Body"] as! [String:Any]
                            let loginResult = bodyDict["LoginCompactResponse"] as! [String:Any]
                            let responseValue = loginResult["LoginCompactResult"] as! String
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
    
    public func getCurrentUserData(){
        let request = startRequest()
            request.setValue("SCNSNR98P29C351C", forKey: "cf")
        request.requestURL(requestURL,
                        soapAction: soapActionBaseURL + "Utente",
                        completeWithDictionary: { (statusCode : Int,
                            dict : [AnyHashable : Any]?) -> Void in
                            
                            let result:Dictionary = dict! as Dictionary
                            print(result)
                            print(statusCode)
                            
        }) { (error : Error?) -> Void in
            
            print(error ?? "Error")
        }
    }
    
    private func getYearFromAcademicYear(academicYear: String) -> String{
        let index = academicYear.index(academicYear.startIndex, offsetBy: 5)
        let year = String(academicYear[index...])
        return year
    }
}
