//
//  TeachingClass.swift
//  Studium
//
//  Created by Simone Scionti on 06/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import Foundation

class Teaching : NSObject, BookingDelegate{
    var category: String!
    var name: String!
    var code: String!
    var teacherName: String!
    var showcaseHTML: String!
    var haveBooking: Bool!
    var bookings : [BookingTableSection]!
    var descriptionBlocks: [DescriptionBlock]!
    var notifyList: [Notify]!
    var dbName: String!
    var visualCode: String!
    var fs : TempDocSystem!
    var syllabusCode: String!
    var hasSyllabus: Bool!
    weak var currentControler: UIViewController?
    private var isCompleted = false
    var visibility: Int!  // 2 se è libero , 1 se è privato.
    var subscribe : Int! //deve essere 1 per essere libero,0 se non puoi iscriverti
    var unsubscribe : Int! // deve essere 0 per essere libero,1  se solo il docente può farlo
    
    var delegates = [TeachingDelegate]() //potrebbe essere un array per gli observer
    
    init(teachingName: String, category: String, teachingCode: String, teacherName: String,dbName: String,visualCode: String, visibility: Int, subscribe:Int, unsubscribe: Int) {
        //print("Init TeachingClass")
        self.name = teachingName
        self.code = teachingCode
        self.teacherName = teacherName
        self.category = category
        self.dbName = dbName
        self.visualCode = visualCode
        self.visibility = visibility
        self.subscribe = subscribe
        self.unsubscribe = unsubscribe
        notifyList = [Notify]()
        fs = TempDocSystem()
        descriptionBlocks = [DescriptionBlock]()
        hasSyllabus = true
        bookings = [BookingTableSection]()
    }
    
    func canSubscribe()-> Bool{
        if subscribe == 1 {return true}
        return false
    }
    
    func canUnsubscribe()-> Bool{
        if unsubscribe == 0 {return true}
        return false
    }
    
    func attachDelegate(delegate: TeachingDelegate){
        self.delegates.append(delegate)
    }
    
    func checkVisibility() -> Bool{
        guard self.visibility != 2 else {return true}
        let myCoursesArray =  SharedCoursesSource.getUniqueIstance()
        if myCoursesArray.dataSource.contains(where: { (t) -> Bool in
            t.teachings.contains { (teach) -> Bool in
                teach.code == self.code
            }
        }){
            return true
        }
        return false
    }
    
    func removeAllData(){
        self.notifyList.removeAll()
        self.fs.removeAll()
        self.descriptionBlocks.removeAll()
        self.bookings.removeAll()
    }
    func refreshData(fromController: UIViewController?, completion: @escaping (Bool)->Void){
        self.isCompleted = false
        completeTeachingData(fromController: fromController) { (wasLoaded,flag) in
            //print("***************Ho finito, completion ", flag)
            completion(flag)
        }
    }
    
    func completeTeachingData(fromController: UIViewController?, completion: @escaping (Bool,Bool)->Void){
        guard isCompleted == false else { completion(true,false); return}
        self.currentControler = fromController
        self.downloadCourseContent { (success) in
            if success{
                self.isCompleted = true
                self.syllabusCode = self.code
                self.checkSyllabusContent { (success) in
                    self.hasSyllabus = success
                    completion(false,true)
                }
            }
            else{
                completion(false,false)
            }
        }
    }
    
