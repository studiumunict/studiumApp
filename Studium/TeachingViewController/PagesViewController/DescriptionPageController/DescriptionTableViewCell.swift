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
    override func awakeFromNib() {
        super.awakeFromNib()
        self.elementsView.backgroundColor = UIColor.lightSectionColor
        self.elementsView.layer.cornerRadius = 5.0
        self.elementsView.clipsToBounds = true
    }
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionMessageLabel: UILabel!
    
    func setInfo(descBlock : DescriptionBlock){
        self.titleLabel.text = descBlock.title
        self.descriptionMessageLabel.text = descBlock.message
    }
  
    
}
