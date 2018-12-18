//
//  BrowseAndSearchCourseTableViewCell.swift
//  Studium
//
//  Created by Simone Scionti on 18/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class BrowseAndSearchCourseTableViewCell: UITableViewCell {
    @IBOutlet weak var teacherNameLabel: UILabel!
    @IBOutlet weak var teachingNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = UIColor.primaryBackground
        teacherNameLabel.textColor =  UIColor.lightSectionColor
        teachingNameLabel.textColor =  UIColor.lightWhite
        self.selectionStyle = .none
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
