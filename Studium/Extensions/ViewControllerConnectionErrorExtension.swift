//
//  ViewControllerConnectionErrorExtension.swift
//  Studium
//
//  Created by Simone Scionti on 28/11/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation

extension UIViewController : ConnectionErrorHandlerDelegate{
    /*struct oscure {
        static var _oscureView = UIView()
    }
    var oscureView: UIView {
        get {
            return oscure._oscureView
        }
        set(newValue) {
            oscure._oscureView = newValue
        }
    }*/
    
    struct errorView {
        static var _errorConfirmView : UIView? = nil
    }
    var errorConfirmView: UIView? {
        get {
            return errorView._errorConfirmView
        }
        set(newValue) {
            errorView._errorConfirmView = newValue
        }
    }
    
    func connectionErrorHandle(error: Error!) {
        DispatchQueue.main.async {
            self.checkForErrorView()
        }
    }
    func setupOscureView(){
        //oscureView.isHidden = true
        //aggiungi constraint oscureView
    }
    @objc func okClicked(){
        print("OkClicked")
        let SSAnim = CoreSSAnimation.getUniqueIstance()
        SSAnim.collapseViewInSourceFrame(sourceFrame: CGRect(x: self.view.center.x - ((self.view.frame.width * 0.9)/2), y: self.view.frame.size.height - 100, width: self.view.frame.width * 0.9, height: 60), viewToCollapse: self.errorConfirmView!, oscureView: nil, elementsInsideView: nil) { (flag) in
            //self.view.isUserInteractionEnabled = true
            self.errorConfirmView!.removeFromSuperview()
            self.errorConfirmView = nil
        }
    }
    
    private func showErrorView(){
        setupOscureView()
        //self.view.isUserInteractionEnabled = false
        let CF = ConfirmView.getUniqueIstance()
        let titleLabel = CF.getTitleLabel(text: "Errore di connessione")
        let descLabel = CF.getDescriptionLabel(text: "Controlla la tua connessione o riprova più tardi")
        let okButton = CF.getButton(position: .alone, title: "Ok", selector: #selector(okClicked), target: self)
        errorConfirmView = CF.getView(titleLabel: titleLabel, descLabel: descLabel, buttons: [okButton], dataToAttach: nil)
        self.view.addSubview(errorView._errorConfirmView!)
        errorConfirmView?.layer.zPosition = 10
        let SSAnim = CoreSSAnimation.getUniqueIstance()
        SSAnim.expandViewFromSourceFrame(sourceFrame: CGRect(x: self.view.center.x - ((self.view.frame.width * 0.9)/2), y: self.view.frame.size.height - 100, width: self.view.frame.width * 0.9, height: 60), viewToExpand: self.errorConfirmView!, elementsInsideView: nil, oscureView: nil) { (flag) in
            print("Errore connessione da questo view controller:", self)
        }
        
    }
    private func errorViewIsInCurrentController()->Bool{
         return self.errorConfirmView?.superview == self.view
    }
    
    func checkForErrorView(){
        //let SSAnim = CoreSSAnimation.getUniqueIstance()
        if self.errorConfirmView != nil{
            if !errorViewIsInCurrentController(){ //si trova in un altro controller
                self.errorConfirmView?.removeFromSuperview()
                self.errorConfirmView = nil
                showErrorView()
                return
            }
        }
        else{
            showErrorView()
        }
        
        //print("Errore connessione da questo view controller:", self)
    }
}
