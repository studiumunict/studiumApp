//
//  CoreDataController.swift
//  Studium
//
//  Created by Francesco Petrosino on 12/11/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation
import CoreData


class CoreDataController {
    
    static let shared = CoreDataController()
    
    let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    private var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func viewContext() -> NSManagedObjectContext {
        return self.context
    }
    
    func saveContext(anyError: String?) {
        do {
            try CoreDataController.shared.viewContext().save()
        } catch {
            if anyError != nil {
                print(anyError!)
            }
            print("\nStampo l'errore: \n \(error.localizedDescription) \n")
        }
    }
    
    private init() {}
    
    
    
    
    
    
    
    
    
    
    
    
}
