//
//  CDLTableViewCell.swift
//  Studium
//
//  Created by Simone Scionti on 06/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class CDLTableViewCell: UITableViewCell {
    @IBOutlet weak var CDLnameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
