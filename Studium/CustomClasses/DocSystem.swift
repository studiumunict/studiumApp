//
//  DocSystem.swift
//  Studium
//
//  Created by Simone Scionti on 11/11/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation

class DocSystem {
    //var documentsList = [Doc]()
    let root = Doc.init(title: "Root", path: "Home", type: "folder", uploaded: "", lastUpdate: "", size: 0)
    var currentFolder : Doc!
    
    init() {
        currentFolder = root
        root.parent = nil
    }
    
    public func getCurrentDocs() -> [Doc]{
        return currentFolder.childs
    }
    
    public func goToParent(){
        currentFolder = currentFolder.parent
    }
    public func goToChild(childDoc: Doc){
        currentFolder = childDoc
    }
    
}
