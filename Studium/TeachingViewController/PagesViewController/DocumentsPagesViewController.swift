//
//  DocumentsPageViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 10/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class DocumentsPageViewController: UIViewController {

    @IBOutlet var errorMessageLabel: UILabel!
    
    var haveDescription: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightWhite
        self.view.layer.borderColor = UIColor.primaryBackground.cgColor
        self.view.layer.borderWidth = 0.5
        
        if haveDescription != nil && haveDescription {
            errorMessageLabel.isHidden = true
        } else {
            errorMessageLabel.isHidden = false
            errorMessageLabel.text = "Questo insegnamento non ha documenti online."
        }
    }
    

}