    private func checkSyllabusContent(completion:@escaping (Bool)->Void){
        let myURLString = "https://syllabus.unict.it/insegnamento.php?mod=" + self.syllabusCode
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            completion(false)
            return
        }
        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
            print("HTML : \(myHTMLString)")
            //chrck html content and decide if completion is true or false
            if myHTMLString.count > 50{
                completion(true)
            }
            else {
                completion(false)
                
            }
            
        } catch let error {
            print("Error: \(error)")
            completion(false)
        }
    
    }
    
    private func downloadCourseContent(completion:@escaping (Bool)->Void){
        let api = BackendAPI.getUniqueIstance(fromController: currentControler)
        api.getCourseContent_v2(dbName: self.dbName, course: self.code) { (error, JSONResponse) in
            //print(JSONResponse)
            if JSONResponse != nil && error == nil{
                //chiami i diversi setup
                guard let dict = JSONResponse as? [String: Any] else{completion(false);return}
                self.setupNotify(JSONResponse: dict["announcements"])
                self.setupDescription(JSONResponse: dict["description"])
                self.setupDocuments(prev: self.fs.currentFolder, JSONResponse: dict["documents"])
                self.setupBooking(JSONResponse: dict["prenotazioni"])
                completion(true)
            }
            else{
                completion(false)
            }
            
        }
    
    }
    
    private func notifyDelegatesForBookingUpdate(){
        for d in delegates{
            print("chiamo il delegate controller per reload table(bookings Updated)")
            d.bookingsUpdated()
        }
    }
    
    private func refreshBooking(completion: @escaping(Bool)-> Void){
        self.bookings.removeAll()
        self.downloadBooking { (flag) in
            //notify delegate to refresh Views
            self.notifyDelegatesForBookingUpdate()
            completion(flag)
        }
    }
    
    //booking delegate functions
    func bookingConfirmed(booking: Booking) {
        //we can move directly the cell in the table passing the ref
        self.refreshBooking { (success) in
        }
    }
      
    func bookingCancelled(booking: Booking) {
        //we can move directly the cell in the table passing the ref
        self.refreshBooking { (success) in
        }
    }
    
    
    private func downloadBooking(completion: @escaping (Bool)->Void){
        let api =  BackendAPI.getUniqueIstance(fromController: currentControler)
        api.getBooking_v2(codCourse: self.code) { (error, JSONResponse) in
            if error != nil {completion(false); return}
            self.setupBooking(JSONResponse: JSONResponse)
            completion(true)
        }
    }
    private func setupBooking(JSONResponse: Any?){
        var myBooking = [Booking]()
        var otherBooking = [Booking]()
        if let root = JSONResponse as? [String:Any]{
            let other = root["other"] as! [Any]
            for otherB in other {
                let dictBooking = otherB as! [String:Any]
                let booking = Booking.init(id: dictBooking["id"] as! Int, name: dictBooking["name"] as! String, data: dictBooking["data"] as! String, openData: dictBooking["open"] as! String, closeData: dictBooking["close"] as! String, closeHour: dictBooking["closeHour"] as! String, closeMinute: dictBooking["closeMinute"] as! String, mine: false, delegate: self)
                //print(dictp)
                otherBooking.append(booking)
            }
            let mine = root["mine"] as! [Any]
            for myB in mine {
                let dictBooking = myB as! [String:Any]
                let booking = Booking.init(id: dictBooking["id"] as! Int, name: dictBooking["name"] as! String, data: dictBooking["data"] as! String, openData: dictBooking["open"] as! String, closeData: dictBooking["close"] as! String, closeHour: dictBooking["closeHour"] as! String, closeMinute: dictBooking["closeMinute"] as! String, mine: true, delegate: self)
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
    }
    
    private func downloadDocuments(path: String, prev: Doc! ,completion: @escaping(Bool)-> Void){ //FUNZIONE NON SICURA
        let api = BackendAPI.getUniqueIstance(fromController: currentControler)
        api.getCourseDocuments_v2(dbName: self.dbName, path: path) { (error,JSONResponse) in
            self.setupDocuments(prev: prev,JSONResponse: JSONResponse)
            completion(true) //questo può causare bug perchè il completion viene fatto quando ancora non sono stati scaricati tutti i documenti. Se la connessione è lenta l'utente può accedere in una cartella nella quale risulta non esserci documenti interni, in realtà vengono scaricati poco dopo e non viene fatto il reload. La soluzione è quella di spostare il download in una classe a parte, e richiamarlo sia dalla classe Teaching per valutare che ci siano documenti e scaricare i primi due livelli, sia nella classe DocumentsPageController per effettuare download dinamicamente quando si entra in una cartella.
        }
    }
    
    private func setupDocuments(prev: Doc!, JSONResponse : Any?){
        if let JSONArray = JSONResponse as? [Any] {
            for doc in JSONArray{
                let docDict = doc as! [String:Any]
                let item = Doc.init(title: docDict["title"] as! String, path: docDict["path"] as! String, type: docDict["type"] as! String, uploaded: docDict["insert"] as! String, lastUpdate: docDict["updated"] as! String, size: docDict["size"] as! Int, courseID: self.code)
                let _ = self.fs.appendChild(toDoc: prev, child: item)
            
                if(docDict["type"] as! String == "folder") {
                    self.downloadDocuments(path: docDict["path"] as! String, prev: item) { (flag2) in
                        //do nothing
                    }
                }
            }
        }
    }
       
    
    private func downloadNotify(completion: @escaping (Bool)->Void){
        let api =  BackendAPI.getUniqueIstance(fromController: currentControler)
        api.getAvvisi_v2(dbName: self.dbName) { (error,JSONResponse) in
            guard error == nil else{
                completion(false)
                return
            }
            self.setupNotify(JSONResponse: JSONResponse)
            completion(true)
        }
    }
    private func setupNotify(JSONResponse: Any?){
       if let JSONArray = JSONResponse as? [Any] {
           for avviso in JSONArray{
               let avvisoDict = avviso as! [String: Any]
               self.notifyList.append(Notify(date: avvisoDict["data"] as? String, title: avvisoDict["title"] as? String, message: avvisoDict["content"] as? String ))
           }
       }
    }
    
    private func downloadDescription(completion: @escaping (Bool)->Void){
        //self.descriptionText = "Descrizione"
        let api = BackendAPI.getUniqueIstance(fromController: currentControler)
        api.getCourseDescription_v2(dbName: self.dbName) { (error,JSONResponse) in
            guard error == nil else{ completion(false); return}
            self.setupNotify(JSONResponse: JSONResponse)
            completion(true)
        }
    }
    private func setupDescription(JSONResponse: Any?){
            if let JSONArray = JSONResponse as? [Any]{
               for descBlock in JSONArray{
                   let descriptionBlock = descBlock as! [String: Any]
                   let blockTitle = descriptionBlock["title"] as! String
                   let blockContent = descriptionBlock["content"] as! String
                   let descBlock = DescriptionBlock(title: blockTitle, message: blockContent)
                   self.descriptionBlocks.append(descBlock)
               }
           }
    }

    deinit{
        
        print("Deinit TeachingClass")
    }
}

