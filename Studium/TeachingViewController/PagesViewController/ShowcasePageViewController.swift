//
//  ShowcasePageViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 10/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class ShowcasePageViewController: UIViewController {

    @IBOutlet var errorMessageLabel: UILabel!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    var haveShowcase: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightWhite
        loadingIndicator.color = UIColor.primaryBackground
        self.view.layer.borderColor = UIColor.primaryBackground.cgColor
        self.view.layer.borderWidth = 0.5
        
        if haveShowcase != nil && haveShowcase {
            errorMessageLabel.isHidden = true
            loadingIndicator.stopAnimating()
            loadingIndicator.isHidden = true
        } else {
            errorMessageLabel.isHidden = false
            errorMessageLabel.text = "Vetrina vuota.."
            loadingIndicator.startAnimating()
            loadingIndicator.isHidden = false
        }
    }
    

}
