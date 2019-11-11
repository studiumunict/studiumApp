//
//  BrowseAndSearchCoursesViewController.swift
//  Studium
//
//  Created by Simone Scionti on 14/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class BrowseAndSearchCoursesViewController: HomeViewController{
    var tabController : ManageCoursePageViewController!
    var oscureView : UIView!
    var signUpView : UIView!
    
    override func setSearchIconOnSearchButton(){
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 2.5, width: 25.5, height: 25))
        imageView2.image = UIImage.init(named: "search")
        let buttonView2 = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 27.5))
        buttonView2.addSubview(imageView2)
        self.tabController.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: buttonView2)
        self.tabController.navigationItem.rightBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.searchingClicked)))
        
    }
    
    override func setCancelIconOnSearchButton(){
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 2.5, width: 25.5, height: 25))
        imageView2.image = UIImage.init(named: "close")
        let buttonView2 = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 27.5))
        buttonView2.addSubview(imageView2)
        self.tabController.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: buttonView2)
    self.tabController.navigationItem.rightBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.searchingClicked)))
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView ==  self.departmentsTableView{
            return 50
        }
        else {
            return 70
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.departmentsTableView{
            self.departmentsSelectButton.setTitleColor(UIColor.darkGray, for: .normal)
            self.departmentsSelectButton.setTitle(self.departmentsDataSource[indexPath.row].name, for: .normal)
            self.view.endEditing(true)
            self.cdlTableView.isHidden = false
            self.hideDepartmentTableAnimated()
            
            getCDLAndTeachings(ofDepartment : self.departmentsDataSource[indexPath.row])
        }
        else {// fai comparire la view di iscriversi o meno al corso
            //let cell = tableView.cellForRow(at: indexPath)!
            //let cellFrame = cell.convert(cell.frame, to: self.view)
            
            if self.cdsSearchBar.isFirstResponder || self.cdsSearchBar.text != ""{
                self.cdsSearchBar.resignFirstResponder()
                let teaching  = self.filteredCDLDataSource[indexPath.section].teachings[indexPath.row]
                showSignUpViewAnimated(teachingName: teaching.name, teacherName: teaching.teacherName, signedUp: teaching.signedUp, indexPath: indexPath )
            }
            else{
                let teaching  = self.CDLDataSource[indexPath.section].teachings[indexPath.row]
                showSignUpViewAnimated(teachingName: teaching.name, teacherName: teaching.teacherName, signedUp: teaching.signedUp, indexPath: indexPath )
            }
            
            
            
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView ==  self.departmentsTableView{
            let cell = departmentsTableView.dequeueReusableCell(withIdentifier: "departmentCell") as! DepartmentTableViewCell
            //modifico la cella e la mostro
            cell.departmentName.text = self.departmentsDataSource[indexPath.row].name
            return cell
            
        }
        else { //CDL table
            let cell = cdlTableView.dequeueReusableCell(withIdentifier: "teachingCell") as! BrowseAndSearchCourseTableViewCell
            //modifico la cella e la mostro
            var dataElement : Teaching!
            if self.cdsSearchBar.isFirstResponder || self.cdsSearchBar.text != ""{
                print("prendo dal filtered")
                dataElement = self.filteredCDLDataSource[indexPath.section].teachings[indexPath.row]
            }
            else{
                dataElement = self.CDLDataSource[indexPath.section].teachings[indexPath.row]
            }
            
            cell.teachingNameLabel.text = dataElement.name
            cell.teacherNameLabel.text = dataElement.teacherName
            
            return cell
        }
    }
    @objc func confirmSignup(sender: UIButton) {
        let indexPath = sender.accessibilityElements![0] as! IndexPath
        let courseCode : String
        if self.cdsSearchBar.isFirstResponder || self.cdsSearchBar.text != ""{
            courseCode = self.filteredCDLDataSource[indexPath.section].teachings[indexPath.row].code
        }
        else{
            courseCode = self.CDLDataSource[indexPath.section].teachings[indexPath.row].code
        }
        let api =  BackendAPI.getUniqueIstance()
        api.addCourse(codCourse: courseCode) { (JSONResponse) in
            print(JSONResponse ??  "null")
            print("iscritto");
            SharedSource.getUniqueIstance().reloadSourceFromAPI { (flag) in
            }
        }
        
        
        //chiama la funzione che fa comparire "Iscrizione effettuata! Il corso è stato inserito nella sezione i miei corsi."
        // Questa funzione poi chiama hideSignupViewAnimated
        hideSignUpViewAnimated(button: sender)
    }
    func showSignUpViewAnimated(teachingName : String, teacherName : String , signedUp : Bool, indexPath : IndexPath){
        self.navigationItem.rightBarButtonItem?.customView?.isUserInteractionEnabled = false
        
        var cellFrame = self.cdlTableView.rectForRow(at: indexPath)
        cellFrame = self.cdlTableView.convert(cellFrame, to: self.cdlTableView.superview)
        oscureView = UIView.init(frame: self.view.frame)
        oscureView.backgroundColor = UIColor.primaryBackground
        oscureView.alpha = 0.0
        self.view.addSubview(oscureView)
        //crei la view con i bottoni di iscrizione
        let newFrame = CGRect(x: 0, y: 0, width: self.view.frame.size.width * 0.9, height: 180)
        self.signUpView = UIView.init(frame: newFrame)
        self.signUpView.center = CGPoint(x: cellFrame.origin.x + cellFrame.width/2  , y: cellFrame.origin.y + cellFrame.height/2 )
        self.view.addSubview(signUpView)
        self.signUpView.backgroundColor = UIColor.primaryBackground
        self.signUpView.layer.borderColor = UIColor.secondaryBackground.cgColor
        self.signUpView.layer.borderWidth = 1.0
        self.signUpView.layer.cornerRadius = 5.0
        self.signUpView.transform = CGAffineTransform(scaleX: 1, y: 0.01)
        self.signUpView.alpha = 0.0
        
        let teachingNameLabel = UILabel.init(frame: CGRect(x: 10, y: 20, width: signUpView.frame.size.width - 20, height: 20))
        teachingNameLabel.text = teachingName
        teachingNameLabel.textColor = UIColor.lightWhite
        teachingNameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        teachingNameLabel.textAlignment = .center
        teachingNameLabel.alpha = 0.0
        let teacherNameLabel = UILabel.init(frame: CGRect(x: 10 , y: 45, width: signUpView.frame.size.width - 20, height: 20))
        teacherNameLabel.text = teacherName
        teacherNameLabel.textColor = UIColor.lightGray
        teacherNameLabel.font = UIFont.boldSystemFont(ofSize: 13)
        teacherNameLabel.textAlignment = .center
        teacherNameLabel.alpha = 0.0
        let signUpButton = UIButton(frame: CGRect(x: signUpView.frame.size.width/2 - 0.5, y: 100 , width: 100, height: 40))
        let cancelButton = UIButton(frame: CGRect(x: signUpView.frame.size.width/2 - 100 + 0.5 , y: 100, width: 100, height: 40))
        signUpButton.backgroundColor = UIColor.lightWhite
        cancelButton.backgroundColor = UIColor.lightWhite
        signUpButton.setTitleColor(UIColor.textBlueColor, for: .normal)
        signUpButton.accessibilityElements = [IndexPath]()
        signUpButton.accessibilityElements?.append(indexPath)
        signUpButton.addTarget(self, action: #selector(confirmSignup(sender:)), for: .touchUpInside)
        signUpButton.setTitle("Iscriviti", for: .normal)
        cancelButton.setTitle("Annulla", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "System", size: 9)
        signUpButton.titleLabel?.font = UIFont(name: "System", size: 9)
        cancelButton.setTitleColor(UIColor.textRedColor, for: .normal)
        cancelButton.accessibilityElements = [IndexPath]()
        cancelButton.accessibilityElements?.append(indexPath)
        cancelButton.addTarget(self, action: #selector(hideSignUpViewAnimated), for: .touchUpInside)
        signUpButton.layer.cornerRadius = 5.0
        cancelButton.layer.cornerRadius = 5.0
        
        //signUpButton.layer.addBorder(edge: .left, color: UIColor.lightGray, thickness: 0.5)
        cancelButton.layer.addBorder(edge: .right, color: #colorLiteral(red: 0.9961728454, green: 0.9902502894, blue: 1, alpha: 1), thickness: 0.5)
        /* signUpButton.layer.addBorder(edge: .top, color: UIColor.secondaryBackground, thickness: 2.0)
         signUpButton.layer.addBorder(edge: .bottom, color: UIColor.secondaryBackground, thickness: 2.0)
         cancelButton.layer.addBorder(edge: .left, color: UIColor.secondaryBackground, thickness: 2.0)
         cancelButton.layer.addBorder(edge: .top, color: UIColor.secondaryBackground, thickness: 2.0)
         cancelButton.layer.addBorder(edge: .bottom, color: UIColor.secondaryBackground, thickness: 2.0)
         */
        roundRightRadius(radius: 5.0, view: signUpButton)
        roundLeftRadius(radius: 5.0, view: cancelButton)
        
        signUpView.addSubview(signUpButton)
        signUpView.addSubview(cancelButton)
        signUpView.addSubview(teacherNameLabel)
        signUpView.addSubview(teachingNameLabel)
        
        
        UIView.animate(withDuration: 0.3, animations: {
            self.oscureView.alpha = 0.6
            self.signUpView.transform = CGAffineTransform(scaleX: 1, y: 0.5)
            self.signUpView.alpha = 1.0
        }) { (flag) in
            UIView.animate(withDuration: 0.3) {
                self.oscureView.alpha = 0.9
                self.signUpView.transform = .identity
                self.signUpView.center = CGPoint(x: self.view.center.x , y: self.view.center.y - 50 )
                //porta a 1 gli alpha degli elementi della view
                teacherNameLabel.alpha = 1.0
                teachingNameLabel.alpha = 1.0
            }
        }
        
        
    }
    
    func roundCorners(corners:UIRectCorner, radius:CGFloat, view : UIView) {
        let bounds = view.bounds
        
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        
        view.layer.mask = maskLayer
        
        let frameLayer = CAShapeLayer()
        frameLayer.frame = bounds
        frameLayer.path = maskPath.cgPath
        frameLayer.strokeColor = UIColor.secondaryBackground.cgColor
        frameLayer.lineWidth = 3.0
        frameLayer.fillColor = nil
        
        view.layer.addSublayer(frameLayer)
    }
    
    
    func roundLeftRadius(radius:CGFloat, view : UIView) {
        self.roundCorners(corners: [UIRectCorner.topLeft, UIRectCorner.bottomLeft], radius:radius, view: view)
    }
    
    func roundRightRadius(radius:CGFloat, view : UIView) {
        self.roundCorners(corners: [UIRectCorner.topRight, UIRectCorner.bottomRight], radius:radius, view: view)
    }
    
    @objc func hideSignUpViewAnimated(button: UIButton){
        let indexPath = button.accessibilityElements![0] as! IndexPath
        var cellFrame = self.cdlTableView.rectForRow(at: indexPath)
        cellFrame = self.cdlTableView.convert(cellFrame, to: self.cdlTableView.superview)
        
        // self.signUpView.center = CGPoint(x: cellFrame.origin.x + cellFrame.width/2  , y: cellFrame.origin.y + cellFrame.height/2 )
        
        UIView.animate(withDuration: 0.3, animations: {
            self.oscureView.alpha = 0.6
            self.signUpView.center = CGPoint(x: cellFrame.origin.x + cellFrame.width/2  , y: cellFrame.origin.y + cellFrame.height/2 )
            self.signUpView.transform = CGAffineTransform(scaleX: 1, y: 0.5)
            //porta a 0 gli alpha degli elementi della view
            // teacherNameLabel.alpha = 0.0
            // teachingNameLabel.alpha = 0.0
            
            
        }) { (flag) in
            
            UIView.animate(withDuration: 0.3, animations: {
                self.signUpView.transform = CGAffineTransform(scaleX: 1, y: 0.01)
                self.oscureView.alpha = 0.0
                self.signUpView.alpha = 0.0
                
            }, completion: { (f) in
                self.navigationItem.rightBarButtonItem?.customView?.isUserInteractionEnabled = true
                self.signUpView.removeFromSuperview()
                self.signUpView = nil
                self.oscureView.removeFromSuperview()
                self.oscureView = nil
            })
            
        }
    }
}


