//
//  NotifyCell.swift
//  Studium
//
//  Created by Francesco Petrosino on 12/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit
import WebKit

class NotifyCell: UITableViewCell {
    
    @IBOutlet weak var descriptionMessageWebView: WKWebView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var dataLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var carret: UIImageView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var descriptionView: UIView!
    var isCollapsed = true
   
    override func awakeFromNib() {
        selectionStyle = .none
        //#colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        carret.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate);
        carret.tintColor = UIColor.elementsLikeNavBarColor
        
        self.contentView.backgroundColor = UIColor.clear
        headerView.backgroundColor = UIColor.lightSectionColor
        headerView.layer.cornerRadius = 5.0
        headerView.clipsToBounds = true
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggle))
        gesture.numberOfTapsRequired = 1
        headerView.isUserInteractionEnabled = true
        headerView.addGestureRecognizer(gesture)
        
        descriptionLabel.textColor = UIColor.elementsLikeNavBarColor
        titleLabel.textColor = UIColor.elementsLikeNavBarColor
        dataLabel.textColor = UIColor.subTitleGray
        
        self.stackView.arrangedSubviews[1].isHidden = true
    }
    
    
    func setInfo(data: String, title: String, description: String) {
        dataLabel.text = data
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    @objc private func toggle() {
        collapseOrExpandDescription()
        rotateArrows180Degrees(imageView: carret, animated: true)
    }
    
    private func rotateArrows180Degrees(imageView: UIImageView, animated: Bool){
        if !isCollapsed{
            if animated{
                UIView.animate(withDuration: 0.2) {
                    imageView.transform = CGAffineTransform(rotationAngle: .pi)
                }
            }
            else {
                imageView.transform = CGAffineTransform(rotationAngle: .pi)
            }
        
        } else {
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
    
    private func collapseOrExpandDescription(){
        if self.isCollapsed { self.isCollapsed = false; }
        else{ self.isCollapsed = true }
        UIView.animate(withDuration: 0.3) {
              self.stackView.arrangedSubviews[1].isHidden = self.isCollapsed
        }
        self.updateSuperTableView()
    }
    
    private func updateSuperTableView(){
        let tableView = self.superview as? UITableView
        tableView?.beginUpdates()
        tableView?.endUpdates()
    }
    
}
