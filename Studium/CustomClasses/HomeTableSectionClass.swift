//
//  HomeTableSectionClass.swift
//  Studium
//
//  Created by Simone Scionti on 06/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import Foundation
class HomeTableSection{
    var course = CDL()//sarà la section (1)
    var expanded = false
    var teachings = [Teaching]() //saranno le row (array sottostante alla section)
    
    
    
    init(cdl : CDL, teachingArray : [Teaching]){
        self.course = cdl
        self.teachings = teachingArray
    }
    
}