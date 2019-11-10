//
//  DocsClass.swift
//  Studium
//
//  Created by Francesco Petrosino on 19/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import Foundation


class Docs {
    let TypeDoc: typeDocs!
    let CanOpen: Bool!
    
    var ID = String()
    var path: String!
    var title: String!
    var lastUpdate : String!
    var uploaded : String!
    var size :Int!
    var suffix: String?
    var prev: Docs!
    var next = [Docs]()
    
    enum typeDocs {
        case file
        case folder
    }
    init(title: String, path: String, type: typeDocs) {
        self.title = title
        self.path = path
        self.TypeDoc = type
        self.CanOpen = true
        self.uploaded = ""
        self.lastUpdate = ""
        self.size = 0
        self.ID = addressOf(self)
    }
    private func parseHTMLText(text: String)-> String{
           var str = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
           str = str.replacingOccurrences(of: "&#39;", with: "'", options: .caseInsensitive, range: nil)
            str = str.replacingOccurrences(of: "&#039;", with: "'", options: .caseInsensitive, range: nil)
           str = str.replacingOccurrences(of: "&nbsp;", with: "", options: .caseInsensitive, range: nil)
           str = str.replacingOccurrences(of: "&quot;", with: "\"", options: .caseInsensitive, range: nil)
           str = str.replacingOccurrences(of: "&rsquo;", with: "'", options: .caseInsensitive, range: nil)
           str = str.replacingOccurrences(of: "&agrave;", with: "à", options: .caseInsensitive, range: nil)
           str = str.replacingOccurrences(of: "&egrave;", with: "è", options: .caseInsensitive, range: nil)
           str = str.replacingOccurrences(of: "&igrave;", with: "ì", options: .caseInsensitive, range: nil)
           str = str.replacingOccurrences(of: "&ograve;", with: "ò", options: .caseInsensitive, range: nil)
           str = str.replacingOccurrences(of: "&ugrave;", with: "ù", options: .caseInsensitive, range: nil)
           var i = str.count-1
           var char = false
           while(i >= 0 && !char){
               if(str[i] != " "){
                   char = true
               }
               else{i-=1}
           }
           let finalStr = String(str.dropLast(str.count-1-i))
           return finalStr
       }
    
    init(title: String, path: String, type: String, uploaded: String, lastUpdate: String, size: Int) {
        self.title = title
        self.path = path
        if type == "folder" {self.TypeDoc = .folder }
        else{ self.TypeDoc = .file }
        self.uploaded = uploaded
        self.lastUpdate = lastUpdate
        self.size = size
        self.CanOpen = true
        self.ID = addressOf(self)
        self.title = self.parseHTMLText(text: self.title)
        /*if type == .file {
            let dot = path.firstIndex(of: ".")!
            self.title = String(path[..<dot])
            suffix = String(path[path.index(after: dot)...])
        } else {
            suffix = nil
            if path.lastIndex(of: "/") != nil {
                let dot = path.lastIndex(of: "/")!
                self.title = String(path[path.index(after: dot)...])
            } else {
                self.title = path
            }
        }*/
    }
    
    func setPrev(prev: Docs!) {
        self.prev = prev
        
        if self.prev != nil {
            self.prev.setNext(items: [self])
        }
    }
    
    func setNext(items: [Docs]) {
        for x in items {
            self.next.append(x)
        }
    }
    
    private func addressOf<Docs>(_ o: Docs) -> String {
        let addr = unsafeBitCast(o, to: Int.self)
        return String(format: "%p", addr)
    }
}

extension Docs: Equatable {
    static func == (left: Docs, right: Docs) -> Bool {
        return left.ID == right.ID
    }
    
    static func != (left: Docs, right: Docs) -> Bool {
        return left.ID != right.ID
    }
}
