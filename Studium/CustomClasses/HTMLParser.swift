//
//  HTMLParser.swift
//  Studium
//
//  Created by Simone Scionti on 16/11/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation
class HTMLParser {
    static var obj : HTMLParser!
    
    static func getUniqueIstance() -> HTMLParser{
        if obj == nil {
            obj = HTMLParser()
        }
        return obj
    }
    
    private init(){}
    
    public func parseHTMLText(text: String)-> String{
        var str = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        str = str.replacingOccurrences(of: "&#39;", with: "'", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "&#039;", with: "'", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "&nbsp;", with: "", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "&quot;", with: "\"", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "&rsquo;", with: "'", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "&agrave;", with: "à", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "&egrave;", with: "è", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "&igrave;", with: "ì", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "&ograve;", with: "ò", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "&ugrave;", with: "ù", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "    ", with: "", options: .caseInsensitive, range: nil)
        return str
    }
}
