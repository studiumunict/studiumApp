//
//  DocsClass.swift
//  Studium
//
//  Created by Francesco Petrosino on 19/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import Foundation


class Docs {
    let TypeDoc: typeDocs!
    let CanOpen: Bool!
    
    var ID = String()
    var path: String!
    var prev: Docs!
    var next = [Docs]()
    
    enum typeDocs {
        case file
        case folder
    }
    
    init(path: String, type: typeDocs) {
        self.path = path
        self.TypeDoc = type
        self.CanOpen = true
        self.ID = addressOf(self)
    }
    
    func setPrev(prev: Docs!) {
        self.prev = prev
        
        if self.prev != nil {
            self.prev.setNext(items: [self])
        }
    }
    
    func setNext(items: [Docs]) {
        for x in items {
            self.next.append(x)
        }
    }
    
    private func addressOf<Docs>(_ o: Docs) -> String {
        let addr = unsafeBitCast(o, to: Int.self)
        return String(format: "%p", addr)
    }
}

extension Docs: Equatable {
    static func == (left: Docs, right: Docs) -> Bool {
        return left.ID == right.ID
    }
    
    static func != (left: Docs, right: Docs) -> Bool {
        return left.ID != right.ID
    }
}
