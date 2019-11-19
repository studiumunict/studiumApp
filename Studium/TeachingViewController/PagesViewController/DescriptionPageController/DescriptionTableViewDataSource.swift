//
//  DescriptionTableViewDataSource.swift
//  Studium
//
//  Created by Simone Scionti on 12/11/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation

class DescriptionTableDataSource: NSObject, UITableViewDataSource {
    
    internal let cellIdentifier = "descriptionCell"
    
    var items: [DescriptionBlock] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! DescriptionTableViewCell
        cell.setInfo(descBlock: items[indexPath.row])
        return cell
    }
    
    func insertDescriptionBlocks(sourceArray: [DescriptionBlock]){
        self.items = sourceArray
    }
}
