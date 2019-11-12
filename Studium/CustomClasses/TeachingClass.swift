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
    var fs : DocSystem!
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
        fs = DocSystem()
    }
    
   
    func refreshTeachingData(completion: @escaping(Bool)->Void){
        
    }
    
    func completeTeachingData(completion: @escaping (Bool)->Void){
        guard isCompleted == false else { completion(false); return}
        self.downloadNotify { (flag) in
            self.downloadDocuments(path: "mbareRoot", prev: self.fs.currentFolder) { (flag1) in
                self.downloadDescription { (flag2) in
                    self.isCompleted = true
                    self.syllabusCode = self.code
                        completion(true)
                }
            }
        }
    }
   
    private func downloadRootDocuments(completion: @escaping(Bool)-> Void){ //FUNZIONE SICURA
        let api = BackendAPI.getUniqueIstance()
        api.getCourseDocuments(codCourse: self.code, path: "mbareRoot") { (JSONResponse) in
            let JSONArray = JSONResponse as! [Any]
            for doc in JSONArray{
                let docDict = doc as! [String:Any]
                //print("*****Appendo Doc*****")
                let item =  Doc.init(title: docDict["title"] as! String, path: docDict["path"] as! String, type: docDict["type"] as! String, uploaded: docDict["insert"] as! String, lastUpdate: docDict["updated"] as! String, size: docDict["size"] as! Int)
                item.setParent(prev: self.fs.currentFolder) //currentFolder è la root
                self.fs.currentFolder.addChild(item: item)
                if(docDict["type"] as! String == "folder") {
                    self.downloadDocuments(path: docDict["path"] as! String, prev: item) { (flag2) in
                        //print("Scaricati anche i secondi")
                    }
                }
            }
            completion(true)
        }
    }
    
    /*private func downloadDocuments(path: String, prev: Docs ,completion: @escaping(Bool)-> Void){ //scarica il secondo livello
        let api = BackendAPI.getUniqueIstance()
        api.getCourseDocuments(codCourse: self.code, path: path) { (JSONResponse) in
            let JSONArray = JSONResponse as! [Any]
            for doc in JSONArray{
                let docDict = doc as! [String:Any]
                print("*****Appendo Doc*****")
                self.documentsList.append(Docs.init(title: docDict["title"] as! String, path: docDict["path"] as! String, type: docDict["type"] as! String, uploaded: docDict["insert"] as! String, lastUpdate: docDict["updated"] as! String, size: docDict["size"] as! Int))
                self.documentsList[self.documentsList.count-1].setPrev(prev: prev)
                }
            }
            completion(true)
        }
    }
    */
    
    private func downloadDocuments(path: String, prev: Doc! ,completion: @escaping(Bool)-> Void){ //FUNZIONE NON SICURA
        let api = BackendAPI.getUniqueIstance()
        api.getCourseDocuments(codCourse: self.code, path: path) { (JSONResponse) in
            let JSONArray = JSONResponse as! [Any]
            for doc in JSONArray{
                let docDict = doc as! [String:Any]
                //print("*****Appendo Doc*****")
                let item = Doc.init(title: docDict["title"] as! String, path: docDict["path"] as! String, type: docDict["type"] as! String, uploaded: docDict["insert"] as! String, lastUpdate: docDict["updated"] as! String, size: docDict["size"] as! Int)
                item.setParent(prev: prev)
                prev.addChild(item: item)
                if(docDict["type"] as! String == "folder") {
                    self.downloadDocuments(path: docDict["path"] as! String, prev: item) { (flag2) in
                        print("scaricato sublist")
                        
                    }
                }
                
            }
            completion(true) //questo può causare bug perchè il completion viene fatto quando ancora non sono stati scaricati tutti i documenti. Se la connessione è lenta l'utente può accedere in una cartella nella quale risulta non esserci documenti interni, in realtà vengono scaricati poco dopo e non viene fatto il reload. La soluzione è quella di spostare il download in una classe a parte, e richiamarlo sia dalla classe Teaching per valutare che ci siano documenti e scaricare i primi due livelli, sia nella classe DocumentsPageController per effettuare download dinamicamente quando si entra in una cartella.
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
    /*private func downloadDocuments(completion: @escaping (Bool)->Void){
        let api =  BackendAPI.getUniqueIstance()
        api.getCourseDocuments(codCourse: self.code, path: "mbareRoot") { (JSONResponse) in
            print(JSONResponse ?? "NULL")
            completion(true)
        }
    }*/
    private func downloadDescription(completion: @escaping (Bool)->Void){
        //self.descriptionText = "Descrizione"
        let api = BackendAPI.getUniqueIstance()
        api.getCourseDescription(codCourse: self.code) { (JSONResponse) in
            print("**************************Descrizione", JSONResponse ?? "NULL")
            completion(true)
            //self.descriptionText  =  parseHTMLText(text: JJSONResponse)
        }
       
    }

    deinit{
        
        print("Deinit TeachingClass")
    }
}

