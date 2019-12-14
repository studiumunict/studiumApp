//
//  BookingTableDataSource.swift
//  Studium
//
//  Created by Simone Scionti on 13/12/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//


class BookingTableDataSource: NSObject, UITableViewDataSource {
    
    internal let cellIdentifier = "bookingCell"
    
    var items: [BookingTableSection] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items[section].expanded {
              return items[section].booking.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! BookingTableViewCell
        cell.setInfo(bookingData: items[indexPath.section].booking[indexPath.row])
        return cell
    }
    
    func insertBookings(sourceArray: [BookingTableSection]){
        self.items = sourceArray
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
}
