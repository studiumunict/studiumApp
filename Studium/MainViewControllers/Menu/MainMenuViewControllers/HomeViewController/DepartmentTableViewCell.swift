//
//  DepartmentTableViewCell.swift
//  Studium
//
//  Created by Simone Scionti on 26/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class DepartmentTableViewCell: UITableViewCell {
    @IBOutlet weak var departmentName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
