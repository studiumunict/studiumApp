//
//  DocSystem.swift
//  Studium
//
//  Created by Simone Scionti on 11/11/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation

public class DocSystem: NSObject, NSCoding {
    
    //var documentsList = [Doc]()
    var root = Doc.init(title: "Root", path: "Home", type: "folder", uploaded: "", lastUpdate: "", size: 0)
    var currentFolder : Doc!
    var autoSave = false
    
    init(autoSave :Bool) {
        currentFolder = root
        root.parent = nil
        self.autoSave = autoSave
    }
    func appendChild(toDoc: Doc, child: Doc){
        toDoc.addChild(item:toDoc)
        child.setParent(prev: toDoc)
    
        if(autoSave) { }//salva nel coreData
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
        coder.encode(currentFolder, forKey: "currentFolder")
        coder.encode(autoSave, forKey: "autoSave")
    }
    
    required public init?(coder: NSCoder) {
        root = coder.decodeObject(forKey: "root") as! Doc
        currentFolder = coder.decodeObject(forKey: "currentFolder") as? Doc
        autoSave = coder.decodeObject(forKey: "autoSave") as! Bool
    }
    
}
