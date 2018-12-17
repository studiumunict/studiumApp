//
//  DocumentsViewController.swift
//  Studium
//
//  Created by Simone Scionti on 23/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class DocumentsViewController: UIViewController, SWRevealViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        //added comments
        self.view.backgroundColor = UIColor.red
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130 //Menu sx
            revealViewController().delegate = self
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 160 //Menu sx
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
