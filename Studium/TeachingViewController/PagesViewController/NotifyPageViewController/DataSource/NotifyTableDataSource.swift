//
//  DataSource.swift
//  Studium
//
//  Created by Francesco Petrosino on 12/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

struct ContentCell {
    let data: String!
    let title: String!
    let description: String!
}

class NotifyTableDataSource: NSObject, UITableViewDataSource {
    
    internal let cellIdentifier = "notifyCell"
    
    var items: [ContentCell] = []
    
    //fileprivate var indexPaths: Set<IndexPath> = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! NotifyCell
        
        cell.setInfo(data: items[indexPath.row].data, title: items[indexPath.row].title, description: items[indexPath.row].description)
        if cell.isCollapsed == false{
            print("Espansa")
        }
        //cell.state = cellIsExpanded(at: indexPath) ? .expanded : .collapsed
        
        return cell
    }
    
    func insertNotifies(sourceArray: [Notify]){
        for notify in sourceArray{
            self.items.append(ContentCell(data: notify.date, title: notify.title, description: notify.message))
        }
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
