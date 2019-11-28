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
    
    static public func getUniqueIstance()-> PermanentDocSystem{
        if obj == nil{
            obj = getFS()
        }
        return obj
    }
  
    static private func getFS() -> PermanentDocSystem{
        //CoreDataController.shared.removeFileSystem()
        if let coreDataFS = CoreDataController.shared.getFileSystem() {
            return coreDataFS
        } else {
            let pds = PermanentDocSystem()
            return pds
        }
    }
    
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
