//
//  DocsClass.swift
//  Studium
//
//  Created by Francesco Petrosino on 19/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import Foundation


class Docs {
    let path: String!
    let type: typeDocs!
    let canOpen: Bool!
    
    var prev: Docs!
    var next = [Docs]()
    
    enum typeDocs {
        case file
        case folder
    }
    
    init(path: String, type: typeDocs) {
        self.path = path
        self.type = type
        self.canOpen = true
    }
    
    func setPrev(prev: Docs!) {
        self.prev = prev
        
        if self.prev != nil {
            self.prev.setNext(next: [self])
        }
    }
    
    func setNext(next: [Docs]) {
        for x in next {
            self.next.append(x)
        }
    }
}
