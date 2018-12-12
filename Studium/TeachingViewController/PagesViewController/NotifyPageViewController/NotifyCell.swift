//
//  NotifyCell.swift
//  Studium
//
//  Created by Francesco Petrosino on 12/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class NotifyCell: UITableViewCell {
    
    enum CellState {
        case collapsed
        case expanded
    }
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var dataLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var carret: UIImageView! //Freccetta animata che expanded or collapse
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var descriptionView: UIView!
    @IBOutlet private weak var contView: UIView!
    
    
    var state: CellState = .collapsed {
        didSet {
            toggle()
        }
    }
    
    override func awakeFromNib() {
        selectionStyle = .none
        
        carret.image = UIImage(named: "arrow");
        
        containerView.backgroundColor = UIColor.secondaryBackground
        containerView.layer.cornerRadius = 5.0
        containerView.layer.borderColor = UIColor.clear.cgColor
        
        descriptionLabel.textColor = UIColor.lightWhite
        titleLabel.textColor = UIColor.lightWhite
        dataLabel.textColor = UIColor.lightWhite
    }
    
    
    func update(data: String, title: String, description: String) {
        dataLabel.text = data
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    private func toggle() {
        hideStackView(toHidden: stateIsCollapsed())
        rotateArrows180Degrees(imageView: carret, animated: true)
    }
    
    private func stateIsCollapsed() -> Bool {
        return state == .collapsed
    }
    
    private func rotateArrows180Degrees(imageView: UIImageView, animated: Bool){
        if !stateIsCollapsed() {
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
    
    private func hideStackView(toHidden hidden: Bool){
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.stackView.arrangedSubviews[1].isHidden = hidden
        }, completion: nil)
    }
    
    
    
}
