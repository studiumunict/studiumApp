//
//  CoursesViewController.swift
//  Studium
//
//  Created by Simone Scionti on 07/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit





class CoursesViewController: UIViewController, SWRevealViewControllerDelegate, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var teachingsTableView: UITableView!
    
   // da aggiungere un header view alla table per dare spazio

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.green
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        
        categoriesLabel.backgroundColor = UIColor.elementsLikeNavBarColor
        categoriesLabel.layer.cornerRadius = 5.0
        categoriesLabel.clipsToBounds = true
        self.view.backgroundColor = UIColor.primaryBackground
        
        teachingsTableView.delegate = self
        teachingsTableView.dataSource  = self
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        imageView.image = UIImage.init(named: "menu")
        let buttonView = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        buttonView.addSubview(imageView)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: buttonView)
        self.teachingsTableView.backgroundColor = UIColor.lightWhite
        self.view.backgroundColor = UIColor.lightWhite
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130//Menu sx/
            revealViewController().delegate = self
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            self.navigationItem.leftBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))))
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130//Menu sx/
            revealViewController().delegate = self
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            self.navigationItem.leftBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))))
        }
        if courseSharedDataSource.count == 0 {
            reloadSourceFromAPI();
            
        }
        else{
            teachingsTableView.reloadData()
        }
        
        
    }
    
    func reloadSourceFromAPI(){
        
       /* courseSharedDataSource.append(HomeTableSection.init(cdl: CDL.init(courseName: "Materie date", courseCode: 31), teachingArray:
            [Teaching.init(teachingName: "Matematica discreta(M-Z)", teachingCode: 1375, teacherName: "Andrea Scapellato", signedUp: true),Teaching.init(teachingName: "Fondamenti di informatica(M-Z)", teachingCode: 6723,teacherName: "Franco Barbanera", signedUp: false)], setExpanded: true))
        */
        
        courseSharedDataSource.append(HomeTableSection.init(cdl: CDL.init(courseName: "Materie da dare", courseCode: 27), teachingArray: [Teaching.init(teachingName: "Elementi di Analisi matematica 1", teachingCode: 8675, teacherName: "Ornella Naselli", signedUp: false),Teaching.init(teachingName: "Algebra 1", teachingCode: 8760, teacherName: "Andrea Scapellato", signedUp: false)], setExpanded: true))
        teachingsTableView.reloadData()
        
        courseSharedDataSource.append(HomeTableSection.init(cdl: CDL.init(courseName: "I miei corsi (default)", courseCode: 31), teachingArray:
            [Teaching.init(teachingName: "Matematica discreta(M-Z)", teachingCode: 1375, teacherName: "Andrea Scapellato", signedUp: true),Teaching.init(teachingName: "Fondamenti di informatica(M-Z)", teachingCode: 6723,teacherName: "Franco Barbanera", signedUp: false)], setExpanded: true))
        
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
        let cell = teachingsTableView.dequeueReusableCell(withIdentifier: "teachingCell") as! CoursesTableViewCell
        //modifico la cella e la mostro
        var dataElement : Teaching!
      
            dataElement = courseSharedDataSource[indexPath.section].teachings[indexPath.row]
        
        cell.teachingNameLabel.text = dataElement.name
        cell.teacherNameLabel.text = dataElement.teacherName
        cell.arrowImage.image = UIImage.init(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        cell.arrowImage.tintColor = UIColor.elementsLikeNavBarColor
        
        cell.arrowImage.transform = CGAffineTransform(rotationAngle: 3 * (.pi/2))
       
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueToTeachingController", sender: indexPath)
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
            
            
            let arrowImageView = UIImageView.init(frame: CGRect(x: 10, y: button.frame.height/2 - 7.5, width: 15, height: 15))
            arrowImageView.image = UIImage.init(named: "arrow")?.withRenderingMode(.alwaysTemplate);
            arrowImageView.tintColor = UIColor.elementsLikeNavBarColor
            button.addSubview(arrowImageView)
            
        
        
            button.setTitle(courseSharedDataSource[section].course.name, for: .normal)
            if courseSharedDataSource[section].expanded {
                rotateArrows180Degrees(button: button,animated: false)
            }
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            button.setTitleColor(UIColor.elementsLikeNavBarColor, for: .normal)
            button.backgroundColor = UIColor.lightSectionColor
            button.tag = section
            button.addTarget(self, action: #selector(self.removeOrExpandRows), for: .touchUpInside)
            
            
            
            return button
            
       
    }
    
    @objc func removeOrExpandRows(button : UIButton ){
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
                self.teachingsTableView.deleteRows(at: indices, with: .fade)
            }
            else{
                courseSharedDataSource[sect].expanded = true
                self.teachingsTableView.insertRows(at: indices, with: .fade)
            }
        
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
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return courseSharedDataSource.count
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
