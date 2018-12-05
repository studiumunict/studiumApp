//
//  ExtensionCALayer.swift
//  Studium
//
//  Created by Francesco Petrosino on 05/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

extension CALayer {
    
    //Aggiunge un bordo in uno dei quattro lati dati in input come parametro 'edge', [Es:] edge: UIRectEdge.bottom
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        self.addSublayer(border)
    }
    
}
