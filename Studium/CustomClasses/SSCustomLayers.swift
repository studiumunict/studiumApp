//
//  SSCustomLayers.swift
//  Studium
//
//  Created by Simone Scionti on 26/11/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation

class SSCustomLayers {
    static var obj : SSCustomLayers!
    
    static func getUniqueIstance() -> SSCustomLayers{
        if obj == nil{
            obj = SSCustomLayers()
        }
        return obj
    }
    
    private init(){}
    
    func roundCorners(corners:UIRectCorner, radius:CGFloat, view : UIView) {
        let bounds = view.bounds
        
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        
        view.layer.mask = maskLayer
        
        let frameLayer = CAShapeLayer()
        frameLayer.frame = bounds
        frameLayer.path = maskPath.cgPath
        frameLayer.strokeColor = UIColor.secondaryBackground.cgColor
        frameLayer.lineWidth = 3.0
        frameLayer.fillColor = nil
        
        view.layer.addSublayer(frameLayer)
    }
    
    func roundLeftRadius(radius:CGFloat, view : UIView) {
        self.roundCorners(corners: [UIRectCorner.topLeft, UIRectCorner.bottomLeft], radius:radius, view: view)
    }
    
    func roundRightRadius(radius:CGFloat, view : UIView) {
        self.roundCorners(corners: [UIRectCorner.topRight, UIRectCorner.bottomRight], radius:radius, view: view)
    }
    func roundBottomRadius(radius:CGFloat, view : UIView) {
        self.roundCorners(corners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], radius:radius, view: view)
    }
    func roundTopRadius(radius:CGFloat, view : UIView) {
        self.roundCorners(corners: [UIRectCorner.topLeft, UIRectCorner.topRight], radius:radius, view: view)
    }
    
}
