//
//  ManageCourseViewController.swift
//  Studium
//
//  Created by Simone Scionti on 14/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class ManageCourseViewController: UIViewController, SWRevealViewControllerDelegate, UITableViewDataSource, UITableViewDelegate {
   
    
    //facciamo un for che setta tutte le section ad expanded, poi quando si rivà sul i miei corsi controller, si lasciano tutte expandend richiamando il reloaddata di quella tableview
    
    
    @IBOutlet weak var manageCoursesTableView: UITableView!
    
    func setAllExpanded(){
        for sect in courseSharedDataSource{
            sect.expanded = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.view.backgroundColor = UIColor.green
        self.manageCoursesTableView.backgroundColor = UIColor.lightWhite
        self.view.backgroundColor = UIColor.lightWhite
        
        manageCoursesTableView.delegate = self
        manageCoursesTableView.dataSource = self
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130//Menu sx/
            revealViewController().delegate = self
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130//Menu sx/
            revealViewController().delegate = self
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        if courseSharedDataSource.count == 0 {
            reloadSourceFromAPI();
            
        }
        else{
            self.setAllExpanded()
        }
    }
    
    func reloadSourceFromAPI(){ // setta tutto ad expanded
        
        courseSharedDataSource.append(HomeTableSection.init(cdl: CDL.init(courseName: "Materie date", courseCode: 31), teachingArray:
            [Teaching.init(teachingName: "Matematica discreta(M-Z)", teachingCode: 1375, teacherName: "Andrea Scapellato", signedUp: true),Teaching.init(teachingName: "Fondamenti di informatica(M-Z)", teachingCode: 6723,teacherName: "Franco Barbanera", signedUp: false)], setExpanded: true))
        
        
        courseSharedDataSource.append(HomeTableSection.init(cdl: CDL.init(courseName: "Materie da dare", courseCode: 27), teachingArray: [Teaching.init(teachingName: "Elementi di Analisi matematica 1", teachingCode: 8675, teacherName: "Ornella Naselli", signedUp: false),Teaching.init(teachingName: "Algebra 1", teachingCode: 8760, teacherName: "Andrea Scapellato", signedUp: false)], setExpanded: true))
        manageCoursesTableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if courseSharedDataSource[section].expanded {
            return courseSharedDataSource[section].teachings.count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = manageCoursesTableView.dequeueReusableCell(withIdentifier: "teachingCell") as! CoursesTableViewCell
        //modifico la cella e la mostro
        var dataElement : Teaching!
        
        dataElement = courseSharedDataSource[indexPath.section].teachings[indexPath.row]
        
        cell.teachingNameLabel.text = dataElement.name
        cell.teacherNameLabel.text = dataElement.teacherName
        cell.arrowImage.image =  UIImage.init(named: "menu")?.withRenderingMode(.alwaysTemplate)
        cell.arrowImage.tintColor = UIColor.elementsLikeNavBarColor
        cell.arrowImage.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  self.performSegue(withIdentifier: "segueToTeachingController", sender: indexPath)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let  controller = segue.destination as? TeachingViewController{
            let index = sender as! IndexPath
            controller.teachingDataSource = courseSharedDataSource[index.section].teachings[index.row]
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 45))
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        
        /*
        let arrowImageView = UIImageView.init(frame: CGRect(x: 10, y: button.frame.height/2 - 7.5, width: 15, height: 15))
        arrowImageView.image = UIImage.init(named: "arrow")?.withRenderingMode(.alwaysTemplate);
        arrowImageView.tintColor = UIColor.elementsLikeNavBarColor
        button.addSubview(arrowImageView)
        */
        
        
        button.setTitle(courseSharedDataSource[section].course.name, for: .normal)
        if courseSharedDataSource[section].expanded {
            rotateArrows180Degrees(button: button,animated: false)
        }
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.elementsLikeNavBarColor, for: .normal)
        button.backgroundColor = UIColor.lightSectionColor
        button.tag = section
       // button.addTarget(self, action: #selector(self.removeOrExpandRows), for: .touchUpInside)
        
        
        
        return button
        
        
    }
    
   /* @objc func removeOrExpandRows(button : UIButton ){
        rotateArrows180Degrees(button: button,animated: true)
        let sect = button.tag
        var indices = [IndexPath]()
        var row = 0;
        
        for _ in courseSharedDataSource[sect].teachings{ // salva tutti gli indici
            indices.append(IndexPath.init(row: row, section: sect))
            row += 1
        }
        
        if courseSharedDataSource[sect].expanded == true{ //RIMUOVE LE RIGHE
            courseSharedDataSource[sect].expanded = false
            self.manageCoursesTableView.deleteRows(at: indices, with: .fade)
        }
        else{
            courseSharedDataSource[sect].expanded = true
            self.manageCoursesTableView.insertRows(at: indices, with: .fade)
        }
        
    }
    */
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
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return courseSharedDataSource.count
    }
    
    
    
    

}
