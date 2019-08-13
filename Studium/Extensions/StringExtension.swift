//
//  StringExtension.swift
//  Studium
//
//  Created by Simone Scionti on 13/08/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation
extension String {
   private func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
