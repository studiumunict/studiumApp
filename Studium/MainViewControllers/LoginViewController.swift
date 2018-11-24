//
//  LoginViewController.swift
//  Studium
//
//  Created by Simone Scionti on 23/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var credentialLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var rememberMeSwitcher: UISwitch!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var yearsPickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 7.0
        loginButton.clipsToBounds = true
        
        credentialLabel.layer.cornerRadius = 7.0
        credentialLabel.clipsToBounds = true
    
        yearLabel.layer.cornerRadius = 7.0
        yearLabel.clipsToBounds = true
        
        loginButton.layer.borderWidth = 2.0
        loginButton.layer.borderColor = #colorLiteral(red: 0.5277059674, green: 0, blue: 0, alpha: 0.7022688356)

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func loginButtonClicked(_ sender: Any) {
          self.performSegue(withIdentifier: "segueToReveal", sender: nil)
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
