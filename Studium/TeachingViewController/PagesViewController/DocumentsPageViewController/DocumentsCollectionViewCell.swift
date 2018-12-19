//
//  DocumentsCollectionViewCell.swift
//  Studium
//
//  Created by Francesco Petrosino on 19/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class DocumentsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageDoc: UIImageView!
    @IBOutlet var titleDocLabel: UILabel!
    @IBOutlet var numberOfSubDocLabel: UILabel!
    
    
    override func awakeFromNib() {
        titleDocLabel.textColor = UIColor.elementsLikeNavBarColor
        numberOfSubDocLabel.textColor = UIColor.subTitleGray
    }
    
    
}
