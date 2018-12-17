//
//  ManageCourseViewController.swift
//  Studium
//
//  Created by Simone Scionti on 14/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class ManageCourseViewController: UIViewController, SWRevealViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.view.backgroundColor = UIColor.green
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130//Menu sx/
            revealViewController().delegate = self
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130//Menu sx/
            revealViewController().delegate = self
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }

}
