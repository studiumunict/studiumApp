//
//  DescriptionTableViewCell.swift
//  Studium
//
//  Created by Simone Scionti on 12/11/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation
import UIKit
class DescriptionTableViewCell : UITableViewCell{
    
    @IBOutlet weak var elementsView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.elementsView.backgroundColor = UIColor.clear
        self.elementsView.layer.cornerRadius = 5.0
        self.elementsView.layer.borderWidth = 1.0
        self.elementsView.layer.borderColor = UIColor.elementsLikeNavBarColor.cgColor
        self.elementsView.clipsToBounds = true
        self.titleLabel.backgroundColor = UIColor.elementsLikeNavBarColor
        self.titleLabel.textColor = UIColor.lightWhite
    }
    
    func setInfo(descBlock : DescriptionBlock){
        self.titleLabel.text = descBlock.title
        self.descriptionMessageLabel.text = descBlock.message
    }
  
    
}
