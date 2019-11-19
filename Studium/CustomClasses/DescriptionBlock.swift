//
//  DescriptionBlock.swift
//  Studium
//
//  Created by Simone Scionti on 12/11/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation
class DescriptionBlock : Notify { //eredito da Notify perchè sono molto simili
    init(title: String, message: String){
        super.init(date: "", title: title, message:  message)
        self.isCellExpanded = true
    }
}
