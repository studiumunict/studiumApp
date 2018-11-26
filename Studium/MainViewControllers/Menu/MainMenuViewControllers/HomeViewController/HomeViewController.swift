//
//  HomeViewController.swift
//  Studium
//
//  Created by Simone Scionti on 23/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController ,UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var departmentsTableView: UITableView!
    @IBOutlet weak var departmentsTextField: UITextField!
    var departmentsDataSource = [Departments]()
    var selectedDepartments : Departments! // in base a questa var cambia il contenuto della tabella CoursesTable
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.departmentsTableView.delegate = self
        self.departmentsTableView.dataSource = self
        self.departmentsTableView.isHidden =  true
        getDepartments()
        self.departmentsTableView.reloadData()
        
        print(departmentsDataSource.count)
        // Do any additional setup after loading the view.
    }
    
    func getDepartments(){
        departmentsDataSource.append(Departments.init(depName: "Matematica e Informatica", depCode: 1))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView ==  self.departmentsTableView{
            return 50
        }
        else {
            print(" course Table")
        }
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView ==  self.departmentsTableView{
            return 1
        }
        else {
            print(" course Table")
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView ==  self.departmentsTableView{
           // guard section == 0 else { return 0 }
            return departmentsDataSource.count
        }
        else {
            print(" course Table")
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.departmentsTableView{
            self.departmentsTextField.text = self.departmentsDataSource[indexPath.row].name
            self.view.endEditing(true)
            
            self.hideDepartmentTableAnimated()
        }
        else {
            print(" course Table")
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView ==  self.departmentsTableView{
            print("creo cella")
            let cell = departmentsTableView.dequeueReusableCell(withIdentifier: "departmentCell") as! DepartmentTableViewCell
            //modifico la cella e la mostro
            cell.departmentName.text = self.departmentsDataSource[indexPath.row].name
            return cell
            
        }
        else {
            print("course Table")
            let cell = UITableViewCell()
            return cell
        }
    }

    @IBAction func departmentTextFieldEditingBegin(_ sender: Any) {
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
