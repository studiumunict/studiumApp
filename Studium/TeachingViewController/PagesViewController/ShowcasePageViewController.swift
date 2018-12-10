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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightWhite
        loadingIndicator.color = UIColor.primaryBackground
        self.view.layer.borderColor = UIColor.primaryBackground.cgColor
        self.view.layer.borderWidth = 0.5
    }
    

}
