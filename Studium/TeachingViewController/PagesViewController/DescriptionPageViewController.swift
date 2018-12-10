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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.lightWhite
        self.view.layer.borderColor = UIColor.black.cgColor
        self.view.layer.borderWidth = 0.5
    }


}
