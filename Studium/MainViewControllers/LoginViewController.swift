//
//  LoginViewController.swift
//  Studium
//
//  Created by Simone Scionti on 23/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate {

    weak var SplashController : SplashViewController!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var credentialLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var rememberMeSwitcher: UISwitch!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var yearsPickerView: UIPickerView!
    
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    var yearsDataSource = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loginActivityIndicator.startAnimating()
        yearsPickerView.alpha = 0.0
        getLoginYears()
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.pickerTapped))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        yearsPickerView.addGestureRecognizer(tap)
        self.loginButton.isEnabled = false
        
        
    }
    func showErrorWarning(){
        errorLabel.text = "Errore di connessione ad Internet"
    }
    
    private func hideActivityIndicator(){
        let SSAnimator = CoreSSAnimation.getUniqueIstance()
        SSAnimator.closeViewWithFadeIn(viewToClose: self.loginActivityIndicator) { (flag) in
            
        }
    }
    private func showPickerView(){
        let SSAnimator = CoreSSAnimation.getUniqueIstance()
        SSAnimator.openViewWithFadeIn(viewToOpen: self.yearsPickerView) { (flag) in
        }
    }
    func getLoginYears(){
        let api = BackendAPI.getUniqueIstance(fromController: self)
        api.getYears(){ (years) in
            guard years != nil else {
                self.showErrorWarning()
                self.hideActivityIndicator()
                return}
            for year in years!{
                self.yearsDataSource.append(year)
            }
            self.yearsPickerView.reloadAllComponents()
            self.loginButton.isEnabled = true
            self.hideActivityIndicator()
            self.showPickerView()
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
    private func saveCredentials(username: String, psw: String, yearString: String){
        UserDefaults.standard.setValue(username, forKey: "username")
        UserDefaults.standard.setValue(PswEncryption.encode(s:psw) , forKey: "password")
        UserDefaults.standard.setValue(yearString, forKey: "yearString")
    }
    
    private func getSavedCredentials(){
        if let username = UserDefaults.standard.value(forKey: "username") as? String{
             self.usernameTextField.text = username
        }
        if let psw = UserDefaults.standard.value(forKey: "password") as? String{
            self.passwordTextField.text = PswEncryption.decode(str: psw)
        }
    }
    
   
    private func getMainController() -> UIViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")
        controller.modalPresentationStyle = .fullScreen
        return controller
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        guard controlDataFields() == true else {return}
        let api = BackendAPI.getUniqueIstance(fromController: self)
        let selectedYearIndex = yearsPickerView.selectedRow(inComponent: 0)
        let selectedYear = yearsDataSource[selectedYearIndex]
        loginButton.isEnabled = false
        api.login_v2(username: usernameTextField.text!, password: passwordTextField.text!, academicYear: selectedYear) { (JSONResponse , error) in
            guard let response = JSONResponse, error == nil else{
                //response è nil
                self.errorLabel.text = "Errore di connessione ad Internet"
                self.errorLabel.isHidden = false
                self.loginButton.isEnabled = true
                return
            }
            let dict = response as! [String: Any]
            //print(dict)
            
            let status = dict["status"] as? Int
            let mode = dict["mode"] as? String
            //let user = dict["user"] as? [String:Any]
            
            //TODO: check nil values
            let authObject = dict["authObject"] as? [String: Any]
            let user = authObject!["user"] as? [String:Any]
           

            if status == -1{
                self.errorLabel.sizeToFit()
                self.errorLabel.text = "E' necessario un primo accesso dal sito WEB per l'anno accademico selezionato"
                self.errorLabel.isHidden = false
                self.loginButton.isEnabled = true
                return
            }
            else if status  == 0{
                //print("User data error")
                self.errorLabel.text = "Dati d'accesso errati!"
                self.errorLabel.isHidden = false
                self.loginButton.isEnabled = true
            }
                
            else if status == 1{
                if self.rememberMeSwitcher.isOn{
                    self.saveCredentials(username: self.usernameTextField.text!, psw: self.passwordTextField.text!,yearString: selectedYear)
                }
                //salva la sessione
                Session.getUniqueIstance().setActiveSessionParameters(username: self.usernameTextField.text!, encryptedPassword: PswEncryption.encode(s: self.passwordTextField.text!), academicYear: selectedYear, mode: mode!)
                let _ = Student.buildStudent(studentJSONData: user) //buildStudent
                self.loginButton.isEnabled = true
                let controller = self.getMainController()
                //self.dismiss(animated: false, completion: nil)
                self.present(controller, animated: true, completion: nil)
                
            }
        }
    }
    
   /* private func getYearFromAcademicYear(academicYear: String) -> String{
        let index = academicYear.index(academicYear.startIndex, offsetBy: 5)
        let year = String(academicYear[index...])
        return year
    }*/
    
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
