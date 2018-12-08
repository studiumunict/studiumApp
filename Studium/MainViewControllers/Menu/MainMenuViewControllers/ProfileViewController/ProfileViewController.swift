//
//  ProfileViewController.swift
//  Studium
//
//  Created by Simone Scionti on 23/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, SWRevealViewControllerDelegate {

    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var codeLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var surnameLabel: UILabel!
    @IBOutlet var telNumberLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    var profileDataSource: Profile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 160 //Menu sx
            revealViewController().delegate = self
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 160 //Menu sx
            revealViewController().delegate = self
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        profileDataSource = Profile(username: "king", code: "x81000123", name: "Diego", surname: "Ragno", telNumber: "12345678901", email: "ilking@dmi.unict.it", profileImage: "user")
        
        usernameLabel.text = profileDataSource.username
        codeLabel.text = String.uppercased(profileDataSource.code)()
        nameLabel.text = profileDataSource.name
        surnameLabel.text = profileDataSource.surname
        telNumberLabel.text = profileDataSource.telNumber
        emailLabel.text = profileDataSource.email
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
