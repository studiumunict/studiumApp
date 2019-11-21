//
//  FileDownloader.swift
//  Studium
//
//  Created by Simone Scionti on 21/11/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation

class FileDownloader {
    
    static var obj : FileDownloader!
    var baseURL = "https://studium.unict.it/dokeos"
    private init(){}
    
    static func getUniqueIstance() -> FileDownloader{
        if obj == nil{
            obj = FileDownloader()
        }
        return obj
    }
    
    func downloadFile(courseID: String, fsDoc: Doc, completion: @escaping (URL)->Void){
        let fullAcademicYear = Session.getUniqueIstance().academicYear!
        let startIndex = fullAcademicYear.firstIndex(of: "/")
        let academicYear = String(fullAcademicYear[startIndex!...])
        let folderURL = baseURL + academicYear + "/courses/" + fsDoc.courseID + "/document"
        let fileURL = folderURL + fsDoc.path
        print(fileURL)
        guard let url = URL(string: fileURL) else { return }
               /// START YOUR ACTIVITY INDICATOR HERE
               URLSession.shared.dataTask(with: url) { data, response, error in
                   guard let data = data, error == nil else { return }
                   let tmpURL = FileManager.default.temporaryDirectory
                    .appendingPathComponent(response?.suggestedFilename ?? fsDoc.title)
                   do {
                       try data.write(to: tmpURL)
                   } catch {
                       print(error)
                   }
                   DispatchQueue.main.async {
                       /// STOP YOUR ACTIVITY INDICATOR HERE
                    completion(tmpURL)
                      // self.share(url: tmpURL)
                   }
                }.resume()
     }
}

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}
