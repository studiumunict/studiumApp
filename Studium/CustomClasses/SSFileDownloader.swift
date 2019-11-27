//
//  FileDownloader.swift
//  Studium
//
//  Created by Simone Scionti on 21/11/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation

class SSFileDownloader : NSObject, URLSessionDelegate, URLSessionDataDelegate{
    var baseURL = "https://studium.unict.it/dokeos"
    var session : URLSession!
    var dataTask : URLSessionDataTask!
    var expectedLength : Float!
    var buffer: Data!
    var fsDoc : Doc!
    var forIndexPath : IndexPath!
    weak var delegate: SSFileDownloaderDelegate?
   
    public init(delegate: SSFileDownloaderDelegate){
        super.init()
        self.delegate = delegate
        let opQueue = OperationQueue()
        session = URLSession(configuration: .default, delegate: self, delegateQueue: opQueue)
    }
    
    private func getCorrectURL(fsDoc :Doc) ->String{
        let fullAcademicYear = Session.getUniqueIstance().academicYear!
        let startIndex = fullAcademicYear.firstIndex(of: "/")
        let academicYear = String(fullAcademicYear[startIndex!...])
        let folderURL = baseURL + academicYear + "/courses/" + fsDoc.courseID + "/document"
        let fileURL = folderURL + fsDoc.path
        let parsedFileURL = HTMLParser.getUniqueIstance().getStringURL(sourceString: fileURL)
        return parsedFileURL
    }
    func startDownload(forIndexPath: IndexPath, fsDoc: Doc){
        let parsedFileURL = getCorrectURL(fsDoc: fsDoc)
        guard let url = URL(string: parsedFileURL) else { return }
        self.fsDoc = fsDoc
        self.forIndexPath = forIndexPath
        dataTask = session.dataTask(with: url)
        dataTask?.resume()
        buffer = Data()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        expectedLength = Float(response.expectedContentLength)
        completionHandler(URLSession.ResponseDisposition.allow)
    }
   
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        buffer.append(data)
        let percentageDownloaded = Float(buffer.count) / expectedLength
        delegate?.updateDownloadProgress(currentProgress: percentageDownloaded, forIndexPath: forIndexPath)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let tmpURL = FileManager.default.temporaryDirectory.appendingPathComponent(fsDoc.title)
        do {
            try buffer.write(to: tmpURL)
        } catch let er {
            print(er)
            DispatchQueue.main.async {
                self.delegate?.downloadProgressFinished(withError: error, tempUrl: nil, forIndexPath: self.forIndexPath)
            }
            return
        }
        DispatchQueue.main.async {
            self.delegate?.downloadProgressFinished(withError: error, tempUrl: tmpURL, forIndexPath: self.forIndexPath)
        }
    }
    
    /*func downloadFile(courseID: String, fsDoc: Doc, completion: @escaping (URL?)->Void){ //old direct download function with completion
       let parsedFileURL = getCorrectURL(fsDoc: fsDoc)
       guard let url = URL(string: parsedFileURL) else { return }
       URLSession.shared.dataTask(with: url) { data, response, error in
               guard let data = data, error == nil else {
                   DispatchQueue.main.async {
                       completion(nil)
                   }
                   return
               }
                  let tmpURL = FileManager.default.temporaryDirectory.appendingPathComponent(fsDoc.title)
                  do {
                      try data.write(to: tmpURL)
                  } catch let er {
                       print(er)
                       DispatchQueue.main.async {
                          completion(nil)
                       }
                       return
                  }
                  DispatchQueue.main.async {
                   completion(tmpURL)
                  }
               }.resume()
    }*/
}

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}
