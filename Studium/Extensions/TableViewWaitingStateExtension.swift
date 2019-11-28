//
//  TableViewWaitingStateExtension.swift
//  Studium
//
//  Created by Simone Scionti on 28/11/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation

extension UITableView{
    struct waitingIndicator {
        static var _indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    }
    var indicatorForWaiting: UIActivityIndicatorView {
        get {
            return waitingIndicator._indicator
        }
        set(newValue) {
            waitingIndicator._indicator = newValue
        }
    }
    func startWaitingData(){
        indicatorForWaiting.contentMode = .redraw
        indicatorForWaiting.setNeedsLayout()
        indicatorForWaiting.setNeedsDisplay()
        indicatorForWaiting.style = UIActivityIndicatorView.Style.medium
        indicatorForWaiting.center = self.center
        self.addSubview(indicatorForWaiting)
        indicatorForWaiting.translatesAutoresizingMaskIntoConstraints = false
        if self.backgroundColor == UIColor.primaryBackground{
            indicatorForWaiting.color = UIColor.lightSectionColor
            NSLayoutConstraint(item: indicatorForWaiting, attribute: .top, relatedBy: .equal, toItem: self, attribute: .topMargin, multiplier: 1.0, constant: 5.0).isActive = true
        }
        else{
            indicatorForWaiting.color = UIColor.primaryBackground
            NSLayoutConstraint(item: indicatorForWaiting, attribute: .top, relatedBy: .equal, toItem: self, attribute: .topMargin, multiplier: 1.0, constant: 45.0).isActive = true
        }
         NSLayoutConstraint(item: indicatorForWaiting, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        indicatorForWaiting.layer.zPosition = 5
        indicatorForWaiting.startAnimating()
        
        
    }
    
    func stopWaitingData(){
       indicatorForWaiting.stopAnimating()
       indicatorForWaiting.removeFromSuperview()
    }
}
