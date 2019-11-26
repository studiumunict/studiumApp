//
//  HomeViewController.swift
//  Studium
//
//  Created by Simone Scionti on 23/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController ,UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, SWRevealViewControllerDelegate, UISearchBarDelegate {
    deinit{
        print("home deinit")
    }
    @IBOutlet weak var cdsSearchBar: UISearchBar!
    @IBOutlet weak var cdlTableView: UITableView!
    @IBOutlet weak var departmentsTableView: UITableView!
    @IBOutlet weak var departmentsSelectButton: UIButton!
    var departmentsDataSource = [Department]()
    var CDLDataSource = [HomeTableSection]()
    var filteredCDLDataSource = [HomeTableSection]()
    var searchTimer : Timer!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130 //Menu sx
            revealViewController().delegate = self
            self.navigationItem.leftBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))))
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: buttonView2)
        self.navigationItem.rightBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.searchingClicked)))
        
    }
    func setCancelIconOnSearchButton(){
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 2.5, width: 25.5, height: 25))
        imageView2.image = UIImage.init(named: "close")
        let buttonView2 = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 27.5))
        buttonView2.addSubview(imageView2)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: buttonView2)
        self.navigationItem.rightBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.searchingClicked)))
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
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        imageView.image = UIImage.init(named: "menu")
        let buttonView = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        buttonView.addSubview(imageView)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: buttonView)
        setSearchIconOnSearchButton()
       
        let _ = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { (t) in
            self.showDepartmentTableAnimated()
        }
        
        MenuTableViewController.HomeFrontController = self.navigationController
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130 //Menu sx
            revealViewController().delegate = self
            self.navigationItem.leftBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))))
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
        departmentsSelectButton.titleEdgeInsets = .init(top: 0, left: 40, bottom: 0, right: 40)
        
        // Do any additional setup after loading the view.
    }
    
    
    func showSearchBarAnimated(){
        print("mostro searchbar")
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
        self.cdsSearchBar.placeholder =  "Cerca un insegnamento"
        
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
    
    func getTeachingsDuringSearch(searchedText : String){
        let api = BackendAPI.getUniqueIstance()
        api.searchCourse(searchedText: searchedText) { (JSONData) in
            //print(JSONData)
            
            var teachings = [Teaching]()
            if(JSONData == nil) {return}
            for teaching in JSONData as! [Any]{
                let teach = teaching as! [String:Any]
                let teachTitle = teach["title"] as! String
                var teachTitleLowercased = teachTitle.lowercased()
                teachTitleLowercased.capitalizeFirstLetter()
                let newTeach = Teaching.init(teachingName: teachTitleLowercased, category: teach["category"] as! String, teachingCode: teach["code"] as! String, teacherName: teach["tutorname"] as! String, signedUp: false)
                teachings.append(newTeach)
            }
            var newCDL : CDL
            if(teachings.count == 0){
                newCDL = CDL.init(courseName: "Nessun insegnamento trovato", courseCode: nil, courseId: nil, parent: nil)
            }
            else{
                 newCDL = CDL.init(courseName: "Insegnamenti trovati", courseCode: nil, courseId: nil, parent: nil)
            }
            let tableSection = HomeTableSection.init(cdl: newCDL, teachingArray: teachings, setExpanded: true)
            self.filteredCDLDataSource.removeAll()
            
            self.filteredCDLDataSource.append(tableSection)
            self.cdlTableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if self.searchTimer == nil && searchBar.text != "" {
            self.searchTimer  = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (t) in
              //  print("cerco testo 1", searchBar.text!)
                self.getTeachingsDuringSearch(searchedText: searchBar.text!)
                self.searchTimer = nil
            }
        }
        else if searchBar.text != ""{
            self.searchTimer.invalidate()
            self.searchTimer  = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (t) in
                //print("cerco testo 2", searchBar.text!)
                self.getTeachingsDuringSearch(searchedText: searchBar.text!)
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
        self.cdlTableView.reloadData()
        let api =  BackendAPI.getUniqueIstance()
        api.getCDL(departmentCode: ofDepartment.code) { (JSONData) in
            if JSONData == nil {return}
            var i = 0
            let JSONArray = JSONData as! [Any]
            for cdl in JSONArray{
                let corso = cdl as! [String:Any]
                //creo cdl
                let newCDL = CDL.init(courseName: corso["name"] as? String, courseCode: corso["code"] as? String, courseId: corso["id"] as? Int, parent: corso["parent"] as? String)
                //scarico insegnamenti del cdl
                var teachings = [Teaching]()
                api.getTeachings(CDLCode: newCDL.code, completion: { (JSONData) in
                   print("CHIAMATA API")
                    //print(JSONData)
                    if(JSONData == nil) {return}
                    for teaching in JSONData as! [Any]{
                        let teach = teaching as! [String:Any]
                        let teachTitle = teach["title"] as! String
                        var teachTitleLowercased = teachTitle.lowercased()
                        teachTitleLowercased.capitalizeFirstLetter()
                        let newTeach = Teaching.init(teachingName: teachTitleLowercased, category: teach["category"] as! String, teachingCode: teach["code"] as! String, teacherName: teach["tutorname"] as! String, signedUp: false)
                        teachings.append(newTeach)
                    }
                   //salvo il singolo corso di laurea con tutti i suoi insegnamenti
                   let tableSection = HomeTableSection.init(cdl: newCDL, teachingArray: teachings, setExpanded: false)
                    self.CDLDataSource.append(tableSection)
                    if i == JSONArray.count-1 {
                        self.cdlTableView.reloadData()
                    }
                    i += 1
                })
            }
            
        }
    }
    
    func getDepartments(){
        let api = BackendAPI.getUniqueIstance()
        api.getDepartments(completion: { (jsonData) in
            //print(jsonData)
            if jsonData == nil {return}
            for dep in jsonData as! [Any]{
                let depDict =  dep as! [String:Any]
                let depName = depDict["name"] as? String
                var lowName = depName!.lowercased()
                lowName.capitalizeFirstLetter()
                //capitalize first letter
                self.departmentsDataSource.append(Department.init(depName: lowName, depCode: depDict["code"] as? String, id: depDict["id"] as? Int))
            }
            self.departmentsTableView.reloadData()
        })
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.departmentsTableView{
            self.CDLDataSource.removeAll()
            self.cdlTableView.reloadData()
            self.departmentsSelectButton.setTitleColor(UIColor.darkGray, for: .normal)
            self.departmentsSelectButton.setTitle(self.departmentsDataSource[indexPath.row].name, for: .normal)
            self.view.endEditing(true)
            self.cdlTableView.isHidden = false
            self.hideDepartmentTableAnimated()
            
            getCDLAndTeachings(ofDepartment : self.departmentsDataSource[indexPath.row])
        }
        else {
            self.performSegue(withIdentifier: "segueToTeachingController", sender: indexPath)
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
            return 100
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
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.cdlTableView {
            
            let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
            button.layer.cornerRadius = 5.0
            button.clipsToBounds = true
            //button.titleRect(forContentRect: CGRect(x: 20, y: 0, width: button.frame.width - 40, height: button.frame.height))
            
            
            let arrowImageView = UIImageView.init(frame: CGRect(x: 10, y: button.frame.height/2 - 7.5, width: 15, height: 15))
            arrowImageView.image = UIImage.init(named: "arrow");
            button.addSubview(arrowImageView)
            let SSAnimator = CoreSSAnimation.getUniqueIstance()
            
            if self.cdsSearchBar.isFirstResponder || self.cdsSearchBar.text != ""{
                button.setTitle(filteredCDLDataSource[section].course.name, for: .normal)
                
                if filteredCDLDataSource[section].expanded {
                    SSAnimator.rotate180Degrees(view: button,animated: false)
                }
            }
            else{
                button.setTitle(CDLDataSource[section].course.name, for: .normal)
                if CDLDataSource[section].expanded {
                    SSAnimator.rotate180Degrees(view: button,animated: false)
                }
            }
            
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            button.setTitleColor(UIColor.lightWhite, for: .normal)
            //button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleEdgeInsets = .init(top: 0, left: 40, bottom: 0, right: 40)
            //button.titleLabel?.frame = CGRect(x: 100, y: 0, width: button.frame.width - 200, height: button.frame.height)
            button.backgroundColor = UIColor.tableSectionColor
            button.tag = section
            button.addTarget(self, action: #selector(self.removeOrExpandRows), for: .touchUpInside)
           
            
            
            return button
            
        
        }
        return nil
    }
    
    
    
    @objc func removeOrExpandRows(button : UIButton ){
        let SSAnimator = CoreSSAnimation.getUniqueIstance()
        SSAnimator.rotate180Degrees(view: button, animated: true)
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
            let cell = cdlTableView.dequeueReusableCell(withIdentifier: "CDLCell") as! CDLTableViewCell
            //modifico la cella e la mostro
            var dataElement : Teaching!
            if self.cdsSearchBar.isFirstResponder || self.cdsSearchBar.text != ""{
                print("prendo dal filtered")
                 dataElement = self.filteredCDLDataSource[indexPath.section].teachings[indexPath.row]
            }
            else{
                 dataElement = self.CDLDataSource[indexPath.section].teachings[indexPath.row]
            }
            cell.CDLnameLabel.text = dataElement.name
            cell.teacherNameLabel.text = dataElement.teacherName
            if dataElement.signedUp{
                cell.signedUpImage.image = UIImage.init(named: "star_full")
            }
            else{
                cell.signedUpImage.image = UIImage.init(named: "star_empty")
            }
            cell.codeLabel.text = String(dataElement.code)
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
}
