//
//  NotifyCell.swift
//  Studium
//
//  Created by Francesco Petrosino on 12/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit
//import WebKit

class NotifyCell: UITableViewCell {
    
    @IBOutlet weak var carretView: UIView!
    @IBOutlet weak var elementsView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet private weak var dataLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet weak var carret: UIImageView!
    @IBOutlet private weak var headerView: UIView!
    var notifyData : Notify!
    //var isCollapsed = true
   
    override func awakeFromNib() {
        selectionStyle = .none
        //#colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        carret.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate);
        carret.tintColor = UIColor.elementsLikeNavBarColor
        self.descriptionLabel.adjustsFontSizeToFitWidth = true
        self.descriptionLabel.sizeToFit()
        
        self.contentView.backgroundColor = UIColor.clear
        headerView.backgroundColor = UIColor.elementsLikeNavBarColor
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggle))
        gesture.numberOfTapsRequired = 1
        headerView.isUserInteractionEnabled = true
        headerView.addGestureRecognizer(gesture)
        
        //descriptionLabel.textColor = UIColor.lightWhite
        titleLabel.textColor = UIColor.lightWhite
        dataLabel.textColor = UIColor.lightGray
        /*descriptionLabel.textColor = UIColor.elementsLikeNavBarColor
        titleLabel.textColor = UIColor.elementsLikeNavBarColor
        dataLabel.textColor = UIColor.subTitleGray*/
        
        self.elementsView.backgroundColor = UIColor.clear
        self.elementsView.layer.cornerRadius = 5.0
        self.elementsView.layer.borderWidth = 1.0
        self.elementsView.layer.borderColor = UIColor.elementsLikeNavBarColor.cgColor
        self.elementsView.clipsToBounds = true
        
        self.carretView.layer.cornerRadius = self.carretView.frame.size.width / 2
        self.carretView.clipsToBounds = true
        self.carretView.backgroundColor = UIColor.lightWhite
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingMiddle
        
    }
    
    
    func setInfo(notifyData : Notify ) {
        self.notifyData = notifyData
        dataLabel.text = notifyData.date
        titleLabel.text = notifyData.title
        descriptionLabel.text = notifyData.message
        //updateSuperTableView()
        setDescriptionLayerState(hidden: !notifyData.isCellExpanded)
        setArrowLayerState(rotate: notifyData.isCellExpanded)
    }
    func setArrowLayerState(rotate: Bool){
        if !rotate{
            self.carret.transform = CGAffineTransform.identity
        }
        else{
            self.carret.transform = CGAffineTransform.init(rotationAngle: .pi)
        }
    }
    func setDescriptionLayerState(hidden: Bool){
        self.stackView.arrangedSubviews[1].isHidden = hidden
        self.updateConstraints()
    }
    
    @objc private func toggle() {
        print("Apertura cella")
        collapseOrExpandDescription()
        let SSAnimator = CoreSSAnimation.getUniqueIstance()
        SSAnimator.rotate180Degrees(view: carret, animated: true)
    }
    
    
      func collapseOrExpandDescription(){
        
        if self.notifyData.isCellExpanded { self.notifyData.isCellExpanded = false; }
        else{ self.notifyData.isCellExpanded = true }
       
       /* tableView?.beginUpdates()
        UIView.animate(withDuration: 0.3, animations: {
            self.stackView.arrangedSubviews[1].isHidden = !self.notifyData.isCellExpanded
        }) { (flag) in
            tableView?.endUpdates()
        }*/
        UIView.animate(withDuration: 0.3) {
            self.stackView.arrangedSubviews[1].isHidden = !self.notifyData.isCellExpanded
        }
        
        self.updateSuperTableView()
    }
    
    private func updateSuperTableView(){
        let tableView = self.superview as? UITableView
        tableView?.beginUpdates()
        tableView?.endUpdates()
    }
    
}
