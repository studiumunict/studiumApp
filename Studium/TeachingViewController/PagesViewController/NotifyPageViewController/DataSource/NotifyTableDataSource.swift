//
//  DataSource.swift
//  Studium
//
//  Created by Francesco Petrosino on 12/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class NotifyTableDataSource: NSObject, UITableViewDataSource {
    
    internal let cellIdentifier = "notifyCell"
    
    var items: [Notify] = []
    
    //fileprivate var indexPaths: Set<IndexPath> = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! NotifyCell
        cell.setInfo(notifyData: items[indexPath.row])
        if items[indexPath.row].isCellExpanded{
            print("Espansa")
        }
        //cell.state = cellIsExpanded(at: indexPath) ? .expanded : .collapsed
        
        return cell
    }
    
    func insertNotifies(sourceArray: [Notify]){
        self.items = sourceArray
    }
    
    /*func cellIsExpanded(at indexPath: IndexPath) -> Bool {
        return indexPaths.contains(indexPath)
    }*/
    
    /*func addExpandedIndexPath(_ indexPath: IndexPath) {
        indexPaths.insert(indexPath)
    }
    
    func removeExpandedIndexPath(_ indexPath: IndexPath) {
        indexPaths.remove(indexPath)
    }*/
    
    /*subscript(indexPath: IndexPath) -> ContentCell {
        return items[indexPath.row]
    }*/
}
