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
    @IBOutlet var activityIndicator : UIActivityIndicatorView!

    override func awakeFromNib() {
        titleDocLabel.textColor = UIColor.elementsLikeNavBarColor
        descriptionDocLabel.textColor = UIColor.subTitleGray
        self.activityIndicator.alpha = 0.0
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
    
    func startActivityIndicator(){
        self.activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.3) {
            self.imageDoc.alpha = 0.3
            self.activityIndicator.alpha = 1.0
        }
        
    }
    func stopActyivityIndicator(){
        self.activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.3) {
            self.imageDoc.alpha = 1.0
            self.activityIndicator.alpha = 0.0
        }
    }
    
}
