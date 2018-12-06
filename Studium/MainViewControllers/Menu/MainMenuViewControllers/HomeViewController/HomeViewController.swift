//
//  HomeViewController.swift
//  Studium
//
//  Created by Simone Scionti on 23/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController ,UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var cdlTableView: UITableView!
    @IBOutlet weak var departmentsTableView: UITableView!
    @IBOutlet weak var departmentsSelectButton: UIButton!
   // @IBOutlet weak var departmentsTextField: UITextField!
    var departmentsDataSource = [Department]()
    var CDLDataSource = [HomeTableSection]()
    
   // var selectedDepartment : Department! // in base a questa var cambia il contenuto della tabella CoursesTable
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.departmentsTableView.delegate = self
        self.departmentsTableView.dataSource = self
        self.departmentsTableView.isHidden =  true
        
        self.cdlTableView.delegate = self
        self.cdlTableView.dataSource = self
        
        getDepartments()
        self.departmentsTableView.reloadData()
        
        departmentsSelectButton.layer.cornerRadius = 5.0
        departmentsSelectButton.clipsToBounds = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Corsi", style: .plain, target: self, action: #selector(segueToCorsiPetro))
        
        // Do any additional setup after loading the view.
    }
    
    @objc func segueToCorsiPetro(){
        self.performSegue(withIdentifier: "segueToCorsi", sender: nil)
    }
    
    
    
    func getCDLAndTeachings(ofDepartment : Department){ //questa funzione scaricherà dal db
        self.CDLDataSource.removeAll()
        
        
        if ofDepartment.code == 1 { //dipartimento di informatica
            print("scarico corsi dipartimento indormtatica")
            CDLDataSource.append(HomeTableSection.init(cdl: CDL.init(courseName: "INFORMATICA L-31", courseCode: 31), teachingArray: [Teaching.init(teachingName: "Matematica discreta(M-Z)", teachingCode: 1),Teaching.init(teachingName: "Fondamenti di informatica(M-Z)", teachingCode: 2)]))
            CDLDataSource.append(HomeTableSection.init(cdl: CDL.init(courseName: "MATEMATICA L-27", courseCode: 27), teachingArray: [Teaching.init(teachingName: "Analisi 1", teachingCode: 1),Teaching.init(teachingName: "Algebra 1", teachingCode: 2)]))
            
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
            self.hideDepartmentTableAnimated()
            getCDLAndTeachings(ofDepartment : self.departmentsDataSource[indexPath.row])
        }
        else {
            print(" course Table")
            
            
            
        }
    }
    
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView ==  self.departmentsTableView{
            return 50
        }
        else {
            return 50
        }
      
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView ==  self.departmentsTableView{
            return 1
        }
        else { // cdltable
            return self.CDLDataSource.count
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView ==  self.departmentsTableView{
           // guard section == 0 else { return 0 }
            return departmentsDataSource.count
        }
        else {
            if CDLDataSource[section].expanded == true{ //celle espanse
                return CDLDataSource[section].teachings.count
            }
            else {return 0} // le celle non sono espanse
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
            button.setTitle(CDLDataSource[section].course.name, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            button.setTitleColor(#colorLiteral(red: 0.9103601575, green: 0.9105128646, blue: 0.9103400707, alpha: 1), for: .normal)
            button.backgroundColor = #colorLiteral(red: 0.09844832867, green: 0.09847258776, blue: 0.09844512492, alpha: 1)
            button.tag = section
            button.addTarget(self, action: #selector(self.removeOrExpandRows), for: .touchUpInside)
            return button
            
        
        }
        return nil
    }
    
    @objc func removeOrExpandRows(button : UIButton ){
        let sect = button.tag
        var indices = [IndexPath]()
        var row = 0;
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
            cell.CDLnameLabel.text = self.CDLDataSource[indexPath.section].teachings[indexPath.row].name
            return cell
        }
    }

    
    @IBAction func departmentButtonClicked(_ sender: Any) {
        if self.departmentsTableView.isHidden == true{
            self.showDepartmentTableAnimated()
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
