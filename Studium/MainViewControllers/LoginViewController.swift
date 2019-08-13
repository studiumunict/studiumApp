//
//  LoginViewController.swift
//  Studium
//
//  Created by Simone Scionti on 23/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var credentialLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var rememberMeSwitcher: UISwitch!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var yearsPickerView: UIPickerView!
    var yearsDataSource = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        addLoginYears()
        getSavedCredentials()
        loginButton.layer.cornerRadius = 7.0
        loginButton.clipsToBounds = true
        
        credentialLabel.layer.cornerRadius = 7.0
        credentialLabel.clipsToBounds = true
        
        errorLabel.textColor =  UIColor.textRedColor
        errorLabel.text = ""
    
        yearLabel.layer.cornerRadius = 7.0
        yearLabel.clipsToBounds = true
        
        loginButton.layer.borderWidth = 3.0
        loginButton.layer.borderColor = UIColor.secondaryBackground.cgColor

        yearsPickerView.delegate = self
        
        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.pickerTapped))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        yearsPickerView.addGestureRecognizer(tap)
        
        
    }
    
    func addLoginYears(){
        let api = BackendAPI.getUniqueIstance()
        api.getYears(){ (years) in
            guard years != nil else {return}
            for year in years!{
                self.yearsDataSource.append(year)
            }
            self.yearsPickerView.reloadAllComponents()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true}
    
    @objc func pickerTapped(tapRecognizer:UITapGestureRecognizer)
    {
        if (tapRecognizer.state == UIGestureRecognizer.State.ended){
            self.view.endEditing(true)
            self.usernameTextField.resignFirstResponder()
            self.passwordTextField.resignFirstResponder()
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func controlDataFields() -> Bool{
        resetErrors()
        var result = true
        if(usernameTextField.text == nil || usernameTextField.text == "") {
            usernameTextField.layer.borderWidth = 2.0
            usernameTextField.layer.borderColor = UIColor.textRedColor.cgColor
            result = false
        }
        if(passwordTextField.text == nil || passwordTextField.text == "") {
            passwordTextField.layer.borderWidth = 2.0
            passwordTextField.layer.borderColor = UIColor.textRedColor.cgColor
            result = false
        }
        return result
    }
    private func resetErrors(){
        errorLabel.isHidden = true
        usernameTextField.layer.borderWidth = 0.0
        usernameTextField.layer.borderColor = UIColor.clear.cgColor
        passwordTextField.layer.borderWidth = 0.0
        passwordTextField.layer.borderColor = UIColor.clear.cgColor
    }
    private func saveCredentials(){
        UserDefaults.standard.setValue(self.usernameTextField.text!, forKey: "username")
        UserDefaults.standard.setValue(PswEncryption.encode(s: self.passwordTextField.text!) , forKey: "password")
    }
    
    private func getSavedCredentials(){
        if let username = UserDefaults.standard.value(forKey: "username") as? String{
             self.usernameTextField.text = username
        }
        if let psw = UserDefaults.standard.value(forKey: "password") as? String{
            self.passwordTextField.text = PswEncryption.decode(str: psw)
        }
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        guard controlDataFields() == true else {return}
        let api = BackendAPI.getUniqueIstance()
        let selectedYearIndex = yearsPickerView.selectedRow(inComponent: 0)
        let selectedYear = yearsDataSource[selectedYearIndex]
        
        api.login(username: usernameTextField.text!, password: passwordTextField.text!, academicYear: selectedYear) { (success) in
            if success {
                if self.rememberMeSwitcher.isOn{
                   self.saveCredentials()
                }
                self.performSegue(withIdentifier: "segueToReveal", sender: nil)
            }
            else{
                print("User data error")
                self.errorLabel.text = "Dati d'accesso errati!"
                self.errorLabel.isHidden = false
            }
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = yearsDataSource[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return myTitle
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return yearsDataSource.count //numero di anni nel picker, da scaricare dal db
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return yearsDataSource[row]
    }

}
