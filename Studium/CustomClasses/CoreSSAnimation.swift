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
        if let _ = oscureView {oscureView.alpha = 0.0}
        if let _ = oscureView {oscureView.isHidden = false}
        viewToOpen.alpha = 0.0
        viewToOpen.isHidden = false
        let initialCenter =  viewToOpen.center
        viewToOpen.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        viewToOpen.center = CGPoint(x: sourceView.center.x + 10, y: sourceView.center.y + 5)
        UIView.animate(withDuration: 0.2, animations: {
           
            if let _ = oscureView {oscureView.alpha = 0.6}
            viewToOpen.transform = CGAffineTransform(scaleX: 0.15, y: 0.15)
            viewToOpen.alpha = 0.8
            
        }) { (flag) in
            
            UIView.animate(withDuration: 0.4, animations: {
                if let _ = oscureView {oscureView.alpha = 0.9}
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
                   if let _ = oscureView {oscureView.alpha = 0.6}
               }) { (f) in
                   UIView.animate(withDuration: 0.2, animations: {
                        viewToCollapse.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                        if let _ = oscureView {oscureView.alpha = 0.0}
                        if let subviews = elementsInsideView{
                            for subv in subviews{
                                subv.alpha = 1.0
                            }
                        }
                   }, completion: { (f) in
                       viewToCollapse.isHidden = true
                       if let _ = oscureView {oscureView.isHidden = true}
                       completion(true)
                   })
               }
    }
    
    public func expandViewFromSourceFrame(sourceFrame: CGRect, viewToExpand: UIView, elementsInsideView : [UIView]!,oscureView: UIView!,  completion: @escaping(Bool)->Void){
        viewToExpand.center = CGPoint(x: sourceFrame.origin.x + sourceFrame.width/2  , y: sourceFrame.origin.y + sourceFrame.height/2 )
       
        if let _ = oscureView {oscureView.isHidden = false}
        if let _ = oscureView {oscureView.alpha = 0.0}
               UIView.animate(withDuration: 0.3, animations: {
                if let _ = oscureView {oscureView.alpha = 0.6}
                   viewToExpand.transform = CGAffineTransform(scaleX: 1, y: 0.5)
                   viewToExpand.alpha = 1.0
               }) { (flag) in
                   UIView.animate(withDuration: 0.3) {
                    if let _ = oscureView {oscureView.alpha = 0.9}
                    viewToExpand.transform = .identity
                    viewToExpand.center = CGPoint(x: viewToExpand.superview!.center.x , y: viewToExpand.superview!.center.y - 100 )
                    completion(true)
                       //porta a 1 gli alpha degli elementi della view
                       //fai un for con le subviews
                       //teacherNameLabel.alpha = 1.0
                       //teachingNameLabel.alpha = 1.0
                   }
               }
    }
    public func collapseViewInSourceFrame(sourceFrame: CGRect, viewToCollapse: UIView, oscureView: UIView!, elementsInsideView : [UIView]!, completion: @escaping(Bool)->Void){
        UIView.animate(withDuration: 0.3, animations: {
            if let _ = oscureView { oscureView.alpha = 0.6}
            viewToCollapse.center = CGPoint(x: sourceFrame.origin.x + sourceFrame.width/2  , y: sourceFrame.origin.y + sourceFrame.height/2 )
            viewToCollapse.transform = CGAffineTransform(scaleX: 1, y: 0.5)
            //porta a 0 gli alpha degli elementi della view
            // teacherNameLabel.alpha = 0.0
            // teachingNameLabel.alpha = 0.0
        }) { (flag) in
            
            UIView.animate(withDuration: 0.3, animations: {
                viewToCollapse.transform = CGAffineTransform(scaleX: 1, y: 0.01)
                if let _ = oscureView {oscureView.alpha = 0.0}
                viewToCollapse.alpha = 0.0
            }, completion: { (f) in
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
    public func openViewWithFadeIn(viewToOpen: UIView, completion: @escaping (Bool)->Void ){
        viewToOpen.alpha = 0.0
        viewToOpen.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            viewToOpen.alpha = 1.0
        }) { (flag) in
            completion(true)
        }
    }
    public func closeViewWithFadeIn(viewToClose: UIView, completion: @escaping (Bool)->Void ){
        UIView.animate(withDuration: 0.3, animations: {
            viewToClose.alpha = 0.0
        }) { (flag) in
            viewToClose.isHidden = true
            viewToClose.alpha = 1.0
            completion(true)
        }
    }
}

