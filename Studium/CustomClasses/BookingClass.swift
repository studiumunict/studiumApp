//
//  BookingClass.swift
//  Studium
//
//  Created by Simone Scionti on 13/12/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation
class Booking : NSObject{
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
    var turnName : String!
    var turnDate : String!
    var bookingDescription : String!
    var mine : Bool!
    var selectedPriority : Int!
    var delegate : BookingDelegate!
    
    init(id: Int, name: String, data: String, openData: String, closeData: String, closeHour: String, closeMinute: String, mine: Bool, delegate: BookingDelegate){
        self.id = id
        self.name = name
        self.data = data
        self.openData = openData
        self.closeData = closeData
        self.closeHour = closeHour
        self.closeMinute = closeMinute
        self.mine = mine
        self.delegate = delegate
    }
    
    //TODO: fare una sola funzione completeBookingData che guarda se è tra mine o no, e chiama quella giusta.
    
    private func completeBookingDataToDo(fromController: UIViewController?, completion : @escaping (Bool,Bool)->Void){
        let api = BackendAPI.getUniqueIstance(fromController: fromController)
        api.getBookingToDo_v2(id: String(id)) { (error, JSONResponse) in
            if error != nil{
                completion(true,false)
                return
            }
            if let dict = JSONResponse as? [String: Any]{
                self.limit = dict["limit"] as? Int
                self.place = dict["place"] as? String ?? "Non specificato"
                self.priority = dict["priority"] as? Int
                self.turnHour = dict["turnHour"] as? String ?? ""
                self.turnMinute = dict["turnMinute"] as? String ?? ""
                self.turnName = dict["turnName"] as? String ?? ""
                self.turnDate = dict["turnDate"] as? String ?? ""
                self.bookingDescription = dict["descr"] as? String ?? "Nessuna descrizione"
                completion(false,true)
                return
            }
            completion(false,false)
        }
    }
    
    
    
    private func completeBookingDataDone(fromController: UIViewController?, completion : @escaping (Bool,Bool)->Void){
        
        //print("id:", id)
        let api = BackendAPI.getUniqueIstance(fromController: fromController)
        api.getBookingDone_v2(id: String(id)) { (error, JSONResponse) in
            if error != nil{
                completion(true,false)
                return
            }
            if let dict = JSONResponse as? [String: Any]{
                self.limit = dict["limit"] as? Int
                self.place = dict["place"] as? String ?? "Non specificato"
                self.priority = dict["priority"] as? Int
                self.selectedPriority = dict["mypriority"] as? Int //TODO : check from result dict
                self.turnHour = dict["turnHour"] as? String ?? ""
                self.turnMinute = dict["turnMinute"] as? String ?? ""
                self.turnName = dict["turnName"] as? String ?? ""
                self.turnDate = dict["turnDate"] as? String ?? ""
                self.bookingDescription = dict["descr"] as? String ?? "Nessuna descrizione"
                completion(false,true)
                return
            }
            completion(false,false)
        }
    }
    
    public func completeBookingData(fromController: UIViewController?, completion : @escaping (Bool,Bool)->Void){
        if self.mine {
            completeBookingDataToDo(fromController: fromController) { (errorFlag, dictFlag) in
                completion(errorFlag,dictFlag)
            }
        }
        else{
            completeBookingDataToDo(fromController: fromController) { (errorFlag, dictFlag) in
                completion(errorFlag,dictFlag)
            }
        }
    }
    
    public func canDefinePriority()-> Bool{
        if priority == 0{ return false }
        return true
    }
    public func isMultiTurn()->Bool{
        if limit == 1 { return true }
        return false
    }
    public func setSelectedPriority(prio: Int){
        self.selectedPriority = prio
    }
    
    public func requestBooking(errorHandler: UIViewController, selectedPriority: Int = 1, notes: String, completion : @escaping (Bool)->Void){
        setSelectedPriority(value: selectedPriority)
        let api = BackendAPI.getUniqueIstance(fromController: errorHandler)
        print("id: ", id, "limit", limit, "selectedPriority:", selectedPriority)
        
        api.doBooking_v2(id: String(id), limit: String(limit), prio: String(selectedPriority), note: notes) { (error, JSONResponse) in
            //print(JSONResponse)
            if let dict =  JSONResponse as? [String: Any]{
                //take data from dict and save in this booking
                if let d = self.delegate{
                    d.bookingConfirmed(booking: self)
                }
                completion(true)
            }
            else{
                completion(false)
            }
            
            //print(JSONResponse)
            //controlla il risultato, se tutto è andato bene prosegui sennò fai comparire alert di errore
            //fai comparire un alert che indica che la prenotazione è confermata
            /*self.bookingPageController.teaching.refreshBooking { (flag) in
                self.bookingPageController.bookingTableView.reloadData()
            }*/
            
            //richiamare prenotazione done
            //prendere i dati del turno stabilito dal server e mostrarli
            
        }
    }
    public func cancelBooking(errorHandler: UIViewController, completion : @escaping (Bool)->Void){
        let api = BackendAPI.getUniqueIstance(fromController: errorHandler)
        api.cancelBooking_v2(id: String(id), completion: { (error, JSONResponse) in
            if error == nil{
                if let d = self.delegate{
                    d.bookingCancelled(booking: self)
                }
                completion(true)
            }
            else{
                completion(false)
            }
            
            //TODO:
            //print(JSONResponse)
            //controlla il risultato, se tutto è andato bene prosegui sennò fai comparire alert di errore
            //fai comparire un alert che indica che la prenotazione è confermata
            /*self.bookingPageController.teaching.refreshBooking { (flag) in
                self.bookingPageController.bookingTableView.reloadData()
            }*/
            
            //richiamare prenotazione done
            //prendere i dati del turno stabilito dal server e mostrarli
            
        })
    }
    private func setSelectedPriority(value: Int){
            selectedPriority = 1 - value
    }
    
    public func isLate()-> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let openDateString = openData + " " + "00:00"
        let closeDateString = closeData + " " + closeHour + ":" + closeMinute
        let openDate = dateFormatter.date(from: openDateString)!
        let closeDate = dateFormatter.date(from: closeDateString)!
        let currentDate = Date()
        if currentDate >= openDate && currentDate < closeDate{
            return false
        }
        return true
    }
    
}
