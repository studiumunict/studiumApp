//
//  CoursesViewController.swift
//  Studium
//
//  Created by Simone Scionti on 07/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class CoursesViewController: UIViewController, SWRevealViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.green
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 160//Menu sx/
            revealViewController().delegate = self
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 160//Menu sx/
            revealViewController().delegate = self
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
