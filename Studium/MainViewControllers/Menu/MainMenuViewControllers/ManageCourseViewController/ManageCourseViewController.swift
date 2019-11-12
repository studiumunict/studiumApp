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
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createCategoryButton: UIButton!
    
    //facciamo un for che setta tutte le section ad expanded, poi quando si rivà sul i miei corsi controller, si lasciano tutte expandend richiamando il reloaddata di quella tableview
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryHeaderView: UIView!
    var tabController : ManageCoursePageViewController!
    @IBOutlet weak var addCategoryButton: UIButton!
    @IBOutlet weak var manageCoursesTableView: UITableView!
   
    @IBOutlet weak var oscureView: UIView!
    
    var sharedSource : SharedSource!
    func setAllExpanded(){
        for sect in sharedSource.courseSharedDataSource{
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
        sharedSource = SharedSource.getUniqueIstance()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130//Menu sx/
            revealViewController().delegate = self
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        if sharedSource.courseSharedDataSource.count == 1 {
            sharedSource.reloadSourceFromAPI { (flag) in
                self.manageCoursesTableView.reloadData()
            }
            
        }
        else{
            self.setAllExpanded()
            self.manageCoursesTableView.reloadData()
            
        }
    }
    
    
  
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        return "Rimuovi iscrizione"
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section == destinationIndexPath.section {return}
        let courseCode = sharedSource.courseSharedDataSource[sourceIndexPath.section].teachings[sourceIndexPath.row].code
        let newCatCode = sharedSource.courseSharedDataSource[destinationIndexPath.section].course.code
    
        let api = BackendAPI.getUniqueIstance()
        
        api.moveCourse(codCourse: courseCode!, newCat: newCatCode!) { (JSONResponse) in
            print(JSONResponse ?? "null")
            self.sharedSource.reloadSourceFromAPI { (flag) in
                tableView.reloadData()
            }
        }
        /*let item = sharedSource.courseSharedDataSource[sourceIndexPath.section].teachings[sourceIndexPath.row]
        sharedSource.courseSharedDataSource[sourceIndexPath.section].teachings.remove(at: sourceIndexPath.row)
        sharedSource.courseSharedDataSource[destinationIndexPath.section].teachings.insert(item, at: destinationIndexPath.row)
        //tableView.reloadRows(at: [destinationIndexPath], with: .none)
        
       tableView.reloadData()*/
        
        
        
        
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
        let cell = manageCoursesTableView.dequeueReusableCell(withIdentifier: "teachingCell") as! CoursesTableViewCell
        //modifico la cella e la mostro
        var dataElement : Teaching!
        dataElement = sharedSource.courseSharedDataSource[indexPath.section].teachings[indexPath.row]
        
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
            controller.teachingDataSource = sharedSource.courseSharedDataSource[index.section].teachings[index.row]
        }
    }
    
    
   
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
       
        
        
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 45))
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        
        if manageCoursesTableView.isEditing && section != sharedSource.courseSharedDataSource.count-1 {
            let removeButton = UIButton.init(frame: CGRect(x: 10, y: 10, width: 25, height: 25))
           // removeButton.imageView?.image = UIImage.init(named: "menu")
            removeButton.setBackgroundImage(UIImage.init(named: "delete"), for: .normal)
            removeButton.tag = section
            removeButton.addTarget(self, action: #selector(removeSection), for: .touchUpInside)

            button.addSubview(removeButton)
        }
        button.setTitle(sharedSource.courseSharedDataSource[section].course.name, for: .normal)
        if sharedSource.courseSharedDataSource[section].expanded {
            let SSAnimator = CoreSSAnimation.getUniqueIstance()
            SSAnimator.rotate180Degrees(view: button, animated: false)
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
        let code = sharedSource.courseSharedDataSource[indexPath.section].teachings[indexPath.row].code
        let api  = BackendAPI.getUniqueIstance()
        api.deleteCourse(codCourse: code!) { (JSONResponse) in
            print(JSONResponse ?? "null")
        }
        sharedSource.courseSharedDataSource[indexPath.section].teachings.remove(at: indexPath.row)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sharedSource.courseSharedDataSource.count
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
            /*var items = [Teaching]()
            for item in self.sharedSource.courseSharedDataSource[section].teachings{
                items.append(item)
                
            }
            self.sharedSource.courseSharedDataSource.remove(at: section)
            self.sharedSource.courseSharedDataSource[self.sharedSource.courseSharedDataSource.count-1].teachings.append(contentsOf: items)
            //self.manageCoursesTableView.reloadSections(IndexSet(arrayLiteral: section), with: UITableView.RowAnimation.left)
            self.manageCoursesTableView.reloadData()*/
            let api = BackendAPI.getUniqueIstance()
            api.deleteCategory(idCat: self.sharedSource.courseSharedDataSource[section].course.code) { (JSONResponse) in
                print(JSONResponse ?? "null")
                self.sharedSource.reloadSourceFromAPI { (flag) in
                     self.manageCoursesTableView.reloadData()
                }
               
            }
            
            self.dismiss(animated: true, completion: nil)
            
            }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @objc func editClicked(){
        if !self.manageCoursesTableView.isEditing {
            self.manageCoursesTableView.setEditing(true, animated: true)
            self.manageCoursesTableView.reloadSections(IndexSet(integersIn: 0...sharedSource.courseSharedDataSource.count-1), with: UITableView.RowAnimation.fade)
        }
        else{
            self.manageCoursesTableView.setEditing(false, animated: true)
            self.manageCoursesTableView.reloadSections(IndexSet(integersIn: 0...sharedSource.courseSharedDataSource.count-1), with: UITableView.RowAnimation.fade)
        }
       // self.manageCoursesTableView.isEditing = !self.manageCoursesTableView.isEditing
    }
    
    
    @objc func closeCreateCategory(){
        closeCreateCategoryViewAnimated()
    }
    
    @objc func createCategoryWithName(button : UIButton){
        print("creo categoria")
        guard let t =  createCategoryTextField.text else{ return }
        guard t != "" else{ return }
        let api = BackendAPI.getUniqueIstance()
        api.createCategory(catTitle: t) { (JSONResponse) in
            print(JSONResponse ?? "null")
            self.sharedSource.reloadSourceFromAPI { (flag) in
                self.manageCoursesTableView.reloadData()
            }
            self.manageCoursesTableView.setEditing(true, animated: true)
            self.closeCreateCategoryViewAnimated()
        }
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
        createCategoryButton.backgroundColor = UIColor.lightWhite
        cancelButton.backgroundColor = UIColor.lightWhite
        createCategoryButton.setTitleColor(UIColor.textBlueColor, for: .normal)
        createCategoryButton.setTitle("Conferma", for: .normal)
        cancelButton.setTitle("Annulla", for: .normal)
        cancelButton.setTitleColor(UIColor.textRedColor, for: .normal)
        cancelButton.addTarget(self, action: #selector(closeCreateCategory), for: .touchUpInside)
        createCategoryButton.addTarget(self, action: #selector(createCategoryWithName), for: .touchUpInside)
        createCategoryButton.layer.cornerRadius = 5.0
        cancelButton.layer.cornerRadius = 5.0
        cancelButton.titleLabel?.font = UIFont(name: "System", size: 9)
        createCategoryButton.titleLabel?.font = UIFont(name: "System", size: 9)
        cancelButton.layer.addBorder(edge: .right, color: #colorLiteral(red: 0.9961728454, green: 0.9902502894, blue: 1, alpha: 1), thickness: 0.5)
        roundLeftRadius(radius: 5.0, view: cancelButton)
        roundRightRadius(radius: 5.0, view: createCategoryButton)
        createCategoryView.addSubview(createCategoryButton)
        createCategoryView.addSubview(cancelButton)
    }
    func closeCreateCategoryViewAnimated(){
        let SSAnimator = CoreSSAnimation.getUniqueIstance()
        SSAnimator.collapseViewInSourceView(viewToCollapse: self.createCategoryView, elementsInsideView: nil, sourceView: self.addCategoryButton, oscureView: self.oscureView) { (flag) in
            self.manageCoursesTableView.isUserInteractionEnabled = true
            self.createCategoryTextField.resignFirstResponder()
            self.tabController.navigationItem.rightBarButtonItem?.customView?.isUserInteractionEnabled = true
            self.createCategoryTextField.text =  nil
            //self.view.endEditing(true)
        }
    }
    
    
    func openCreateCategoryViewAnimated(){
        self.tabController.navigationItem.rightBarButtonItem?.customView?.isUserInteractionEnabled = false
        let SSAnimator = CoreSSAnimation.getUniqueIstance()
        var subviews = [UIView]()
        subviews.append(self.createCategoryLabel)
        SSAnimator.expandViewFromSourceView(viewToOpen: self.createCategoryView, elementsInsideView: subviews, sourceView: self.addCategoryButton, oscureView: self.oscureView) { (flag) in
            self.manageCoursesTableView.isUserInteractionEnabled = false
            self.createCategoryTextField.becomeFirstResponder()
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

