//
//  DataSource.swift
//  Studium
//
//  Created by Francesco Petrosino on 12/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//


class NotifyTableDataSource: NSObject, UITableViewDataSource {
    
    internal let cellIdentifier = "notifyCell"
    
    var items: [Notify] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! NotifyCell
        
        cell.setInfo(notifyData: items[indexPath.row])
        return cell
    }
    
    func insertNotifies(sourceArray: [Notify]){
        self.items = sourceArray
    }
}
