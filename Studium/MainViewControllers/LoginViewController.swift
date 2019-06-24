//
//  LoginViewController.swift
//  Studium
//
//  Created by Simone Scionti on 23/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate {

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
    
        loginButton.layer.cornerRadius = 7.0
        loginButton.clipsToBounds = true
        
        credentialLabel.layer.cornerRadius = 7.0
        credentialLabel.clipsToBounds = true
    
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
        //dati da scaricare
        
        yearsDataSource.append("2018/2019")
        yearsDataSource.append("2017/2018")
        yearsDataSource.append("2016/2017")
        yearsDataSource.append("2015/2016")
        yearsDataSource.append("2014/2015")
        
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
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = yearsDataSource[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        return myTitle
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return 5 //numero di anni nel picker, da scaricare dal db
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return yearsDataSource[row]
    }

}
