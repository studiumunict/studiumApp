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
    
    init(){}
    
    init(date: String!, title: String!, message: String!){
        self.date = date
        self.title = title
        self.message = parseHTMLText(text: message)
    }
    private func parseHTMLText(text: String)-> String{
        var str = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        str = str.replacingOccurrences(of: "&#39;", with: "'", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "&nbsp;", with: "", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "&ograve;", with: "ò", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "&quot;", with: "\"", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "&rsquo;", with: "'", options: .caseInsensitive, range: nil)    
        var i = str.count-1
        var char = false
        while(i >= 0 && !char){
            if(str[i] != " "){
                char = true
            }
            else{i-=1}
        }
        let finalStr = String(str.dropLast(str.count-1-i))
        return finalStr
    }
}

