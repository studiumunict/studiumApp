//
//  TeachingClass.swift
//  Studium
//
//  Created by Simone Scionti on 06/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import Foundation

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
    private var isCompleted = false
    
    
    init(teachingName: String, category: String, teachingCode: String, teacherName: String, signedUp: Bool) {
        print("Init TeachingClass")
        self.name = teachingName
        self.code = teachingCode
        self.teacherName = teacherName
        self.signedUp = signedUp
        self.category = category
        notifyList = [Notify]()
        documentsList = [Docs]()
    }
    func refreshTeachingData(completion: @escaping(Bool)->Void){
        
    }
    
    func completeTeachingData(completion: @escaping (Bool)->Void){
        guard isCompleted == false else { completion(false); return}
        self.downloadNotify { (flag) in
            self.downloadDocuments { (flag1) in
                self.downloadDescription { (flag2) in
                    self.isCompleted = true
                     completion(true)
                }
            }
        }
    }
   
    private func downloadNotify(completion: @escaping (Bool)->Void){
        let api =  BackendAPI.getUniqueIstance()
        api.getAvvisi(codCourse: self.code) { (JSONResponse) in
            //print(JSONResponse)
            let JSONArray = JSONResponse as! [Any]
            for avviso in JSONArray{
                let avvisoDict = avviso as! [String: Any]
                self.notifyList.append(Notify(date: avvisoDict["data"] as? String, title: avvisoDict["title"] as? String, message: avvisoDict["content"] as? String ))
            }
            completion(true)
        }
    }
    private func downloadDocuments(completion: @escaping (Bool)->Void){
        completion(true)
    }
    
    private func downloadDescription(completion: @escaping (Bool)->Void){
        self.descriptionText = "Descrizione"
        completion(true)
    }
    
    
    
    
    
  
    
/*func addNewDocument(path: String, type: Docs.typeDocs) {
        documentsList.append(Docs(path: path, type: type))
    }*/
  
    
    
    
      /* func completeDataSource(showcaseHTML: String?, syllabusCode: String?, haveBooking: Bool?, descriptionText: String?) {
           
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
       }*/
    deinit{
        
        print("Deinit TeachingClass")
    }
}

