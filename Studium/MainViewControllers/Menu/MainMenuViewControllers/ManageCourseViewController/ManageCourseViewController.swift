//
//  ManageCourseViewController.swift
//  Studium
//
//  Created by Simone Scionti on 14/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class ManageCourseViewController: UIViewController, SWRevealViewControllerDelegate, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var createCategoryView: UIView!
    
    @IBOutlet weak var createCategoryTextField: UITextField!
    @IBOutlet weak var createCategoryLabel: UILabel!
    //facciamo un for che setta tutte le section ad expanded, poi quando si rivà sul i miei corsi controller, si lasciano tutte expandend richiamando il reloaddata di quella tableview
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryHeaderView: UIView!
    var tabController : ManageCoursePageViewController!
    @IBOutlet weak var addCategoryButton: UIButton!
    @IBOutlet weak var manageCoursesTableView: UITableView!
   
    @IBOutlet weak var oscureView: UIView!
    func setAllExpanded(){
        for sect in courseSharedDataSource{
            sect.expanded = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCreateCategoryView()
        manageCoursesTableView.setEditing(true, animated: false)
       // self.view.backgroundColor = UIColor.green
        self.manageCoursesTableView.backgroundColor = UIColor.lightWhite
        self.view.backgroundColor = UIColor.lightWhite
        self.categoryHeaderView.backgroundColor = UIColor.elementsLikeNavBarColor
        self.categoryLabel.textColor = UIColor.lightWhite
        self.categoryHeaderView.layer.cornerRadius = 5.0
        self.categoryHeaderView.clipsToBounds = true
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
        
      /*  courseSharedDataSource.append(HomeTableSection.init(cdl: CDL.init(courseName: "Materie date", courseCode: 31), teachingArray:
            [Teaching.init(teachingName: "Matematica discreta(M-Z)", teachingCode: 1375, teacherName: "Andrea Scapellato", signedUp: true),Teaching.init(teachingName: "Fondamenti di informatica(M-Z)", teachingCode: 6723,teacherName: "Franco Barbanera", signedUp: false)], setExpanded: true))
        */
      /*
        courseSharedDataSource.append(HomeTableSection.init(cdl: CDL.init(courseName: "Materie da dare", courseCode: -1), teachingArray: [Teaching.init(teachingName: "Elementi di Analisi matematica 1", teachingCode: 8675, teacherName: "Ornella Naselli", signedUp: false),Teaching.init(teachingName: "Algebra 1", teachingCode: 8760, teacherName: "Andrea Scapellato", signedUp: false)], setExpanded: true))
        manageCoursesTableView.reloadData()
        
        courseSharedDataSource.append(HomeTableSection.init(cdl: CDL.init(courseName: "I miei corsi (default)", courseCode: -1), teachingArray:
            [Teaching.init(teachingName: "Matematica discreta(M-Z)", teachingCode: 1375, teacherName: "Andrea Scapellato", signedUp: true),Teaching.init(teachingName: "Fondamenti di informatica(M-Z)", teachingCode: 6723,teacherName: "Franco Barbanera", signedUp: false)], setExpanded: true))*/
        
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        return "Rimuovi iscrizione"
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = courseSharedDataSource[sourceIndexPath.section].teachings[sourceIndexPath.row]
        courseSharedDataSource[sourceIndexPath.section].teachings.remove(at: sourceIndexPath.row)
        courseSharedDataSource[destinationIndexPath.section].teachings.insert(item, at: destinationIndexPath.row)
        //tableView.reloadRows(at: [destinationIndexPath], with: .none)
       tableView.reloadData()
        
        
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
        cell.arrowImage.image =  nil
       // cell.arrowImage.tintColor = UIColor.elementsLikeNavBarColor
       // cell.arrowImage.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       //self.performSegue(withIdentifier: "segueToTeachingController", sender: indexPath)
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
        
        if manageCoursesTableView.isEditing && section != courseSharedDataSource.count-1 {
            let removeButton = UIButton.init(frame: CGRect(x: 10, y: 10, width: 25, height: 25))
           // removeButton.imageView?.image = UIImage.init(named: "menu")
            removeButton.setBackgroundImage(UIImage.init(named: "delete"), for: .normal)
            removeButton.tag = section
            removeButton.addTarget(self, action: #selector(removeSection), for: .touchUpInside)

            button.addSubview(removeButton)
        }
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
    
    /*func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == courseSharedDataSource.count-1{
            //senza cancella
            return .none
        }
        return UITableViewCell.EditingStyle.delete
    }*/
    func signOutCourse(indexPath : IndexPath){
        
        
        courseSharedDataSource[indexPath.section].teachings.remove(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Attenzione", message: "Sei sicuro di voler rimuovere l'iscrizione a questo corso?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Annulla", style: UIAlertAction.Style.destructive, handler: { action in
                self.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Conferma", style: .default, handler: { action in
                //courseSharedDataSource[indexPath.section].teachings.remove(at: indexPath.row)
                self.signOutCourse(indexPath: indexPath)
                self.manageCoursesTableView.reloadData()
                self.dismiss(animated: true, completion: nil)
                
            }))
            self.present(alert, animated: true, completion: nil)
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
    
    func setEditIconOnTabBar(){
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 2.5, width: 25.5, height: 25))
        imageView2.image = UIImage.init(named: "menu")
        let buttonView2 = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 27.5))
        buttonView2.addSubview(imageView2)
        self.tabController.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: buttonView2)
        self.tabController.navigationItem.rightBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.editClicked)))
        
    }
    
    @objc func removeSection(button : UIButton){
        let section = button.tag
        print("rimuovo section", section)
        let alert = UIAlertController(title: "Attenzione", message: "Sei sicuro di voler eliminare questa categoria? tutti i corsi al suo interno verranno spostati nella categoria di default.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Annulla", style: UIAlertAction.Style.destructive, handler: { action in
            self.dismiss(animated: true, completion: nil)
            }))
        alert.addAction(UIAlertAction(title: "Conferma", style: .default, handler: { action in
            var items = [Teaching]()
            for item in courseSharedDataSource[section].teachings{
                items.append(item)
                
            }
            courseSharedDataSource.remove(at: section)
            courseSharedDataSource[courseSharedDataSource.count-1].teachings.append(contentsOf: items)
            //self.manageCoursesTableView.reloadSections(IndexSet(arrayLiteral: section), with: UITableView.RowAnimation.left)
            self.manageCoursesTableView.reloadData()
            
            self.dismiss(animated: true, completion: nil)
            
            }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @objc func editClicked(){
        if !self.manageCoursesTableView.isEditing {
            self.manageCoursesTableView.setEditing(true, animated: true)
            self.manageCoursesTableView.reloadSections(IndexSet(integersIn: 0...courseSharedDataSource.count-1), with: UITableView.RowAnimation.fade)
        }
        else{
            self.manageCoursesTableView.setEditing(false, animated: true)
            self.manageCoursesTableView.reloadSections(IndexSet(integersIn: 0...courseSharedDataSource.count-1), with: UITableView.RowAnimation.fade)
        }
       // self.manageCoursesTableView.isEditing = !self.manageCoursesTableView.isEditing
    }
    
    
    @objc func closeCreateCategory(){
        closeCreateCategoryViewAnimated()
    }
    
    @objc func createCategoryWithName(button : UIButton){
        print("creo")
        guard let t =  createCategoryTextField.text else{ return }
        guard t != "" else{ return }
        let newCategory = HomeTableSection.init(cdl: CDL.init(courseName: t, courseCode: "-1", courseId: -1, parent: ""), teachingArray: [Teaching](), setExpanded: true)
        courseSharedDataSource.insert(newCategory, at: 0)
        closeCreateCategoryViewAnimated()
        manageCoursesTableView.reloadData()
        manageCoursesTableView.setEditing(true, animated: true)
    }
    
    
    
    @IBAction func addCategoryClicked(_ sender: Any) {
       // self.navigationItem.rightBarButtonItem?.customView?.isUserInteractionEnabled = false
        openCreateCategoryViewAnimated()
    }
    
    
    func disableMenuGesture(){
        
    }
    func enableMenuGesture(){
        
    }
    func setUpCreateCategoryView(){
        oscureView.backgroundColor = UIColor.primaryBackground
        self.createCategoryView.backgroundColor = UIColor.createCategoryViewColor
        self.createCategoryView.layer.borderColor = UIColor.secondaryBackground.cgColor
        self.createCategoryView.layer.borderWidth = 1.0
        self.createCategoryView.layer.cornerRadius = 5.0
        createCategoryLabel.textColor = UIColor.lightWhite
        createCategoryLabel.font = UIFont.boldSystemFont(ofSize: 15)
        createCategoryLabel.textAlignment = .center
        createCategoryView.isHidden = true
        oscureView.isHidden = true
        createCategoryTextField.backgroundColor = UIColor.lightWhite
        let createCategoryButton = UIButton(frame: CGRect(x: createCategoryView.frame.size.width/2 - 5, y: 130 , width: 120, height: 50))
        let cancelButton = UIButton(frame: CGRect(x: createCategoryView.frame.size.width/2 - 115, y: 130, width: 120, height: 50))
        createCategoryButton.backgroundColor = UIColor.lightWhite
        cancelButton.backgroundColor = UIColor.lightWhite
        createCategoryButton.setTitleColor(UIColor.textBlueColor, for: .normal)
        createCategoryButton.setTitle("Crea", for: .normal)
        cancelButton.setTitle("Annulla", for: .normal)
        cancelButton.setTitleColor(UIColor.textRedColor, for: .normal)
        cancelButton.addTarget(self, action: #selector(closeCreateCategory), for: .touchUpInside)
        createCategoryButton.addTarget(self, action: #selector(createCategoryWithName), for: .touchUpInside)
        createCategoryButton.layer.cornerRadius = 5.0
        cancelButton.layer.cornerRadius = 5.0
        cancelButton.layer.addBorder(edge: .right, color: #colorLiteral(red: 0.9961728454, green: 0.9902502894, blue: 1, alpha: 1), thickness: 0.5)
        roundRightRadius(radius: 5.0, view: createCategoryButton)
        roundLeftRadius(radius: 5.0, view: cancelButton)
        
        createCategoryView.addSubview(createCategoryButton)
        createCategoryView.addSubview(cancelButton)
    }
    func closeCreateCategoryViewAnimated(){
        UIView.animate(withDuration: 0.4, animations: {
            //self.createCategoryView.frame = CGRect(x: self.addCategoryButton.frame.origin.x - 150, y: self.addCategoryButton.frame.origin.y - 80 , width: self.createCategoryView.frame.size.width, height: self.createCategoryView.frame.size.height)
            self.createCategoryView.center = CGPoint(x: self.addCategoryButton.center.x + 10, y: self.addCategoryButton.center.y + 5)
          //  self.createCategoryView.center = self.addCategoryButton.center
              self.createCategoryView.transform = CGAffineTransform(scaleX: 0.15, y: 0.15)
            self.oscureView.alpha = 0.6
            
        }) { (f) in
            UIView.animate(withDuration: 0.2, animations: {
                 self.createCategoryView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                self.oscureView.alpha = 0.0
            }, completion: { (f) in
                self.createCategoryView.isHidden = true
                self.oscureView.isHidden = true
                self.manageCoursesTableView.isUserInteractionEnabled = true
                self.createCategoryTextField.resignFirstResponder()
                self.tabController.navigationItem.rightBarButtonItem?.customView?.isUserInteractionEnabled = true
                self.createCategoryTextField.text =  nil
               // self.createCategoryView.center =  initialCenter
                
            })
            
        }
        
        
        
    }
    
    
    func openCreateCategoryViewAnimated(){
        self.tabController.navigationItem.rightBarButtonItem?.customView?.isUserInteractionEnabled = false
        //let buttonFrame  = addCategoryButton.frame
        oscureView.alpha = 0.0
        //let newFrame = CGRect(x: 0, y: 0, width: self.view.frame.size.width * 0.9, height: 180)
        createCategoryLabel.alpha = 0.0
        oscureView.isHidden = false
        createCategoryView.isHidden = false
        let initialCenter =  createCategoryView.center
        self.createCategoryView.center = CGPoint(x: self.addCategoryButton.center.x + 10, y: self.addCategoryButton.center.y + 5)
        //self.addCategoryButton.center
        
       
       // createCategoryView.frame = CGRect(x: addCategoryButton.frame.origin.x - 150, y: addCategoryButton.frame.origin.y - 80 , width: createCategoryView.frame.size.width, height: createCategoryView.frame.size.height)
      
       // createCategoryView.isHidden = false
        
        
        self.createCategoryView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        self.createCategoryView.alpha = 0.0
        UIView.animate(withDuration: 0.2, animations: {
            self.oscureView.alpha = 0.6
            self.createCategoryView.transform = CGAffineTransform(scaleX: 0.15, y: 0.15)
            self.createCategoryView.alpha = 0.8
        }) { (flag) in
            UIView.animate(withDuration: 0.4, animations: {
                self.oscureView.alpha = 0.9
                self.createCategoryView.transform = .identity
                //self.createCategoryView.center = CGPoint(x: self.view.center.x , y: self.view.center.y - 150 )
                self.createCategoryView.center =  initialCenter
                //porta a 1 gli alpha degli elementi della view
                self.createCategoryLabel.alpha = 1.0
                self.createCategoryView.alpha = 1.0
                
            }) { (f) in
                self.manageCoursesTableView.isUserInteractionEnabled = false
                self.createCategoryTextField.becomeFirstResponder()
                
            }
        }
        
    }
    
    
    func roundLeftRadius(radius:CGFloat, view : UIView) {
        self.roundCorners(corners: [UIRectCorner.topLeft, UIRectCorner.bottomLeft], radius:radius, view: view)
    }
    
    func roundRightRadius(radius:CGFloat, view : UIView) {
        self.roundCorners(corners: [UIRectCorner.topRight, UIRectCorner.bottomRight], radius:radius, view: view)
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
    

}

