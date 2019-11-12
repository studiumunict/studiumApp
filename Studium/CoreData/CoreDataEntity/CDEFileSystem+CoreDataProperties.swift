//
//  CDEFileSystem+CoreDataProperties.swift
//  
//
//  Created by Francesco Petrosino on 12/11/2019.
//
//

import Foundation
import CoreData


extension CDEFileSystem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDEFileSystem> {
        return NSFetchRequest<CDEFileSystem>(entityName: "CDEFileSystem")
    }

    @NSManaged public var fs: DocSystem

}
