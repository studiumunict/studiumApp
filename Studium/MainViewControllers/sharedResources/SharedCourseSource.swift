//
//  SharedCoursesSource.swift
//  Studium
//
//  Created by Simone Scionti on 16/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import Foundation

class SharedCoursesSource: NSObject {
    public var dataSource : [TeachingTableSection] = [TeachingTableSection.init(cdl: CDL.init(courseName: "Default", courseCode: "0"), teachingArray: [Teaching](), setExpanded: true)]
    private static var obj : SharedCoursesSource!
    
    private override init(){}
    
    public static func getUniqueIstance() -> SharedCoursesSource{
        if(obj == nil){
            obj = SharedCoursesSource()
        }
        return obj
    }
    
    var observers = [SharedSourceObserverDelegate]()
    
    public func addObserverDelegate(observer: SharedSourceObserverDelegate ){
        self.observers.append(observer)
    }
    
    private func notifyObserversForUpdate(byController: UIViewController?){
        for observer in observers{
            observer.dataSourceUpdated(byController: byController)
        }
    }
    public func isEmpty() -> Bool{
        return dataSource.count == 1 && dataSource[0].teachings.count == 0
    }
    
    private func getRowIndexByCategory(newSource: [TeachingTableSection],cat: String) -> Int{
           var i = 0
           for row in newSource{
               if row.course.code == cat {return i}
               i+=1
           }
           return 0
    }
    private func getCopy(from: [TeachingTableSection])-> [TeachingTableSection]{
        var to = [TeachingTableSection]()
        for elem in from{
            to.append(elem)
        }
        return to
    }
    
    public func reloadSourceFromAPI(fromController: UIViewController?, completion: @escaping (Bool) -> Void){
        var newSource = [TeachingTableSection]()
        //dataSource.removeAll()
        newSource.append(TeachingTableSection.init(cdl: CDL.init(courseName: "Default", courseCode: "0"), teachingArray: [Teaching](), setExpanded: true))
        let api = BackendAPI.getUniqueIstance(fromController: fromController)
        api.getMyCoursesCategories { (JSONData) in
            guard JSONData != nil else{return}
            for cat in JSONData as! [Any]{
                let dict =  cat as! [String:Any]
                newSource.insert(TeachingTableSection.init(cdl: CDL.init(courseName: dict["title"] as? String, courseCode: String(dict["id"] as! Int)), teachingArray: [Teaching](), setExpanded: true),at: 0)
            }
            //TODO:
            //adattare tutte le altre chiamate al v2, come questa, in cui c'è il nuovo parametro dbName, che serve per poi scaricare gli avvisi, da vedere quale serve per scaricare i documenti ecc ecc.
            api.getMyCourses_v2 { (JSONData) in
                    guard JSONData != nil else{return}
                    let data =  JSONData as! [Any]
                       for course in data{
                            let dict =  course as!  [String:Any]
                           //cerca la riga con categoria corrispondente
                        let i = self.getRowIndexByCategory(newSource: newSource,cat: String(dict["category"] as! Int))
                        print(i)
                        newSource[i].teachings.append(Teaching.init(teachingName: dict["title"] as! String, category: String(dict["category"] as! Int), teachingCode: dict["code"] as! String, teacherName: dict["tutorName"] as! String, dbName: dict["dbName"] as! String, visualCode: dict["visualCode"] as! String, visibility: dict["visibility"] as? Int ?? 2, subscribe: dict["subscribe"] as? Int ?? 1, unsubscribe: dict["unsubscribe"] as? Int ?? 0))
                       
                       }
                    self.dataSource = newSource
                    self.notifyObserversForUpdate(byController: fromController)
                    completion(true)
            }
        }
    }
    
}



