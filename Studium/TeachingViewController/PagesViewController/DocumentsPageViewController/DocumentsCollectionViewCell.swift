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
    @IBOutlet var descriptionDocLabel: UILabel!
    
    
    override func awakeFromNib() {
        titleDocLabel.textColor = UIColor.elementsLikeNavBarColor
        descriptionDocLabel.textColor = UIColor.subTitleGray
    }
    
    func update(image imageString: String, title: String, description: String) {
        self.imageDoc.image = UIImage(named: imageString)
        self.titleDocLabel.text = title
        self.descriptionDocLabel.text = description
    }
    
}
