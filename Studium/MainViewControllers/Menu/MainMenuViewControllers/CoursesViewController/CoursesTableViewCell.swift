//
//  CoursesTableViewCell.swift
//  Studium
//
//  Created by Simone Scionti on 17/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class CoursesTableViewCell: UITableViewCell {

    @IBOutlet weak var teacherNameLabel: UILabel!
    @IBOutlet weak var teachingNameLabel: UILabel!
    
    @IBOutlet weak var arrowImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        teacherNameLabel.textColor =  UIColor.subTitleGray
        teachingNameLabel.textColor =  UIColor.elementsLikeNavBarColor
        self.showsReorderControl = true
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
