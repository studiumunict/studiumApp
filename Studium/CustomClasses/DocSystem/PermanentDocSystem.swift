//
//  MyDocSystem.swift
//  Studium
//
//  Created by Simone Scionti on 13/11/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation
class PermanentDocSystem: TempDocSystem{ //fileSystem singleton con autoSalvataggio permanente
    static var obj : PermanentDocSystem!
   // var usersTreeRoot = Doc.init(title: "usersRoot", path: "/usersRoot", type: "folder", courseID: "")
// TODO: da far funzionare questo filesystem
    
    static public func getUniqueIstance()-> PermanentDocSystem{
        if obj == nil{
            obj = getFS()
        }
        return obj
    }
  
    static private func getFS() -> PermanentDocSystem{
        //CoreDataController.shared.removeFileSystem()
        if let coreDataFS = CoreDataController.shared.getFileSystem() {
          //  self.findExistingRoot(pds: coreDataFS)
            print("trovato filesystem")
            return coreDataFS
        } else {
            print("istanzion nuovo filesystem")
            let pds = PermanentDocSystem()
          //  self.findExistingRoot(pds: pds)
            return pds
        }
    }
   /* private static func setRoot(pds: PermanentDocSystem, root: Doc){
        pds.root = root
        pds.currentFolder = root
    }
    
    private static func findExistingRoot(pds: PermanentDocSystem){
        for root in pds.usersTreeRoot.childs{
            if root.path == Student.getUniqueIstance().code{
                setRoot(pds: pds, root: root)
                return
            }
        }
        //non abbiamo trovato alcuna root corretta
        let newRoot = Doc.init(title: "root", path: Student.getUniqueIstance().code, type: "folder", courseID: "")
        //la aggiungi alla rootTree
        pds.usersTreeRoot.addChild(item: pds.root)
        setRoot(pds: pds, root: newRoot)
    }
    */
    override init(){
        super.init()
        
    }
    override func move(documents: [Doc], fromFolder: Doc, toFolder: Doc) {
        super.move(documents: documents, fromFolder: fromFolder, toFolder: toFolder)
        CoreDataController.shared.saveFileSystem(self)
    }
    override func appendChild(toDoc: Doc, child: Doc) -> Doc {
        let appendedDoc = super.appendChild(toDoc: toDoc, child: child)
        CoreDataController.shared.saveFileSystem(self)
        return appendedDoc
    }
    override func appendChilds(toDoc: Doc, childs: [Doc]) {
        super.appendChilds(toDoc: toDoc, childs: childs)
        CoreDataController.shared.saveFileSystem(self)
    }
    override func removeChilds(fromFolder fromfolder :Doc? = nil, childs: [Doc]) {
        super.removeChilds(fromFolder: fromfolder ,childs: childs)
        CoreDataController.shared.saveFileSystem(self)
    }
    override func removeChild(fromFolder fromfolder :Doc? = nil, child: Doc) {
        super.removeChild(fromFolder: fromfolder ,child: child)
        CoreDataController.shared.saveFileSystem(self)
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
