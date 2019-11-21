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
    var parent: Doc!
    var childs = [Doc]()
    var courseID : String!
    
    /*enum docType {
        case file
        case folder
    }*/
    init(title: String, path: String, type: String, courseID: String) {
        self.title = title
        self.path = path
        self.type = type
        self.canOpen = true
        self.uploaded = ""
        self.lastUpdate = ""
        self.size = 0
        self.courseID = courseID
    }

    
    init(title: String, path: String, type: String, uploaded: String, lastUpdate: String, size: Int, courseID: String) {
        super.init()
        //self.title = title
        self.path = path
        self.type = type
        self.uploaded = uploaded
        self.lastUpdate = lastUpdate
        self.size = size
        self.canOpen = true
        self.courseID = courseID
        self.title = HTMLParser.getUniqueIstance().parseHTMLText(text: title)
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
        coder.encode(parent, forKey: "parent")
        coder.encode(childs, forKey: "childs")
        coder.encode(courseID, forKey: "courseID")
    }
    
    required public init?(coder: NSCoder) {
        title = coder.decodeObject( forKey: "title") as? String
        canOpen = coder.decodeObject( forKey: "canOpen") as? Bool
        size = coder.decodeObject( forKey: "size") as? Int
        lastUpdate = coder.decodeObject( forKey: "lastUpdate") as? String
        uploaded = coder.decodeObject( forKey: "uploaded") as? String
        type = coder.decodeObject(forKey: "type") as? String
        path = coder.decodeObject( forKey: "path") as? String
        parent = coder.decodeObject( forKey: "parent") as? Doc
        childs = coder.decodeObject( forKey: "childs") as! [Doc]
        courseID = coder.decodeObject( forKey: "courseID") as! String
    }
    
}
