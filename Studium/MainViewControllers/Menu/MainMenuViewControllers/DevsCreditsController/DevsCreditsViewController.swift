//
//  DevsCreditsViewController.swift
//  Studium
//
//  Created by Simone Scionti on 18/02/2020.
//  Copyright © 2020 Unict.it. All rights reserved.
//

import UIKit

class DevsCreditsViewController: UITableViewController, SWRevealViewControllerDelegate {

    @IBOutlet weak var firstDevEmailButton: UIButton!
    @IBOutlet weak var secondDevEmailButton: UIButton!
    @IBOutlet weak var firstDevLinkedinButton: UIButton!
    @IBOutlet weak var secondDevLinkedinButton: UIButton!
    @IBOutlet weak var firstDevFacebookButton: UIButton!
     @IBOutlet weak var secondDevFacebookButton: UIButton!
    @IBOutlet weak var firstDevNameLabel: UILabel!
    @IBOutlet weak var secondDevNameLabel: UILabel!
    @IBOutlet weak var firstDevCardView: UIView!
    @IBOutlet weak var secondDevCardView: UIView!
    @IBOutlet weak var firstDevImageView: UIImageView!
    @IBOutlet weak var secondDevImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupRevealControllerParameters()
        self.tableView.allowsSelection = false
        setupFirstDevCardLayout()
        setupSecondDevCardLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupRevealControllerParameters()
    }
    private func setupSecondDevCardLayout(){
        self.secondDevImageView.layer.cornerRadius = self.firstDevImageView.frame.size.width/2
        self.secondDevImageView.clipsToBounds = true
        
        self.secondDevCardView.layer.cornerRadius = 5.0
        self.secondDevCardView.clipsToBounds = true
        
        self.secondDevFacebookButton.layer.cornerRadius = 5.0
        self.secondDevFacebookButton.clipsToBounds = true
        
        self.secondDevLinkedinButton.layer.cornerRadius = 5.0
        self.secondDevLinkedinButton.clipsToBounds = true
        
        self.secondDevEmailButton.layer.cornerRadius = 5.0
        self.secondDevEmailButton.clipsToBounds = true
    }
    
    
    private func setupFirstDevCardLayout(){
        self.firstDevImageView.layer.cornerRadius = self.firstDevImageView.frame.size.width/2
        self.firstDevImageView.clipsToBounds = true
        
        self.firstDevCardView.layer.cornerRadius = 5.0
        self.firstDevCardView.clipsToBounds = true
        
        self.firstDevFacebookButton.layer.cornerRadius = 5.0
        self.firstDevFacebookButton.clipsToBounds = true
               
        self.firstDevLinkedinButton.layer.cornerRadius = 5.0
        self.firstDevLinkedinButton.clipsToBounds = true
               
        self.firstDevEmailButton.layer.cornerRadius = 5.0
        self.firstDevEmailButton.clipsToBounds = true
    }
    
    private func setupNavigationBar(){
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.03487086296, green: 0.03488409892, blue: 0.0348691158, alpha: 1)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        imageView.image = UIImage.init(named: "menu")
        let buttonView = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        buttonView.addSubview(imageView)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: buttonView)
    }
    
    private func setupRevealControllerParameters(){
           if revealViewController() != nil {
               revealViewController().rearViewRevealWidth = 130 //Menu sx
               revealViewController().delegate = self
               self.navigationItem.leftBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))))
               view.addGestureRecognizer(revealViewController().panGestureRecognizer())
           }
       }
    //Studium per iPhone è stata sviluppata da due studenti del Dipartimento di Matematica e infromatica dell'Università di Catania, in collaborazione con il Dott. Angelo Pappalardo.
    
    //Questa applicazione ha lo scopo di semplificare l'accesso a dati riguardanti la propria carriera universitaria a tutti gli utenti di IPhone.
    
    //Di seguito i contatti degli sviluppatori, a cui è possibile inviare segnalazioni per consigli o problemi riscontrati durante l'utilizzo dell'applicazione.
    
    @IBAction func firstDevFacebookButtonClicked(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.facebook.com/simone.scionti")!)
    }
    @IBAction func firstDevLinkedinButtonClicked(_ sender: Any) {
         UIApplication.shared.open(URL(string: "https://www.linkedin.com/in/simone-scionti-108a51143/")!)
    }
    @IBAction func firstDevEmailButtonClicked(_ sender: Any) {
        let email = "simonescionti@yahoo.com"
        UIApplication.shared.open(URL(string: "mailto:\(email)")!)
    }
    @IBAction func secondDevFacebookButtonClicked(_ sender: Any) {
         UIApplication.shared.open(URL(string: "https://www.facebook.com/francesco.petrosino.96")!)
    }
    @IBAction func secondDevLinkedinButtonClicked(_ sender: Any) {
         UIApplication.shared.open(URL(string: "https://www.facebook.com/simone.scionti")!)
    }
    @IBAction func secondDevEmailButtonClicked(_ sender: Any) {
        let email = ""
        UIApplication.shared.open(URL(string: "mailto:\(email)")!)
    }
    
}
