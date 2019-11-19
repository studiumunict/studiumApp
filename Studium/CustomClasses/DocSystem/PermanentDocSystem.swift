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
       // CoreDataController.shared.removeFileSystem()
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
    
    override func appendChild(toDoc: Doc, child: Doc) -> Doc {
        let appendedDoc = super.appendChild(toDoc: toDoc, child: child)
        CoreDataController.shared.saveFileSystem(self)
        return appendedDoc
    }
    override func appendChilds(toDoc: Doc, childs: [Doc]) {
        super.appendChilds(toDoc: toDoc, childs: childs)
        CoreDataController.shared.saveFileSystem(self)
    }
    override func removeChilds(childs: [Doc]) {
        super.removeChilds(childs: childs)
        CoreDataController.shared.saveFileSystem(self)
    }
    override func removeChild(child: Doc) {
        super.removeChild(child: child)
        CoreDataController.shared.saveFileSystem(self)
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
