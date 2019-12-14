//
//  BookingTableViewCell.swift
//  Studium
//
//  Created by Simone Scionti on 13/12/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import UIKit

class BookingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookingNameLabel: UILabel!
    @IBOutlet weak var bookingDateLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        arrowImage.transform = CGAffineTransform(rotationAngle: 3 * (.pi/2))
        self.selectionStyle = .none
        arrowImage.image = UIImage.init(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        arrowImage.tintColor = UIColor.elementsLikeNavBarColor
        bookingDateLabel.textColor = UIColor.secondaryBackground
        bookingNameLabel.textColor = UIColor.elementsLikeNavBarColor
        bookingNameLabel.lineBreakMode = .byTruncatingMiddle
        
    }
    func setInfo(bookingData: Booking){
        self.bookingNameLabel.text = bookingData.name
        self.bookingDateLabel.text = bookingData.data
    }

}
