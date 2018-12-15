//
//  SyllabusPageViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 14/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class SyllabusPageViewController: UIViewController {

    @IBOutlet var errorMessageLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightWhite
        self.view.layer.borderColor = UIColor.primaryBackground.cgColor
        self.view.layer.borderWidth = 0.5
        
    }

}
