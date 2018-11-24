//
//  CorsoViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 24/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class CorsoViewController: UIViewController, UIScrollViewDelegate, SWRevealViewControllerDelegate {

    @IBOutlet var viewAppoggio: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var vetrinaButton: UIButton!
    @IBOutlet var avvisiButton: UIButton!
    @IBOutlet var descrizioneButton: UIButton!
    @IBOutlet var documentiButton: UIButton!
    
    @IBOutlet var nomeCorsoLabel: UILabel!
    @IBOutlet var nomeProfessoreLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*if revealViewController() != nil { //Menu laterale
            revealViewController().rearViewRevealWidth = view.bounds.width - 70
            revealViewController().rightViewRevealWidth = 160
            revealViewController().delegate = self
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }*/
        
        scrollView.delegate = self
        
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
