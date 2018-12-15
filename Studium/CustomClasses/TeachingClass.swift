//
//  TeachingClass.swift
//  Studium
//
//  Created by Simone Scionti on 06/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import Foundation

class Notify { //Struttura contenente il titolo, data e corpo del messaggio di un Avviso
    var date: String!
    var title: String!
    var message: String!
    
    init(){}
    
    init(date: String!, title: String!, message: String!){
        self.date = date
        self.title = title
        self.message = message
    }
}




class Teaching{
    
    var name: String!
    var code: Int!
    var signedUp : Bool! //TRUE: se sei iscritto, FALSE: altrimenti
    var looked: Bool! //TRUE: se è privata, FALSE: altrimenti
    var teacherName: String!
   
    var haveShowcase: Bool!
    var haveDocuments: Bool!
    var haveBooking: Bool!
    var descriptionText: String!
    var notifyList: [Notify]!
    var syllabusCode: String!
    
    
    init(teachingName: String, teachingCode: Int, teacherName: String, signedUp: Bool) {
        self.name = teachingName
        self.code = teachingCode
        self.teacherName = teacherName
        self.signedUp = signedUp
        notifyList = [Notify]()
    }
    
    
    func completeDataSource(haveShowcase: Bool?, syllabusCode: String?, haveDocuments: Bool?, haveBooking: Bool?, descriptionText: String?){
        
        if let val = haveShowcase {
            self.haveShowcase = val
        }
        
        if let val = syllabusCode {
            self.syllabusCode = val
        }
        
        if let val = haveDocuments {
            self.haveDocuments = val
        }
        
        if let val = haveBooking {
            self.haveBooking = val
        }
        
        if let val = descriptionText {
            self.descriptionText = val
        }
        
        notifyList = [Notify]()
    }
    
    func addNewNotify(date: String?, title: String?, message: String?){
        notifyList.append(Notify(date: date!, title: title!, message: message!))
    }
    
}

