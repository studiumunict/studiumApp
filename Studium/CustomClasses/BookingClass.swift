//
//  BookingClass.swift
//  Studium
//
//  Created by Simone Scionti on 13/12/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation
class Booking{
    let id : Int!
    let name : String!
    let data : String!
    let openData: String!
    let closeData : String!
    let closeHour : String!
    let closeMinute : String!
    var limit : Int!
    var place : String!
    var priority: Int!
    var turnHour: String!
    var turnMinute : String!
    var description : String!
    var mine : Bool!
    
    init(id: Int, name: String, data: String, openData: String, closeData: String, closeHour: String, closeMinute: String, mine: Bool){
        self.id = id
        self.name = name
        self.data = data
        self.openData = openData
        self.closeData = closeData
        self.closeHour = closeHour
        self.closeMinute = closeMinute
        self.mine = mine
    }
    
    public func completeBookingDataToDo(fromController: UIViewController?, completion : @escaping (Bool,Bool)->Void){
        let api = BackendAPI.getUniqueIstance(fromController: fromController)
        api.getBookingToDo(id: String(id)) { (error, JSONResponse) in
            if error != nil{
                completion(true,false)
                return
            }
            if let dict = JSONResponse as? [String: Any]{
                self.limit = dict["limit"] as? Int
                self.place = dict["place"] as? String
                self.priority = dict["priority"] as? Int
                self.turnHour = dict["turnHour"] as? String
                self.turnMinute = dict["turnMinute"] as? String
                self.description = dict["descr"] as? String
                completion(false,true)
                return
            }
            completion(false,false)
            //print(JSONResponse)
        }
    }
    
    
    
}
