//
//  SplashViewController.swift
//  Studium
//
//  Created by Simone Scionti on 01/02/2020.
//  Copyright © 2020 Unict.it. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    var firstAppearing : Bool = true
    var username : String!
    var psw: String!
    var yearString : String!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(firstAppearing && getSavedCredentials() ){
            //login e rimandi al main
            autoLogin()
        }
        else {
            sendToLoginController()
        }
        firstAppearing = false
        // Do any additional setup after loading the view.
    }
    
    
    private func autoLogin(){
        let api = BackendAPI.getUniqueIstance(fromController: nil)
                   api.login_v2(username: username, password: psw, academicYear: yearString) { (JSONResponse, error) in
                       guard let response = JSONResponse, error == nil else{
                           //response è nil
                           self.sendToLoginController()
                           return
                       }
                       let dict = response as! [String: Any]
                       let status = dict["status"] as? Int
                       let mode = dict["mode"] as? String
                       let user = dict["user"] as? [String:Any]
                       if status == -1{
                           //"E' necessario un primo accesso dal sito WEB per l'anno accademico selezionato"
                            self.sendToLoginController()
                            return
                       }
                       else if status  == 0{
                           //Dati d'accesso errati!"
                           self.sendToLoginController()
                           return
                       }
                       else if status == 1{
                           //salva la sessione
                           Session.getUniqueIstance().setActiveSessionParameters(username: self.username, encryptedPassword: PswEncryption.encode(s: self.psw), academicYear: self.yearString, mode: mode!)
                           let _ = Student.buildStudent(studentJSONData: user)
                           self.sendToRevealController()
                           return
                       }
                   }
    }
    
    private func getSavedCredentials() -> Bool{
        var success = true
        if let username = UserDefaults.standard.value(forKey: "username") as? String{
             self.username = username
            //print("found username")
        }
        else{success = false }
        if let psw = UserDefaults.standard.value(forKey: "password") as? String{
            self.psw = PswEncryption.decode(str: psw)
            //print("found psw")
        }
        else{success = false}
        if let yearString = UserDefaults.standard.value(forKey: "yearString") as? String{
            self.yearString = yearString
           // print("found yearstring")
        }
        else{success = false}
        return success
    }
    
    private func getRevealController() -> UIViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")
        controller.modalPresentationStyle = .fullScreen
        return controller
    }
    
    private func getLoginController() -> UIViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        controller.modalPresentationStyle = .fullScreen
        return controller
    }
    private func sendToLoginController(){
        let controller = self.getLoginController()
        self.present(controller, animated: true, completion: nil)
    }
    private func sendToRevealController(){
        let controller = self.getRevealController()
        self.present(controller, animated: true, completion: nil)
    }

}
