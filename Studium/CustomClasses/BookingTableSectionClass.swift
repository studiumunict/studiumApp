//
//  BookingTableSectionClass.swift
//  Studium
//
//  Created by Simone Scionti on 13/12/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation

class BookingTableSection {
    let sectionName : String!
    let booking : [Booking]!
    var expanded : Bool!
    
    init(sectionName: String, booking : [Booking]){
        self.sectionName = sectionName
        self.booking = booking
        expanded = true
    }
}
