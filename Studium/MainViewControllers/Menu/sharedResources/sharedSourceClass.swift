//
//  File.swift
//  Studium
//
//  Created by Simone Scionti on 16/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import Foundation

class SharedSource: NSObject {
    public var courseSharedDataSource : [HomeTableSection] = [HomeTableSection.init(cdl: CDL.init(courseName: "Default", courseCode: "0"), teachingArray: [Teaching](), setExpanded: true)]
    private static var obj : SharedSource!
    
    private override init(){}
    
    public static func getUniqueIstance() -> SharedSource{
        if(obj == nil){
            obj = SharedSource()
        }
        return obj
    }
    
    private func getRowIndexByCategory(cat: String) -> Int{
           var i = 0
           for row in courseSharedDataSource{
               print(row.course, " _------_", cat)
               if row.course.code == cat{
                   print("Trovato indice", i , "Categpria ", cat)
                   return i }
               i+=1
           }
           return 0
    }
    
    public func reloadSourceFromAPI(completion: @escaping (Bool) -> Void){
        let api = BackendAPI.getUniqueIstance()
        api.getMyCoursesCategories { (JSONData) in
            //print("Categorie",JSONData)
            for cat in JSONData as! [Any]{
                let dict =  cat as! [String:Any]
                self.courseSharedDataSource.insert(HomeTableSection.init(cdl: CDL.init(courseName: dict["title"] as? String, courseCode: String(dict["id"] as! Int)), teachingArray: [Teaching](), setExpanded: true),at: 0)
            }
            api.getMyCourses { (JSONData) in
                      //print("Miei corsi",JSONData)
                    let data =  JSONData as! [Any]
                       for course in data{
                            let dict =  course as!  [String:Any]
                           //cerca la riga con categoria corrispondente
                            let i = self.getRowIndexByCategory(cat: String(dict["category"] as! Int))
                        self.courseSharedDataSource[i].teachings.append(Teaching.init(teachingName: dict["title"] as! String, category: String(dict["category"] as! Int), teachingCode: dict["code"] as! String, teacherName: dict["tutorname"] as! String, signedUp: true))
                       
                       }
                    completion(true)
                   // self.teachingsTableView.reloadData()
            }
        }
    }
    
}



