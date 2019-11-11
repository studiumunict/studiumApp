//
//  DocsClass.swift
//  Studium
//
//  Created by Francesco Petrosino on 19/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import Foundation


class Doc {
    let type: docType!
    let canOpen: Bool!
    var path: String!
    var title: String!
    var lastUpdate : String!
    var uploaded : String!
    var size :Int!
    var suffix: String?
    var parent: Doc!
    var childs = [Doc]()
    
    enum docType {
        case file
        case folder
    }
    init(title: String, path: String, type: docType) {
        self.title = title
        self.path = path
        self.type = type
        self.canOpen = true
        self.uploaded = ""
        self.lastUpdate = ""
        self.size = 0
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
        if type == "folder" {self.type = .folder }
        else{ self.type = .file }
        self.uploaded = uploaded
        self.lastUpdate = lastUpdate
        self.size = size
        self.canOpen = true
        self.title = self.parseHTMLText(text: self.title)
    }
    
    func setParent(prev: Doc!) {
        self.parent = prev
    }
    
    func addChild(item: Doc) {
        self.childs.append(item)
    }
    
}
