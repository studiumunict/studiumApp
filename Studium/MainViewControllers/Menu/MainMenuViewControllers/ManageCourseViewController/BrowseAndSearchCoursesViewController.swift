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
        else {// E' stato selezionato un corso -> fai comparire la view per iscriversi  al corso
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
            cell.departmentName.text = self.departmentsDataSource[indexPath.row].name
            return cell
            
        }
        else { //CDL table
            let cell = cdlTableView.dequeueReusableCell(withIdentifier: "teachingCell") as! BrowseAndSearchCourseTableViewCell
            var dataElement : Teaching!
            if self.cdsSearchBar.isFirstResponder || self.cdsSearchBar.text != ""{
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
        let indexPath = sender.accessibilityElements![1] as! IndexPath
        let courseCode : String
        if self.cdsSearchBar.isFirstResponder || self.cdsSearchBar.text != ""{
            courseCode = self.filteredCDLDataSource[indexPath.section].teachings[indexPath.row].code
        }
        else{
            courseCode = self.CDLDataSource[indexPath.section].teachings[indexPath.row].code
        }
        let CV = ConfirmView.getUniqueIstance()
        CV.startWaiting(confirmView: &signUpView)
        let api =  BackendAPI.getUniqueIstance(fromController: self)
        api.addCourse(codCourse: courseCode) { (JSONResponse) in
            guard JSONResponse != nil else{
                CV.stopWaiting(confirmView: &self.signUpView)
                return
            }
            SharedCoursesSource.getUniqueIstance().reloadSourceFromAPI(fromController: self) { (flag) in
                if flag {
                    self.setupSignUpViewForConfirmSubscription(senderButton: sender)
                }
                CV.stopWaiting(confirmView: &self.signUpView)
            }
        }
        
    }
    
    private func setUpSubscriptedLabelForSignUp() -> UILabel{
        let CV = ConfirmView.getUniqueIstance()
        return CV.getTitleLabel(text: "Iscrizione effettuata")
    }
    
    private func setUpCheersLabelForSignUp() -> UILabel{
        let CV = ConfirmView.getUniqueIstance()
        return CV.getDescriptionLabel(text: "Troverai il corso nella sezione \"I miei corsi\" ")
    }
    
    private func setupSignUpViewForConfirmSubscription(senderButton: UIButton){
        let CV = ConfirmView.getUniqueIstance()
        let subscriptedLabel = self.setUpSubscriptedLabelForSignUp()
        let cheersLabel = self.setUpCheersLabelForSignUp()
        let indexPath = senderButton.accessibilityElements?[1] as! IndexPath
        let closeConfirmButton = self.setupCloseConfirmSignUpButton(sourceIndexPath: indexPath)
        CV.updateView(confirmView: &self.signUpView, titleLabel: subscriptedLabel, descLabel: cheersLabel, buttons: [closeConfirmButton], dataToAttach: nil, animated: true)
    }
    
    private func setupCloseConfirmSignUpButton(sourceIndexPath: IndexPath) -> UIButton{
        let CV = ConfirmView.getUniqueIstance()
        return CV.getButton(position: .alone, dataToAttach: sourceIndexPath, title: "Chiudi", selector: #selector(hideSignUpViewAnimated(button:)), target: self)
    }
    
    private func setUpOscureView(){
        oscureView = UIView.init(frame: self.view.frame)
        oscureView.backgroundColor = UIColor.primaryBackground
        oscureView.alpha = 0.0
        self.view.addSubview(oscureView)
        
    }
    private func setUpTeachingNameLabelForSignUp(teaching: Teaching)-> UILabel{
        let CV = ConfirmView.getUniqueIstance()
        return CV.getTitleLabel(text: teaching.name)
    }
    
    private func setUpTeacherNameLabelForSignUp(teaching: Teaching)->UILabel{
        let CV = ConfirmView.getUniqueIstance()
        return CV.getDescriptionLabel(text: teaching.teacherName)
    }
    
    private func setUpSignUpButtonForSignUp(sourceIndexPath: IndexPath) ->UIButton{
        let CV = ConfirmView.getUniqueIstance()
        return CV.getButton(position: .right, dataToAttach: sourceIndexPath, title: "Iscriviti", selector: #selector(confirmSignup(sender:)), target: self)
       
    }
    private func setUpCancelButtonForSignUp(sourceIndexPath: IndexPath) ->UIButton{
        let CV = ConfirmView.getUniqueIstance()
        return CV.getButton(position: .left, dataToAttach: sourceIndexPath, title: "Annulla", selector: #selector(hideSignUpViewAnimated), target: self)
    }
    
    
    private func setUpSignUpView(sourceIndexPath: IndexPath){
        var teaching : Teaching!
        if self.cdsSearchBar.isFirstResponder || self.cdsSearchBar.text != ""{
            teaching  = self.filteredCDLDataSource[sourceIndexPath.section].teachings[sourceIndexPath.row]
        }
        else{
            teaching  = self.CDLDataSource[sourceIndexPath.section].teachings[sourceIndexPath.row]
        }
        let CV = ConfirmView.getUniqueIstance()
        let teachingNameLabel = setUpTeachingNameLabelForSignUp(teaching: teaching)
        let teacherNameLabel = setUpTeacherNameLabelForSignUp(teaching: teaching)
        let signUpButton = setUpSignUpButtonForSignUp(sourceIndexPath: sourceIndexPath)
        let cancelButton = setUpCancelButtonForSignUp(sourceIndexPath: sourceIndexPath)
        self.signUpView = CV.getView(titleLabel: teachingNameLabel, descLabel: teacherNameLabel, buttons: [signUpButton,cancelButton], dataToAttach: nil)
        self.view.addSubview(signUpView)
        
    }
    
    func showSignUpViewAnimated(cellFrame : CGRect){
        self.navigationItem.rightBarButtonItem?.customView?.isUserInteractionEnabled = false
        let SSAnimator = CoreSSAnimation.getUniqueIstance()
        SSAnimator.expandViewFromSourceFrame(sourceFrame: cellFrame, viewToExpand: self.signUpView, elementsInsideView: nil, oscureView: self.oscureView) { (flag) in
            
        }
    }
    
    @objc func hideSignUpViewAnimated(button: UIButton){
        let indexPath = button.accessibilityElements![1] as! IndexPath
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
    
   /*override func getCDLAndTeachings(ofDepartment : Department){ //questa funzione scaricherà dal db
           self.cdlTableView.startWaitingData()
           self.CDLDataSource.removeAll()
           self.cdlTableView.reloadData()
           //print("Dipartimento selezionato:", ofDepartment.code)
           let api =  BackendAPI.getUniqueIstance(fromController: self)
           api.getCDL(departmentCode: ofDepartment.code) { (JSONData) in
               if JSONData == nil {
                   self.cdlTableView.stopWaitingData()
                   return
               }
               var i = 0
               let JSONArray = JSONData as! [Any]
               for cdl in JSONArray{
                   let corso = cdl as! [String:Any]
                   //creo cdl
                   let newCDL = CDL.init(courseName: corso["name"] as? String, courseCode: corso["code"] as? String, courseId: corso["id"] as? Int, parent: corso["parent"] as? String)
                   //scarico insegnamenti del cdl
                   print("CORSO DI LAUREA CODE: ", newCDL.code! );
                   
                   var teachings = [Teaching]()
                   api.getTeachingsToSubscribe(CDLCode: newCDL.code!, completion: { (JSONData) in
                      print("CHIAMATA API")
                       //print(JSONData)
                       if(JSONData == nil) {
                           self.cdlTableView.stopWaitingData()
                           return
                       }
                       
                       for teaching in JSONData as! [Any]{
                           let teach = teaching as! [String:Any]
                           let teachTitle = teach["title"] as! String
                           var teachTitleLowercased = teachTitle.lowercased()
                           teachTitleLowercased.capitalizeFirstLetter()
                           let newTeach = Teaching.init(teachingName: teachTitleLowercased, category: teach["category"] as! String, teachingCode: teach["code"] as! String, teacherName: teach["tutorName"] as! String, signedUp: false)
                           teachings.append(newTeach)
                       }
                      //salvo il singolo corso di laurea con tutti i suoi insegnamenti
                      let tableSection = HomeTableSection.init(cdl: newCDL, teachingArray: teachings, setExpanded: false)
                       self.CDLDataSource.append(tableSection)
                       if i == JSONArray.count-1 {
                           self.cdlTableView.reloadData()
                           self.cdlTableView.stopWaitingData()
                       }
                       i += 1
                   })
               }
               
           }
       }*/
       
    
    
    
    
}


