//
//  StudiumBackend.swift
//  Studium
//
//  Created by Simone Scionti on 01/08/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import UIKit
import SOAPEngine64

@objcMembers class BackendAPI: NSObject {
    private var token = "4hu_mb@r3-m1_54-pr0pr10_c@-pp1_0gg1-4ccumud@mu,_kk1-d1c1_mb@ru77u,-1u_r1cu-d1_51!!!"
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

    
    private func getYearFromAcademicYear(academicYear: String) -> String{
        let index = academicYear.index(academicYear.startIndex, offsetBy: 5)
        let year = String(academicYear[index...])
        return year
    }
    
    public func login(username: String, password: String, academicYear: String){
        let request = startRequest()
        request.setValue(username, forKey: "username")
        let pin = PswEncryption.encode(s: password)
        request.setValue(pin, forKey: "password")
        let year =  getYearFromAcademicYear(academicYear: academicYear)
        request.setValue(year, forKey: "db")
        request.setValue(token, forKey: "token")
        request.requestURL("http://ws1.unict.it/wscea/wsstudium/StudentService.asmx",
                        soapAction: "http://ws1.unict.it/stdata/LoginCompact",
                        completeWithDictionary: { (statusCode : Int,
                            dict : [AnyHashable : Any]?) -> Void in
                            
                            let result:Dictionary = dict! as Dictionary
                            print(result)
                            print(statusCode)
                            self.getUserData()
                            
        }) { (error : Error?) -> Void in
            
            print(error)
        }
    }
    
    public func getUserData(){
        let request = startRequest()
            request.setValue("SCNSNR98P29C351C", forKey: "cf")
        request.requestURL("http://ws1.unict.it//wscea/wsstudium/StudentService.asmx",
                        soapAction: "http://ws1.unict.it/stdata/Utente",
                        completeWithDictionary: { (statusCode : Int,
                            dict : [AnyHashable : Any]?) -> Void in
                            
                            let result:Dictionary = dict! as Dictionary
                            print(result)
                            print(statusCode)
                            
        }) { (error : Error?) -> Void in
            
            print(error)
        }
    }
    
    
}



