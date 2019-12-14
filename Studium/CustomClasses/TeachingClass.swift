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
    var bookings : [BookingTableSection]!
    var description: [DescriptionBlock]!
    var notifyList: [Notify]!
    var fs : TempDocSystem!
    var syllabusCode: String!
    weak var currentControler: UIViewController?
    private var isCompleted = false
    
    
    init(teachingName: String, category: String, teachingCode: String, teacherName: String, signedUp: Bool) {
        print("Init TeachingClass")
        self.name = teachingName
        self.code = teachingCode
        self.teacherName = teacherName
        self.signedUp = signedUp
        self.category = category
        notifyList = [Notify]()
        fs = TempDocSystem()
        description = [DescriptionBlock]()
        //myBooking = [Booking]()
        //otherBooking = [Booking]()
        bookings = [BookingTableSection]()
    }
    
    func removeAllData(){
        self.notifyList.removeAll()
        self.fs.removeAll()
        self.description.removeAll()
        self.bookings.removeAll()
    }
    func refreshData(fromController: UIViewController?, completion: @escaping (Bool)->Void){
        self.isCompleted = false
        completeTeachingData(fromController: fromController) { (wasLoaded,flag) in
            print("***************Ho finito, completion ", flag)
            completion(flag)
        }
    }
    
    func completeTeachingData(fromController: UIViewController?, completion: @escaping (Bool,Bool)->Void){
        guard isCompleted == false else { completion(true,false); return}
        self.currentControler = fromController
        self.downloadNotify { (flag) in
            if !flag {completion(false,false); return}
            self.downloadDocuments(path: "mbareRoot", prev: self.fs.currentFolder) { (flag1) in
                if !flag1 {completion(false,false); return}
                self.downloadDescription { (flag2) in
                     if !flag2 {completion(false,false); return}
                        self.downloadBooking { (flag3) in
                         if !flag3 {completion(false,false); return}
                                self.isCompleted = true
                                self.syllabusCode = self.code
                                completion(false,true)
                    }
                }
            }
        }
    }
    
    private func downloadRootDocuments(completion: @escaping(Bool)-> Void){ //FUNZIONE SICURA
        let api = BackendAPI.getUniqueIstance(fromController: currentControler)
        api.getCourseDocuments(codCourse: self.code, path: "mbareRoot") { (error,JSONResponse) in
            guard error == nil else{
                completion(false)
                return
            }
            if let JSONArray = JSONResponse as? [Any]{
                for doc in JSONArray{
                    let docDict = doc as! [String:Any]
                    //print("*****Appendo Doc*****")
                    let item =  Doc.init(title: docDict["title"] as! String, path: docDict["path"] as! String, type: docDict["type"] as! String, uploaded: docDict["insert"] as! String, lastUpdate: docDict["updated"] as! String, size: docDict["size"] as! Int, courseID: self.code)
                    item.setParent(prev: self.fs.currentFolder) //currentFolder è la root
                    let _ = self.fs.appendChild(toDoc: self.fs.currentFolder, child: item)
                    if(docDict["type"] as! String == "folder") {
                        self.downloadDocuments(path: docDict["path"] as! String, prev: item) { (flag2) in
                            //print("Scaricati anche i secondi")
                        }
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
    
    private func downloadBooking(completion: @escaping (Bool)->Void){
        let api =  BackendAPI.getUniqueIstance(fromController: currentControler)
        var myBooking = [Booking]()
        var otherBooking = [Booking]()
        api.getBooking(codCourse: self.code) { (error, JSONResponse) in
            //print(JSONResponse)
            //salva le prenotazioni in una struttura
            if error != nil {completion(false); return}
            if let root = JSONResponse as? [String:Any]{
                let other = root["other"] as! [Any]
                for otherB in other {
                    let dictBooking = otherB as! [String:Any]
                    let booking = Booking.init(id: dictBooking["id"] as! Int, name: dictBooking["name"] as! String, data: dictBooking["data"] as! String, openData: dictBooking["open"] as! String, closeData: dictBooking["close"] as! String, closeHour: dictBooking["closeHour"] as! String, closeMinute: dictBooking["closeMinute"] as! String, mine: false)
                    //print(dictp)
                    otherBooking.append(booking)
                }
                let mine = root["mine"] as! [Any]
                for myB in mine {
                    let dictBooking = myB as! [String:Any]
                    let booking = Booking.init(id: dictBooking["id"] as! Int, name: dictBooking["name"] as! String, data: dictBooking["data"] as! String, openData: dictBooking["open"] as! String, closeData: dictBooking["close"] as! String, closeHour: dictBooking["closeHour"] as! String, closeMinute: dictBooking["closeMinute"] as! String, mine: true)
                    myBooking.append(booking)
                    //print(dictp)
                }
                if myBooking.count > 0{
                    let sect = BookingTableSection.init(sectionName: "Mie prenotazioni", booking: myBooking)
                    self.bookings.append(sect)
                    self.haveBooking = true
                }
                
                if otherBooking.count > 0 {
                    let sect = BookingTableSection.init(sectionName: "Altre prenotazioni", booking: otherBooking)
                    self.bookings.append(sect)
                    self.haveBooking = true
                }
            }
            completion(true)
        }
    }
    
    private func downloadDocuments(path: String, prev: Doc! ,completion: @escaping(Bool)-> Void){ //FUNZIONE NON SICURA
        let api = BackendAPI.getUniqueIstance(fromController: currentControler)
        api.getCourseDocuments(codCourse: self.code, path: path) { (error,JSONResponse) in
            if let JSONArray = JSONResponse as? [Any] {
                for doc in JSONArray{
                    let docDict = doc as! [String:Any]
                    //print("*****Appendo Doc*****")
                    let item = Doc.init(title: docDict["title"] as! String, path: docDict["path"] as! String, type: docDict["type"] as! String, uploaded: docDict["insert"] as! String, lastUpdate: docDict["updated"] as! String, size: docDict["size"] as! Int, courseID: self.code)
                    let _ = self.fs.appendChild(toDoc: prev, child: item)
                    //item.setParent(prev: prev)
                    //prev.addChild(item: item)
                    if(docDict["type"] as! String == "folder") {
                        self.downloadDocuments(path: docDict["path"] as! String, prev: item) { (flag2) in
                            print("scaricato sublist")
                            
                        }
                    }
                }
            }
            completion(true) //questo può causare bug perchè il completion viene fatto quando ancora non sono stati scaricati tutti i documenti. Se la connessione è lenta l'utente può accedere in una cartella nella quale risulta non esserci documenti interni, in realtà vengono scaricati poco dopo e non viene fatto il reload. La soluzione è quella di spostare il download in una classe a parte, e richiamarlo sia dalla classe Teaching per valutare che ci siano documenti e scaricare i primi due livelli, sia nella classe DocumentsPageController per effettuare download dinamicamente quando si entra in una cartella.
        }
    }
       
    
    private func downloadNotify(completion: @escaping (Bool)->Void){
        let api =  BackendAPI.getUniqueIstance(fromController: currentControler)
        api.getAvvisi(codCourse: self.code) { (error,JSONResponse) in
            guard error == nil else{
                completion(false)
                return
            }
            if let JSONArray = JSONResponse as? [Any] {
                for avviso in JSONArray{
                    let avvisoDict = avviso as! [String: Any]
                    self.notifyList.append(Notify(date: avvisoDict["data"] as? String, title: avvisoDict["title"] as? String, message: avvisoDict["content"] as? String ))
                }
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
        let api = BackendAPI.getUniqueIstance(fromController: currentControler)
        api.getCourseDescription(codCourse: self.code) { (error,JSONResponse) in
            guard error == nil else{ completion(false); return}
            if let JSONArray = JSONResponse as? [Any]{
                for descBlock in JSONArray{
                    let descriptionBlock = descBlock as! [String: Any]
                    let blockTitle = descriptionBlock["title"] as! String
                    let blockContent = descriptionBlock["content"] as! String
                    let descBlock = DescriptionBlock(title: blockTitle, message: blockContent)
                    self.description.append(descBlock)
                }
            }
            completion(true)
        }
       
    }

    deinit{
        
        print("Deinit TeachingClass")
    }
}

