//
//  ConnectionErrorHandlerDelegate.swift
//  Studium
//
//  Created by Simone Scionti on 28/11/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation

protocol ConnectionErrorHandlerDelegate: AnyObject {
    func connectionErrorHandle(error: Error!)
}
