//
//  DocSystem.swift
//  Studium
//
//  Created by Simone Scionti on 11/11/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation

public class TempDocSystem: NSObject, NSCoding {
    
    var root = Doc.init(title: "Root", path: "/Root", type: "folder", uploaded: "", lastUpdate: "", size: 0,courseID: "")
    var currentFolder : Doc!
    
    override init() {
        super.init()
        currentFolder = root
        root.parent = nil
    }
    
    internal func getIndex(ofDoc: Doc, inFolder: Doc)->Int{
        var i = 0
        for doc in inFolder.childs{
            if doc.title == ofDoc.title { return i }
            i += 1
        }
        return -1
    }
    
    internal func checkIfDocExists(inFolder: Doc, name: String)-> Doc!{
        for doc in inFolder.childs{
            if doc.title == name { return doc }
        }
        return nil
    }
    func appendChilds(toDoc: Doc, childs: [Doc]){
        for child in childs{
           let _ = appendChild(toDoc: toDoc, child: child)
        }
    }
   
    func appendChild(toDoc:Doc,child:Doc)->Doc{
        let possibleDoc = checkIfDocExists(inFolder: toDoc, name: child.title)
        if let foundDoc = possibleDoc{ //se trovo il documento
            print("trovato")
            appendChilds(toDoc: foundDoc, childs: child.childs) //appendo i figli all'interno di quello trovato
            
            return foundDoc
        }
        else{ //caso base : documento non esistente, lo appendo
            toDoc.addChild(item:child)
            child.setParent(prev: toDoc)
            print("appeso")
            return child
        }
    }
    private func removeDoc(fromFolder: Doc, doc: Doc){
        let i = getIndex(ofDoc: doc, inFolder: fromFolder)
        fromFolder.childs.remove(at: i)
    }
    
    func move(documents: [Doc], fromFolder :Doc, toFolder: Doc){
        appendChilds(toDoc: toFolder, childs: documents)
        removeChilds(fromFolder: fromFolder, childs: documents)
    }
    
    func removeChilds(fromFolder: Doc? = nil, childs: [Doc]){
        var fromF = fromFolder
        if fromF == nil{
            fromF = currentFolder
        }
        for child in childs{
            removeChild(fromFolder: fromF! ,child: child)
        }
    }
    
    func removeChild(fromFolder: Doc? = nil, child: Doc){
        var fromF = fromFolder
        if fromF == nil{
            fromF = currentFolder
        }
        let i = getIndex(ofDoc: child, inFolder: fromF!)
        print("Trovato da rimuovere con indice: ", i)
        if i == -1 {return}
        fromF!.childs.remove(at: i)
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
    func removeAll(){
        currentFolder = root
        for c in root.childs {
            c.setParent(prev: nil)
        }
        root.childs.removeAll()
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(root, forKey: "root")
    }
    
    required public init?(coder: NSCoder) {
        root = coder.decodeObject(forKey: "root") as! Doc
        currentFolder = root
    }
    
}
