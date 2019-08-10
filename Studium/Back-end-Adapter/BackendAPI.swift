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
    private static var obj : BackendAPI!  = nil
    
    private override init(){}
    
    public static func getUniqueIstance() -> BackendAPI{
        if(obj == nil){
            obj =  BackendAPI()
        }
        return obj
    }
    
    
    
    public func login(){
        let soap = SOAPEngine()
        soap.userAgent = "SOAPEngine"
        soap.actionNamespaceSlash = true
        soap.responseHeader = true // use only for non standard MS-SOAP service
        
        soap.setValue("SCNSNR98P29C351C", forKey: "cf")
        soap.setValue("52790461", forKey: "pin")
        soap.setValue("2018/2019", forKey: "db")
        soap.setValue("-", forKey: "token")
        soap.requestURL("https://ws1.unict.it/wscea/wsstudium/StudentService.asmx",
                        soapAction: "http://ws1.unict.it/stdata/Login",
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
