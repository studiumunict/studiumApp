//
//  DocsClass.swift
//  Studium
//
//  Created by Francesco Petrosino on 19/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import Foundation


class Doc : NSObject, NSCoding {
    var type: String!
    var canOpen: Bool!
    var path: String!
    var title: String!
    var lastUpdate : String!
    var uploaded : String!
    var size :Int!
    var suffix: String?
    var parent: Doc!
    var childs = [Doc]()
    
    /*enum docType {
        case file
        case folder
    }*/
    init(title: String, path: String, type: String) {
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
        super.init()
        //self.title = title
        self.path = path
        self.type = type
        self.uploaded = uploaded
        self.lastUpdate = lastUpdate
        self.size = size
        self.canOpen = true
        self.title = self.parseHTMLText(text: title)
    }
    
    func setParent(prev: Doc!) {
        self.parent = prev
    }
    
    func addChild(item: Doc) {
        self.childs.append(item)
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(title, forKey: "title")
        coder.encode(canOpen, forKey: "canOpen")
        coder.encode(size, forKey: "size")
        coder.encode(lastUpdate, forKey: "lastUpdate")
        coder.encode(uploaded, forKey: "uploaded")
        coder.encode(type, forKey: "type")
        coder.encode(path, forKey: "path")
        
    }
    
    required public init?(coder: NSCoder) {
        title = coder.decodeObject( forKey: "title") as? String
        canOpen = coder.decodeObject( forKey: "canOpen") as? Bool
        size = coder.decodeObject( forKey: "size") as? Int
        lastUpdate = coder.decodeObject( forKey: "lastUpdate") as? String
        uploaded = coder.decodeObject( forKey: "uploaded") as? String
        type = coder.decodeObject(forKey: "type") as? String
        path = coder.decodeObject( forKey: "path") as? String
    }
    
}
