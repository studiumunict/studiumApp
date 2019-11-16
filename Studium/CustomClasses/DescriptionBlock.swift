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
        self.contentHTML = HTMLParser.getUniqueIstance().parseHTMLText(text: contentHTML)
    }
}
