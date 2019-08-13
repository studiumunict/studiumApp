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
    var category: String!
    var name: String!
    var code: String!
    var signedUp : Bool! //TRUE: se sei iscritto, FALSE: altrimenti
    var looked: Bool! //TRUE: se è privata, FALSE: altrimenti
    var teacherName: String!
   
    var showcaseHTML: String!
    var haveBooking: Bool!
    var descriptionText: String! // se nel sito è formattata in html potremmo prenderci l'html e mostrarlo in una webView. A quel punto rimarrebbe formattato allo stesso modo
    var notifyList: [Notify]!
    var documentsList: [Docs]!
    var syllabusCode: String!
    
    
    init(teachingName: String, category: String, teachingCode: String, teacherName: String, signedUp: Bool) {
        self.name = teachingName
        self.code = teachingCode
        self.teacherName = teacherName
        self.signedUp = signedUp
        self.category = category
        notifyList = [Notify]()
        documentsList = [Docs]()
    }
    
    
    func completeDataSource(showcaseHTML: String?, syllabusCode: String?, haveBooking: Bool?, descriptionText: String?) {
        
        if let val = showcaseHTML {
            self.showcaseHTML = val
        }
        
        if let val = syllabusCode {
            self.syllabusCode = val
        }
        
        if let val = haveBooking {
            self.haveBooking = val
        }
        
        if let val = descriptionText {
            self.descriptionText = val
        }
        
        notifyList = [Notify]()
        documentsList = [Docs]()
    }
    
    func addNewNotify(date: String?, title: String?, message: String?) {
        notifyList.append(Notify(date: date!, title: title!, message: message!))
    }
    
    func addNewDocument(path: String, type: Docs.typeDocs) {
        documentsList.append(Docs(path: path, type: type))
    }
    func setDescriptionText(description:String){
        descriptionText = description
    }
    
}

