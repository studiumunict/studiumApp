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
    weak var errorDelegate : ConnectionErrorHandlerDelegate?
   
    public init(delegate: SSFileDownloaderDelegate, errorHandlerDelegate: ConnectionErrorHandlerDelegate?){
        super.init()
        self.delegate = delegate
        self.errorDelegate = errorHandlerDelegate
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
        if error != nil{
            errorDelegate?.connectionErrorHandle(error: error)
            DispatchQueue.main.async {
                self.delegate?.downloadProgressFinished(withError: error, tempUrl: nil, forIndexPath: self.forIndexPath)
            }
            return
        }
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
}

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}
