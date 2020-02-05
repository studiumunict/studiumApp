//
//  bookingDelegate.swift
//  Studium
//
//  Created by Simone Scionti on 04/02/2020.
//  Copyright © 2020 Unict.it. All rights reserved.
//

import Foundation

protocol BookingDelegate {
    func bookingConfirmed(booking: Booking) //send the istance ref. it can be useful if we update directly the tableView without any other API call
    func bookingCancelled(booking: Booking)
}
