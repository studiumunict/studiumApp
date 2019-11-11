//
//  CoreSSAnimation.swift
//  Studium
//
//  Created by Simone Scionti on 11/11/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation

class CoreSSAnimation{
    static var obj : CoreSSAnimation!
    private init(){ }
    public static func getUniqueIstance() -> CoreSSAnimation{
        if obj == nil {
            obj =  CoreSSAnimation()
        }
        return obj
    }
    
    public func expandViewFromSourceView(viewToOpen: UIView, elementsInsideView: [UIView]!, sourceView: UIView, oscureView: UIView!, completion: @escaping (Bool)->Void) {
        if let subviews = elementsInsideView{
            for subv in subviews{
                subv.alpha = 0.0
            }
        }
        oscureView.alpha = 0.0
        oscureView.isHidden = false
        viewToOpen.isHidden = false
        let initialCenter =  viewToOpen.center
        viewToOpen.center = CGPoint(x: sourceView.center.x + 10, y: sourceView.center.y + 5)
        viewToOpen.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        viewToOpen.alpha = 0.0
        UIView.animate(withDuration: 0.2, animations: {
            oscureView.alpha = 0.6
            viewToOpen.transform = CGAffineTransform(scaleX: 0.15, y: 0.15)
            viewToOpen.alpha = 0.8
        }) { (flag) in
            UIView.animate(withDuration: 0.4, animations: {
                oscureView.alpha = 0.9
                viewToOpen.transform = .identity
                viewToOpen.center =  initialCenter
                //porta a 1 gli alpha degli elementi della view
                if let subviews = elementsInsideView{
                    for subv in subviews{
                        subv.alpha = 1.0
                    }
                }
                viewToOpen.alpha = 1.0
                
                   }) { (f) in
                       completion(true)
                   }
               }
    }
    
    public func collapseViewInSourceView(viewToCollapse: UIView, elementsInsideView: [UIView]!, sourceView: UIView, oscureView: UIView!, completion: @escaping (Bool)->Void) {
        UIView.animate(withDuration: 0.4, animations: {
                   viewToCollapse.center = CGPoint(x: sourceView.center.x + 10, y: sourceView.center.y + 5)
                   viewToCollapse.transform = CGAffineTransform(scaleX: 0.15, y: 0.15)
                   oscureView.alpha = 0.6
               }) { (f) in
                   UIView.animate(withDuration: 0.2, animations: {
                        viewToCollapse.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                        oscureView.alpha = 0.0
                        if let subviews = elementsInsideView{
                            for subv in subviews{
                                subv.alpha = 1.0
                            }
                        }
                   }, completion: { (f) in
                       viewToCollapse.isHidden = true
                       oscureView.isHidden = true
                       completion(true)
                   })
               }
    }
    
    public func rotate180Degrees(view : UIView,animated : Bool){
        if let imageView = view as? UIImageView{
            rotate180DegreesImageView(imageView: imageView, animated: animated)
            return
        }
        for view in view.subviews{
            if let imageView = view as? UIImageView{
                rotate180DegreesImageView(imageView: imageView, animated: animated)
            }
        }
    }
    
    private func rotate180DegreesImageView(imageView: UIImageView, animated: Bool){
           if imageView.transform == .identity{
               if animated{
                   UIView.animate(withDuration: 0.2) {
                       imageView.transform = CGAffineTransform(rotationAngle: .pi)
                   }
               }
               else {
                   imageView.transform = CGAffineTransform(rotationAngle: .pi)
               }
           }
           else{
               if animated {
                   UIView.animate(withDuration: 0.2) {
                       imageView.transform = .identity
                   }
               }
               else{
                   imageView.transform = .identity
               }
           }
       }
    
}

