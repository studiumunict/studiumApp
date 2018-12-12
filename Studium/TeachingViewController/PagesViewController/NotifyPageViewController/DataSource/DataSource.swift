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



class DataSource: NSObject, UITableViewDataSource {
    
    private let cellIdentifier = "notifyCell"
    
    var items: [ContentCell] = []
    
    fileprivate var indexPaths: Set<IndexPath> = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! NotifyCell
        
        cell.update(data: self[indexPath].data, title: self[indexPath].title, description: self[indexPath].description)
        
        cell.state = cellIsExpanded(at: indexPath) ? .expanded : .collapsed
        
        return cell
    }
    
    func cellIsExpanded(at indexPath: IndexPath) -> Bool {
        return indexPaths.contains(indexPath)
    }
    
    func addExpandedIndexPath(_ indexPath: IndexPath) {
        indexPaths.insert(indexPath)
    }
    
    func removeExpandedIndexPath(_ indexPath: IndexPath) {
        indexPaths.remove(indexPath)
    }
    
    subscript(indexPath: IndexPath) -> ContentCell {
        return items[indexPath.row]
    }
}
