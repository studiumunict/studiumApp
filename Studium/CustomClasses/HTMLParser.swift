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
    
    private func addHTMLExtension(title: String)->String{
        if title.lastIndex(of: ".") == nil{
            return title+".html"
        }
        return title
    }
    public func parseFileTitle(text:String)->String{
        let str = parseHTMLText(text: text)
        return addHTMLExtension(title: str)
    }
    public func parseFolderTitle(text:String)->String{
        return parseHTMLText(text: text)
    }
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
        str = str.replacingOccurrences(of: "/*", with: "", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "*/", with: "", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "&#64257;", with: "fi", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "&#64256;", with: "ff", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "&ldquo;", with: "\"", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "&rdquo;", with: "\"", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "&amp;", with: "", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "#768;", with: "", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "&#8217;", with: "'", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "&gt;", with: ">", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "&lt;", with: "<", options: .caseInsensitive, range: nil)
        return str
    }
    public func getStringURL(sourceString: String)-> String{
        let str = sourceString.replacingOccurrences(of: " ", with: "%20", options: .caseInsensitive, range: nil)
        return str
    }
}
