//
//  NotifyCell.swift
//  Studium
//
//  Created by Francesco Petrosino on 12/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

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
   
    override func awakeFromNib() {
          selectionStyle = .none
          setupCarret()
          setupDescriptionLabel()
          self.contentView.backgroundColor = UIColor.clear
          setupHeaderView()
          dataLabel.textColor = UIColor.lightGray
          setupElementsView()
          setupCarretView()
          setupTitleLabel()
    }
    fileprivate func setupElementsView() {
        self.elementsView.backgroundColor = UIColor.clear
        self.elementsView.layer.cornerRadius = 10.0
        self.elementsView.layer.borderWidth = 1.0
        self.elementsView.layer.borderColor = UIColor.elementsLikeNavBarColor.cgColor
        self.elementsView.clipsToBounds = true
    }
    
    fileprivate func setupCarretView() {
        self.carretView.layer.cornerRadius = self.carretView.frame.size.width / 2
        self.carretView.clipsToBounds = true
        self.carretView.backgroundColor = UIColor.lightSectionColor
    }
    
    fileprivate func setupTitleLabel() {
        titleLabel.textColor = UIColor.lightSectionColor
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingMiddle
    }
    
    fileprivate func setupHeaderView() {
        headerView.backgroundColor = UIColor.elementsLikeNavBarColor
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggle))
        gesture.numberOfTapsRequired = 1
        headerView.isUserInteractionEnabled = true
        headerView.addGestureRecognizer(gesture)
    }
    
    fileprivate func setupDescriptionLabel() {
        self.descriptionLabel.adjustsFontSizeToFitWidth = true
        self.descriptionLabel.sizeToFit()
    }
    
    fileprivate func setupCarret() {
        carret.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate);
        carret.tintColor = UIColor.elementsLikeNavBarColor
    }
    
   
    func setInfo(notifyData : Notify ) {
        self.notifyData = notifyData
        dataLabel.text = notifyData.date
        titleLabel.text = notifyData.title
        descriptionLabel.text = notifyData.message
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
        collapseOrExpandDescription()
        let SSAnimator = CoreSSAnimation.getUniqueIstance()
        SSAnimator.rotate180Degrees(view: carret, animated: true)
    }
    
    func collapseOrExpandDescription(){
        if self.notifyData.isCellExpanded { self.notifyData.isCellExpanded = false; }
        else{ self.notifyData.isCellExpanded = true }
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
