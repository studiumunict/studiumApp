//
//  DescriptionPageViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 10/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit


class DescriptionPageViewController: UIViewController {
    
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var errorMessageLabel: UILabel!
    
    var descriptionText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.lightWhite
        self.view.layer.borderColor = UIColor.primaryBackground.cgColor
        self.view.layer.borderWidth = 0.5
        
        if descriptionText != nil {
            descriptionTextView.isHidden = false
            errorMessageLabel.isHidden = true
            descriptionTextView.text = descriptionText!
        } else {
            descriptionTextView.isHidden = true
            errorMessageLabel.isHidden = false
            errorMessageLabel.text = "Questo insegnamento non è stato ancora descritto."
        }
    }
    deinit{
        print("Deinit descriptionPage")
    }

}
