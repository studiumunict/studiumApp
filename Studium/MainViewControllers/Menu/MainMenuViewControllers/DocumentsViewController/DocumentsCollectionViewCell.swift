//
//  DocumentsCollectionViewCell.swift
//  Studium
//
//  Created by Francesco Petrosino on 19/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit
import UICircularProgressRing
class DocumentsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageDoc: UIImageView!
    @IBOutlet var titleDocLabel: UILabel!
    @IBOutlet var descriptionDocLabel: UILabel!
    @IBOutlet var activityIndicator : UICircularProgressRing!

    override func awakeFromNib() {
        //activityIndicator = UICircularProgressRing(frame: imageDoc.frame)
        titleDocLabel.textColor = UIColor.elementsLikeNavBarColor
        descriptionDocLabel.textColor = UIColor.subTitleGray
        self.activityIndicator.alpha = 0.0
        self.titleDocLabel.lineBreakMode = .byTruncatingMiddle
        //activityIndicator.style = .bordered(width: 3.0, color: UIColor.textRedColor)
        activityIndicator.style = .ontop
        activityIndicator.innerRingColor = UIColor.activityDownloaderColor
        activityIndicator.font = UIFont.systemFont(ofSize: 12)
        //activityIndicator.viewPrintFormatter().view.isHidden = true
        activityIndicator.valueFormatter = UICircularProgressRingFormatter(valueIndicator: "", rightToLeft: false, showFloatingPoint: false, decimalPlaces: 0)
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
    private func getRelatedImage(fromTitle: String)->String{
        let dotInd = fromTitle.lastIndex(of: ".")
        guard let dotIndex = dotInd else{return "file"}
        let extSub = fromTitle[dotIndex...]
        let ext = String(extSub)
        if ext == ".pdf" {return "pdf"}
        else if ext == ".zip" {return "zip"}
        else if ext == ".jpg" || ext == ".jpeg" {return "jpg"}
        return "file"
    }
    func update(type: String, title: String, description: String) {
        if type == "file"{
            let imgString = getRelatedImage(fromTitle: title)
            self.imageDoc.image = UIImage(named: imgString)
        }
        else{
            self.imageDoc.image = UIImage(named: "folder_1")
        }
        self.titleDocLabel.text = title
        self.descriptionDocLabel.text = description
    }
    
    func showActivityIndicator(){
        activityIndicator.startProgress(to: 0.0, duration: 0)
        //self.activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.3) {
            self.imageDoc.alpha = 0.1
            self.activityIndicator.alpha = 1.0
        }
        
    }
    func updateActivityIndicator(progress: Float){
        let p =  progress * 100
        activityIndicator.startProgress(to: CGFloat(p), duration: 0.0)
    }
    func hide(){
        //self.activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.3) {
            self.imageDoc.alpha = 1.0
            self.activityIndicator.alpha = 0.0
        }
    }
    
}
