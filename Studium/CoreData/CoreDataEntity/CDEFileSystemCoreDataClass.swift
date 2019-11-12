//
//  CDEFileSystemCoreDataClass.swift
//  
//
//  Created by Francesco Petrosino on 12/11/2019.
//
//

import Foundation
import CoreData

@objc(CDEFileSystem)
public class CDEFileSystem: NSManagedObject {

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        fs = DocSystem()
    }
    
    func setFs(_ obj: DocSystem) {
        fs = obj
    }
    
}
