//
//  DescriptionBlock.swift
//  Studium
//
//  Created by Simone Scionti on 12/11/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation
class DescriptionBlock{
    var title : String!
    var contentHTML : String!
    
    init(title: String, contentHTML: String){
        self.title = title
        self.contentHTML = parseHTMLText(text: contentHTML)
    }
    private func parseHTMLText(text: String)-> String{
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
        str = str.replacingOccurrences(of: "/*", with: "", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "*/", with: "", options: .caseInsensitive, range: nil)
        str = str.replacingOccurrences(of: "    ", with: "", options: .caseInsensitive, range: nil)
       /* var i = str.count-1
        var char = false
        while(i >= 0 && !char){
            if(str[i] != " "){
                char = true
            }
            else{i-=1}
        }
        var finalStr = String(str.dropLast(str.count-1-i))
        i = 0
        var lastIndex = -1
        while (i < finalStr.count && !char){
            let index = finalStr.firstIndex(of: " ")
            if(index == lastIndex + 1){
                finalStr.remove(at: index)
            }
            else{ break }
            i+=1
        }
        print("Elimino i primi", i)
        finalStr = String(finalStr.dropFirst(i))*/
        return str
    }
}
