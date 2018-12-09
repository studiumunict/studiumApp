//
//  ProfileViewController.swift
//  Studium
//
//  Created by Simone Scionti on 23/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, SWRevealViewControllerDelegate {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var universityCodeLabel: UILabel!
    @IBOutlet weak var codFiscaleLabel: UILabel!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var universityCodeView: UIView!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var emailView: UIView!
    var profileDataSource: Student!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        imageView.image = UIImage.init(named: "menu")
        let buttonView = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        buttonView.addSubview(imageView)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: buttonView)
        
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130 //Menu sx
            revealViewController().delegate = self
            self.navigationItem.leftBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))))
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.clipsToBounds = true
        userImageView.layer.borderWidth = 3.0
        userImageView.layer.borderColor = UIColor.secondaryBackground.cgColor
        
        
        universityCodeView.layer.cornerRadius =  7.0
        universityCodeView.clipsToBounds = true
        usernameView.layer.cornerRadius =  7.0
        usernameView.clipsToBounds = true
        phoneNumberView.layer.cornerRadius =  7.0
        phoneNumberView.clipsToBounds = true
        emailView.layer.cornerRadius =  7.0
        emailView.clipsToBounds = true
        
        getStudent()
        
        
        
        
        
        
    }
    
    func getStudent(){
        
        profileDataSource = Student(codFiscale: "SCNSNR98P29C351C", code: "X81000123", name: "Simone Orazio", surname: "Scionti", telNumber: "12345678901", email: "ilking@dmi.unict.it", profileImage: UIImage.init(named: "logo"))
        
        codFiscaleLabel.text = profileDataSource.codFiscale
        universityCodeLabel.text = profileDataSource.code
        studentNameLabel.text = profileDataSource.name + " " + profileDataSource.surname
        emailLabel.text = profileDataSource.email
        phoneNumberLabel.text = profileDataSource.telNumber
        profileImageView.image = profileDataSource.profileImage
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130 //Menu sx
            revealViewController().delegate = self
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
       
    }

}
