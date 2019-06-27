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
        let signUpButton = UIButton(frame: CGRect(x: signUpView.frame.size.width/2 - 5, y: 100 , width: 120, height: 50))
        let cancelButton = UIButton(frame: CGRect(x: signUpView.frame.size.width/2 - 115, y: 100, width: 120, height: 50))
        signUpButton.backgroundColor = UIColor.lightWhite
        cancelButton.backgroundColor = UIColor.lightWhite
        signUpButton.setTitleColor(UIColor.textBlueColor, for: .normal)
        signUpButton.setTitle("Iscriviti", for: .normal)
        cancelButton.setTitle("Annulla", for: .normal)
        cancelButton.setTitleColor(UIColor.textRedColor, for: .normal)
        cancelButton.addTarget(self, action: #selector(hideSignUpViewAnimated), for: .touchUpInside)
        cancelButton.accessibilityElements = [IndexPath]()
        cancelButton.accessibilityElements?.append(indexPath)
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




/*UIViewController ,UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, SWRevealViewControllerDelegate, UISearchBarDelegate {
    deinit{
        print("home deinit")
    }
    var tabController : ManageCoursePageViewController!
    @IBOutlet weak var cdsSearchBar: UISearchBar!
    @IBOutlet weak var cdlTableView: UITableView!
    @IBOutlet weak var departmentsTableView: UITableView!
    @IBOutlet weak var departmentsSelectButton: UIButton!
    // @IBOutlet weak var departmentsTextField: UITextField!
    var departmentsDataSource = [Department]()
    var CDLDataSource = [HomeTableSection]()
    var filteredCDLDataSource = [HomeTableSection]()
    var searchTimer : Timer!
    var oscureView : UIView!
    var signUpView : UIView!
    // var selectedDepartment : Department! // in base a questa var cambia il contenuto della tabella CoursesTable
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130 //Menu sx
            revealViewController().delegate = self
           /* self.navigationItem.leftBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))))*/
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        print("moved")
        switch position {
        case .right:
            print("right")
            self.cdsSearchBar.resignFirstResponder()
            if (cdsSearchBar.isHidden == false && cdsSearchBar.text == ""){
                hideSearchBarAnimated()
            }
            self.departmentsSelectButton.isUserInteractionEnabled = false
            self.cdlTableView.isUserInteractionEnabled = false
            self.departmentsTableView.isUserInteractionEnabled = false
            
            
            break
        case .left :
            print("move to left")
            self.departmentsSelectButton.isUserInteractionEnabled = true
            self.cdlTableView.isUserInteractionEnabled = true
            self.departmentsTableView.isUserInteractionEnabled = true
            
            break
            
        default:
            break
        }
    }
    
    func setSearchIconOnSearchButton(){
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 2.5, width: 25.5, height: 25))
        imageView2.image = UIImage.init(named: "search")
        let buttonView2 = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 27.5))
        buttonView2.addSubview(imageView2)
        self.tabController.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: buttonView2)
        self.tabController.navigationItem.rightBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.searchingClicked)))
        
    }
    func setCancelIconOnSearchButton(){
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 2.5, width: 25.5, height: 25))
        imageView2.image = UIImage.init(named: "close")
        let buttonView2 = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 27.5))
        buttonView2.addSubview(imageView2)
        self.tabController.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: buttonView2)
        self.tabController.navigationItem.rightBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.searchingClicked)))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cdlTableView.isHidden = true
        self.cdsSearchBar.isHidden = true
        self.cdsSearchBar.backgroundImage = UIImage()
        self.cdsSearchBar.delegate = self
        let textFieldInsideSearchBar = cdsSearchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = UIColor.lightWhite
        textFieldInsideSearchBar?.font = UIFont.boldSystemFont(ofSize: 16)
        textFieldInsideSearchBar?.textColor = UIColor.secondaryBackground
        /*
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        imageView.image = UIImage.init(named: "menu")
        let buttonView = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        buttonView.addSubview(imageView)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: buttonView)
        
        */
       // setSearchIconOnSearchButton()
        let _ = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { (t) in
            self.showDepartmentTableAnimated()
        }
        
       
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130 //Menu sx
            revealViewController().delegate = self
            /*self.navigationItem.leftBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))))*/
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        
        self.departmentsTableView.delegate = self
        self.departmentsTableView.dataSource = self
        self.departmentsTableView.isHidden =  true
        
        self.cdlTableView.delegate = self
        self.cdlTableView.dataSource = self
        
        getDepartments()
        self.departmentsTableView.reloadData()
        
        departmentsSelectButton.layer.cornerRadius = 5.0
        departmentsSelectButton.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    
    func showSearchBarAnimated(){
        setCancelIconOnSearchButton()
        self.cdsSearchBar.alpha = 0.0
        self.cdsSearchBar.isHidden = false
        if departmentsTableView.isHidden == false {
            hideDepartmentTableAnimated()
        }
        if cdlTableView.isHidden{
            self.cdlTableView.alpha = 0.0
            self.cdlTableView.isHidden = false
        }
        
        self.cdsSearchBar.becomeFirstResponder()
        self.filteredCDLDataSource.removeAll()
        self.cdlTableView.reloadData()
        UIView.animate(withDuration: 0.4, animations: {
            self.cdsSearchBar.alpha = 1.0
            self.cdlTableView.alpha = 1.0
        }) { (t) in
            
        }
    }
    
    
    func hideSearchBarAnimated(){
        setSearchIconOnSearchButton()
        self.departmentsSelectButton.isHidden = false
        self.cdsSearchBar.resignFirstResponder()
        self.cdsSearchBar.text = ""
        self.cdlTableView.reloadData()
        UIView.animate(withDuration: 0.4, animations: {
            self.cdsSearchBar.alpha = 0.0
        }) { (t) in
            self.cdsSearchBar.isHidden = true
            
        }
    }
    @objc func searchingClicked(){
        
        if self.cdsSearchBar.isHidden {
            showSearchBarAnimated()
            print("inizio ricerca")
            
        }
        else{
            hideSearchBarAnimated()
        }
    }
    
    func getTeachingsDuringSearch(serchedText : String){
        self.filteredCDLDataSource.removeAll()
        filteredCDLDataSource.append(HomeTableSection.init(cdl: CDL.init(courseName: "INFORMATICA L-31", courseCode: 31), teachingArray:
            [Teaching.init(teachingName: "Matematica discreta(M-Z)", teachingCode: 1375, teacherName: "Andrea Scapellato", signedUp: true),Teaching.init(teachingName: "Fondamenti di informatica(M-Z)", teachingCode: 6723,teacherName: "Franco Barbanera", signedUp: false)], setExpanded: true))
        self.cdlTableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if self.searchTimer == nil && searchBar.text != "" {
            self.searchTimer  = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (t) in
                //  print("cerco testo 1", searchBar.text!)
                self.getTeachingsDuringSearch(serchedText: searchBar.text!)
                self.searchTimer = nil
            }
        }
        else if searchBar.text != ""{
            self.searchTimer.invalidate()
            self.searchTimer  = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (t) in
                //print("cerco testo 2", searchBar.text!)
                self.getTeachingsDuringSearch(serchedText: searchBar.text!)
                self.searchTimer = nil
            }
        }
        else if searchBar.text == ""{
            self.searchTimer = nil
            //print("stringa vuota, rimuovo elementi cercati")
            self.filteredCDLDataSource.removeAll()
            self.cdlTableView.reloadData()
        }
        
    }
    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // print("beginEditingSearch")
        self.cdlTableView.reloadData()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //print("endEditingSearch")
        self.cdlTableView.reloadData()
    }
    
    
    func getCDLAndTeachings(ofDepartment : Department){ //questa funzione scaricherà dal db
        self.CDLDataSource.removeAll()
        if ofDepartment.code == 1 { //dipartimento di informatica
            print("scarico corsi dipartimento informtatica")
            CDLDataSource.append(HomeTableSection.init(cdl: CDL.init(courseName: "INFORMATICA L-31", courseCode: 31), teachingArray:
                [Teaching.init(teachingName: "Matematica discreta(M-Z)", teachingCode: 1375, teacherName: "Andrea Scapellato", signedUp: true),Teaching.init(teachingName: "Fondamenti di informatica(M-Z)", teachingCode: 6723,teacherName: "Franco Barbanera", signedUp: false)], setExpanded: false))
            
            
            CDLDataSource.append(HomeTableSection.init(cdl: CDL.init(courseName: "MATEMATICA L-27", courseCode: 27), teachingArray: [Teaching.init(teachingName: "Elementi di Analisi matematica 1 drl corso mz", teachingCode: 8675, teacherName: "Ornella Naselli", signedUp: false),Teaching.init(teachingName: "Algebra 1", teachingCode: 8760, teacherName: "Andrea Scapellato", signedUp: false)], setExpanded: false))
            
        }
        
        self.cdlTableView.reloadData()
    }
    
    func getDepartments(){
        departmentsDataSource.append(Department.init(depName: "Matematica e Informatica", depCode: 1))
        departmentsDataSource.append(Department.init(depName: "Ingegneria informatica", depCode: 2))
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let  controller = segue.destination as? TeachingViewController{
            let index = sender as! IndexPath
            if self.cdsSearchBar.isFirstResponder || self.cdsSearchBar.text != ""{
                controller.teachingDataSource = filteredCDLDataSource[index.section].teachings[index.row]
            }
            else{
                controller.teachingDataSource = CDLDataSource[index.section].teachings[index.row]
            }
            
        }
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.cdsSearchBar.resignFirstResponder()
        if (cdsSearchBar.isHidden == false && cdsSearchBar.text == ""){
            hideSearchBarAnimated()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView ==  self.departmentsTableView{
            return 50
        }
        else {
            return 70
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView ==  self.departmentsTableView{
            return 1
        }
        else { // cdltable
            if self.cdsSearchBar.isFirstResponder || self.cdsSearchBar.text != ""{
                return filteredCDLDataSource.count
            }
            else{
                return self.CDLDataSource.count
            }
            
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView ==  self.departmentsTableView{
            // guard section == 0 else { return 0 }
            return departmentsDataSource.count
        }
        else {
            if self.cdsSearchBar.isFirstResponder || self.cdsSearchBar.text != ""{
                if filteredCDLDataSource[section].expanded == true{ //celle espanse
                    return filteredCDLDataSource[section].teachings.count
                }
                else {return 0} // le celle non sono espanse
            }
            else{
                if CDLDataSource[section].expanded == true{ //celle espanse
                    return CDLDataSource[section].teachings.count
                }
                else {return 0} // le celle non sono espanse
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.cdlTableView {
            return 45
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.cdlTableView {
            
            let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 45))
            button.layer.cornerRadius = 5.0
            button.clipsToBounds = true
            
            
            let arrowImageView = UIImageView.init(frame: CGRect(x: 10, y: button.frame.height/2 - 7.5, width: 15, height: 15))
            arrowImageView.image = UIImage.init(named: "arrow");
            button.addSubview(arrowImageView)
            
            
            if self.cdsSearchBar.isFirstResponder || self.cdsSearchBar.text != ""{
                button.setTitle(filteredCDLDataSource[section].course.name, for: .normal)
                if filteredCDLDataSource[section].expanded {
                    rotateArrows180Degrees(button: button,animated: false)
                }
            }
            else{
                button.setTitle(CDLDataSource[section].course.name, for: .normal)
                if CDLDataSource[section].expanded {
                    rotateArrows180Degrees(button: button,animated: false)
                }
            }
            
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            button.setTitleColor(UIColor.lightWhite, for: .normal)
            button.backgroundColor = UIColor.tableSectionColor
            button.tag = section
            button.addTarget(self, action: #selector(self.removeOrExpandRows), for: .touchUpInside)
            
            
            
            return button
            
            
        }
        return nil
    }
    
    func rotateArrows180Degrees(button : UIButton,animated : Bool){
        for view in button.subviews{
            if let imageView = view as? UIImageView{
                if imageView.transform == .identity{
                    if animated{
                        UIView.animate(withDuration: 0.2) {
                            imageView.transform = CGAffineTransform(rotationAngle: .pi)
                        }
                    }
                    else {
                        imageView.transform = CGAffineTransform(rotationAngle: .pi)
                    }
                    
                }
                else{
                    if animated {
                        UIView.animate(withDuration: 0.2) {
                            imageView.transform = .identity
                        }
                    }
                    else{
                        imageView.transform = .identity
                    }
                }
            }
        }
    }
    
    
    @objc func removeOrExpandRows(button : UIButton ){
        rotateArrows180Degrees(button: button,animated: true)
        let sect = button.tag
        var indices = [IndexPath]()
        var row = 0;
        if self.cdsSearchBar.isFirstResponder || self.cdsSearchBar.text != ""{
            for _ in filteredCDLDataSource[sect].teachings{ // salva tutti gli indici
                indices.append(IndexPath.init(row: row, section: sect))
                row += 1
            }
            
            if filteredCDLDataSource[sect].expanded == true{ //RIMUOVE LE RIGHE
                filteredCDLDataSource[sect].expanded = false
                self.cdlTableView.deleteRows(at: indices, with: .fade)
            }
            else{
                filteredCDLDataSource[sect].expanded = true
                self.cdlTableView.insertRows(at: indices, with: .fade)
            }
            
            
        }
        else{
            for _ in CDLDataSource[sect].teachings{ // salva tutti gli indici
                indices.append(IndexPath.init(row: row, section: sect))
                row += 1
            }
            
            if CDLDataSource[sect].expanded == true{ //RIMUOVE LE RIGHE
                CDLDataSource[sect].expanded = false
                self.cdlTableView.deleteRows(at: indices, with: .fade)
            }
            else{
                CDLDataSource[sect].expanded = true
                self.cdlTableView.insertRows(at: indices, with: .fade)
            }
            
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    
    @IBAction func departmentButtonClicked(_ sender: Any) {
        if self.departmentsTableView.isHidden == true{
            self.showDepartmentTableAnimated()
        }
        else {
            self.hideDepartmentTableAnimated()
        }
    }
    func hideDepartmentTableAnimated(){
        
        UIView.animate(withDuration: 0.3, animations: {
            self.departmentsTableView.alpha = 0.0
        }) { (t) in
            self.departmentsTableView.isHidden =  true
        }
        
    }
    func showDepartmentTableAnimated(){
        departmentsTableView.alpha = 0.0
        departmentsTableView.isHidden =  false
        UIView.animate(withDuration: 0.3, animations: {
            self.departmentsTableView.alpha = 1.0
        }) { (t) in
            
        }
        
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
        let signUpButton = UIButton(frame: CGRect(x: signUpView.frame.size.width/2 - 5, y: 100 , width: 120, height: 50))
        let cancelButton = UIButton(frame: CGRect(x: signUpView.frame.size.width/2 - 115, y: 100, width: 120, height: 50))
        signUpButton.backgroundColor = UIColor.lightWhite
        cancelButton.backgroundColor = UIColor.lightWhite
        signUpButton.setTitleColor(UIColor.textBlueColor, for: .normal)
        signUpButton.setTitle("Iscriviti", for: .normal)
        cancelButton.setTitle("Annulla", for: .normal)
        cancelButton.setTitleColor(UIColor.textRedColor, for: .normal)
        cancelButton.addTarget(self, action: #selector(hideSignUpViewAnimated), for: .touchUpInside)
        cancelButton.accessibilityElements = [IndexPath]()
        cancelButton.accessibilityElements?.append(indexPath)
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



*/
