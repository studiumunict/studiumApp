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
    
    
    
    
    
// MARK: CDEFileSystem
    
    ///Salva nel CoreData il riferimento al fs, passato come parametro
    func saveFileSystem(_ obj: PermanentDocSystem) {
        do {
            let results = try self.context.fetch(CDEFileSystem.fetchRequest() as NSFetchRequest<CDEFileSystem>)
            
            if results.first != nil { // Aggiorna
                results.first!.setFs(obj)
            
            } else {
                let tmp = CDEFileSystem(entity: NSEntityDescription.entity(forEntityName: "CDEFileSystem", in: self.context)!, insertInto: self.context)
                
                tmp.setFs(obj)
            }
            
            CoreDataController.shared.saveContext(anyError: "[CDC]: Impossibile salvare l'object fs")
        
        } catch let error {
            print("[CDC]: \(error)")
        }
    }
    
    ///Rimuove l'unico fs salvato nel CoreData
    func removeFileSystem() {
        do {
            let results = try self.context.fetch(CDEFileSystem.fetchRequest() as NSFetchRequest<CDEFileSystem>)
            
            for x in results {
                CoreDataController.shared.context.delete(x)
            }
            
            CoreDataController.shared.saveContext(anyError: "[CDC]: Impossibile eliminare il fs")
            
        } catch let error {
            print("[CDC]: \(error)")
        }
    }
    
    ///Prende l'unico fs salvato nel CoreData altrimenti restituisce nil
    func getFileSystem() -> PermanentDocSystem? {
        do {
            let results = try self.context.fetch(CDEFileSystem.fetchRequest() as NSFetchRequest<CDEFileSystem>)
            
            if results.first != nil {
                return results.first!.fs
            }
        
        } catch let error {
            print("[CDC]: \(error)")
        }
        
        print("[CDC - getFileSystem]: non è stato trovato alcun fs salvato nel CoreData")
        return nil
    }

}
