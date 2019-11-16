//
//  NotifyClass.swift
//  Studium
//
//  Created by Simone Scionti on 06/11/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation


class Notify { //Struttura contenente il titolo, data e corpo del messaggio di un Avviso
    var date: String!
    var title: String!
    var message: String!
    var isCellExpanded :Bool!
    
    init(){}
    
    init(date: String!, title: String!, message: String!){
        self.date = date
        self.title = title
        self.message = HTMLParser.getUniqueIstance().parseHTMLText(text: message)
        self.isCellExpanded = false
    }
    
   
}

