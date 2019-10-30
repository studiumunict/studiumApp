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
    
    var sharedSource : SharedSource!
   // da aggiungere un header view alla table per dare spazio

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.green
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        CourseFrontController = self.navigationController
        let _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (t) in
            self.revealViewController().revealToggle(self)
        }
        
        
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
        sharedSource = SharedSource.getUniqueIstance()
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
        if sharedSource.courseSharedDataSource.count == 1 {
            sharedSource.reloadSourceFromAPI { (flag) in
                self.teachingsTableView.reloadData()
            };
            
        }
        else{
            teachingsTableView.reloadData()
        }
        
        
    }
    
   
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sharedSource.courseSharedDataSource[section].expanded {
              return sharedSource.courseSharedDataSource[section].teachings.count
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
      
            dataElement = sharedSource.courseSharedDataSource[indexPath.section].teachings[indexPath.row]
        
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
                controller.teachingDataSource = sharedSource.courseSharedDataSource[index.section].teachings[index.row]
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
            let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 45))
            button.layer.cornerRadius = 5.0
            button.clipsToBounds = true
            
            if sharedSource.courseSharedDataSource[section].teachings.count > 0 {
                let arrowImageView = UIImageView.init(frame: CGRect(x: 10, y: button.frame.height/2 - 7.5, width: 15, height: 15))
                arrowImageView.image = UIImage.init(named: "arrow")?.withRenderingMode(.alwaysTemplate);
                arrowImageView.tintColor = UIColor.elementsLikeNavBarColor
                button.addSubview(arrowImageView)
                if sharedSource.courseSharedDataSource[section].expanded {
                    rotateArrows180Degrees(button: button,animated: false)
                }
                button.addTarget(self, action: #selector(self.removeOrExpandRows), for: .touchUpInside)
            }
        
            button.setTitle(sharedSource.courseSharedDataSource[section].course.name, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            button.setTitleColor(UIColor.elementsLikeNavBarColor, for: .normal)
            button.backgroundColor = UIColor.lightSectionColor
            button.tag = section
        
            return button
    }
    
    @objc func removeOrExpandRows(button : UIButton ){
        rotateArrows180Degrees(button: button,animated: true)
        let sect = button.tag
        var indices = [IndexPath]()
        var row = 0;
        
            for _ in sharedSource.courseSharedDataSource[sect].teachings{ // salva tutti gli indici
                indices.append(IndexPath.init(row: row, section: sect))
                row += 1
            }
            
            if sharedSource.courseSharedDataSource[sect].expanded == true{ //RIMUOVE LE RIGHE
                sharedSource.courseSharedDataSource[sect].expanded = false
                self.teachingsTableView.deleteRows(at: indices, with: .fade)
            }
            else{
                sharedSource.courseSharedDataSource[sect].expanded = true
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
        return sharedSource.courseSharedDataSource.count
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
