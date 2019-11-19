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
        else {// fai comparire la view per iscriversi  al corso
            setUpOscureView()
            setUpSignUpView(sourceIndexPath: indexPath)
            if self.cdsSearchBar.isFirstResponder || self.cdsSearchBar.text != ""{
                self.cdsSearchBar.resignFirstResponder()
                var cellFrame = self.cdlTableView.rectForRow(at: indexPath)
                cellFrame = self.cdlTableView.convert(cellFrame, to: self.cdlTableView.superview)
                showSignUpViewAnimated(cellFrame: cellFrame)
            }
            else{
                var cellFrame = self.cdlTableView.rectForRow(at: indexPath)
                cellFrame = self.cdlTableView.convert(cellFrame, to: self.cdlTableView.superview)
                showSignUpViewAnimated(cellFrame: cellFrame)
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
            SharedCoursesSource.getUniqueIstance().reloadSourceFromAPI { (flag) in
            }
        }
        //chiama la funzione che fa comparire "Iscrizione effettuata! Il corso è stato inserito nella sezione i miei corsi."
        // Questa funzione poi chiama hideSignupViewAnimated
        hideSignUpViewAnimated(button: sender)
    }
    private func setUpOscureView(){
        oscureView = UIView.init(frame: self.view.frame)
        oscureView.backgroundColor = UIColor.primaryBackground
        oscureView.alpha = 0.0
        self.view.addSubview(oscureView)
        
    }
    private func setUpTeachingNameLabelForSignUp(teaching: Teaching)-> UILabel{
        let teachingNameLabel = UILabel.init(frame: CGRect(x: 10, y: 20, width: signUpView.frame.size.width - 20, height: 20))
               teachingNameLabel.text = teaching.name
               teachingNameLabel.textColor = UIColor.lightWhite
               teachingNameLabel.font = UIFont.boldSystemFont(ofSize: 15)
               teachingNameLabel.textAlignment = .center
               //teachingNameLabel.alpha = 0.0
        return teachingNameLabel
    }
    
    private func setUpTeacherNameLabelForSignUp(teaching: Teaching)->UILabel{
        let teacherNameLabel = UILabel.init(frame: CGRect(x: 10 , y: 45, width: signUpView.frame.size.width - 20, height: 20))
        teacherNameLabel.text = teaching.teacherName
        teacherNameLabel.textColor = UIColor.lightGray
        teacherNameLabel.font = UIFont.boldSystemFont(ofSize: 13)
        teacherNameLabel.textAlignment = .center
        //teacherNameLabel.alpha = 0.0
        return teacherNameLabel
    }
    
    private func setUpSignUpButtonForSignUp(sourceIndexPath: IndexPath) ->UIButton{
        let signUpButton = UIButton(frame: CGRect(x: signUpView.frame.size.width/2 - 0.5, y: 100 , width: 100, height: 40))
        signUpButton.backgroundColor = UIColor.lightWhite
        signUpButton.setTitleColor(UIColor.textBlueColor, for: .normal)
        signUpButton.accessibilityElements = [IndexPath]()
        signUpButton.accessibilityElements?.append(sourceIndexPath)
        signUpButton.addTarget(self, action: #selector(confirmSignup(sender:)), for: .touchUpInside)
        signUpButton.setTitle("Iscriviti", for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: "System", size: 9)
        signUpButton.layer.cornerRadius = 5.0
        roundRightRadius(radius: 5.0, view: signUpButton)
        return signUpButton
    }
    private func setUpCancelButtonForSignUp(sourceIndexPath: IndexPath) ->UIButton{
        let cancelButton = UIButton(frame: CGRect(x: signUpView.frame.size.width/2 - 100 + 0.5 , y: 100, width: 100, height: 40))
        cancelButton.backgroundColor = UIColor.lightWhite
        cancelButton.setTitle("Annulla", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "System", size: 9)
        cancelButton.setTitleColor(UIColor.textRedColor, for: .normal)
        cancelButton.accessibilityElements = [IndexPath]()
        cancelButton.accessibilityElements?.append(sourceIndexPath)
        cancelButton.addTarget(self, action: #selector(hideSignUpViewAnimated), for: .touchUpInside)
        cancelButton.layer.cornerRadius = 5.0
        cancelButton.layer.addBorder(edge: .right, color: #colorLiteral(red: 0.9961728454, green: 0.9902502894, blue: 1, alpha: 1), thickness: 0.5)
        roundLeftRadius(radius: 5.0, view: cancelButton)
        return cancelButton
    }
    
    
    private func setUpSignUpView(sourceIndexPath: IndexPath){
        var teaching : Teaching!
        if self.cdsSearchBar.isFirstResponder || self.cdsSearchBar.text != ""{
            teaching  = self.filteredCDLDataSource[sourceIndexPath.section].teachings[sourceIndexPath.row]
        }
        else{
            teaching  = self.CDLDataSource[sourceIndexPath.section].teachings[sourceIndexPath.row]
        }
        let newFrame = CGRect(x: 0, y: 0, width: self.view.frame.size.width * 0.9, height: 180)
        self.signUpView = UIView.init(frame: newFrame)
        self.view.addSubview(signUpView)
        self.signUpView.backgroundColor = UIColor.primaryBackground
        self.signUpView.layer.borderColor = UIColor.secondaryBackground.cgColor
        self.signUpView.layer.borderWidth = 1.0
        self.signUpView.layer.cornerRadius = 5.0
        self.signUpView.transform = CGAffineTransform(scaleX: 1, y: 0.01)
        self.signUpView.alpha = 0.0
        let teachingNameLabel = setUpTeachingNameLabelForSignUp(teaching: teaching)
        let teacherNameLabel = setUpTeacherNameLabelForSignUp(teaching: teaching)
        let signUpButton = setUpSignUpButtonForSignUp(sourceIndexPath: sourceIndexPath)
        let cancelButton = setUpCancelButtonForSignUp(sourceIndexPath: sourceIndexPath)
        signUpView.addSubview(signUpButton)
        signUpView.addSubview(cancelButton)
        signUpView.addSubview(teacherNameLabel)
        signUpView.addSubview(teachingNameLabel)
        
    }
    
    func showSignUpViewAnimated(cellFrame : CGRect){
        self.navigationItem.rightBarButtonItem?.customView?.isUserInteractionEnabled = false
        let SSAnimator = CoreSSAnimation.getUniqueIstance()
        SSAnimator.expandViewFromSourceFrame(sourceFrame: cellFrame, viewToExpand: self.signUpView, elementsInsideView: nil, oscureView: self.oscureView) { (flag) in
            
        }
    }
    
    @objc func hideSignUpViewAnimated(button: UIButton){
        let indexPath = button.accessibilityElements![0] as! IndexPath
        var cellFrame = self.cdlTableView.rectForRow(at: indexPath)
        cellFrame = self.cdlTableView.convert(cellFrame, to: self.cdlTableView.superview)
        
        let SSAnimator = CoreSSAnimation.getUniqueIstance()
        SSAnimator.collapseViewInSourceFrame(sourceFrame: cellFrame, viewToCollapse: self.signUpView, oscureView: self.oscureView , elementsInsideView: nil) { (flag) in
                self.navigationItem.rightBarButtonItem?.customView?.isUserInteractionEnabled = true
                self.signUpView.removeFromSuperview()
                self.signUpView = nil
                self.oscureView.removeFromSuperview()
                self.oscureView = nil
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
    
    
}


