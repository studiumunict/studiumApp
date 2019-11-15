//
//  DocSystem.swift
//  Studium
//
//  Created by Simone Scionti on 11/11/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation

public class TempDocSystem: NSObject, NSCoding {
    
    var root = Doc.init(title: "Root", path: "Home", type: "folder", uploaded: "", lastUpdate: "", size: 0)
    var currentFolder : Doc!
    
    override init() {
        super.init()
        currentFolder = root
        root.parent = nil
    }
    
    func appendChilds(toDoc: Doc, childs: [Doc]){
        for child in childs{
            toDoc.addChild(item: child)
            child.setParent(prev: toDoc)
        }
    }
    func appendChild(toDoc: Doc, child: Doc){
        toDoc.addChild(item:child)
        child.setParent(prev: toDoc)
    }
    
    func removeChild(doc: Doc){
        
    }
    func getCurrentDocs() -> [Doc]{
        return currentFolder.childs
    }
    
    func goToParent(){
        currentFolder = currentFolder.parent
    }
    
    func goToChild(childDoc: Doc){
        currentFolder = childDoc
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(root, forKey: "root")
        //coder.encode(currentFolder, forKey: "currentFolder")
    }
    
    required public init?(coder: NSCoder) {
        root = coder.decodeObject(forKey: "root") as! Doc
        currentFolder = root
        //currentFolder = coder.decodeObject(forKey: "currentFolder") as? Doc
    }
    
}
