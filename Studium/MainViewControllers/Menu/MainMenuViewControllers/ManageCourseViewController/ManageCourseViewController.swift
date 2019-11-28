//
//  ManageCourseViewController.swift
//  Studium
//
//  Created by Simone Scionti on 14/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class ManageCourseViewController: UIViewController, SWRevealViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, SharedSourceObserverDelegate {
   
   

    @IBOutlet weak var createCategoryView: UIView!
    @IBOutlet weak var createCategoryTextField: UITextField!
    @IBOutlet weak var createCategoryLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createCategoryButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryHeaderView: UIView!
    var tabController : ManageCoursePageViewController!
    @IBOutlet weak var addCategoryButton: UIButton!
    @IBOutlet weak var manageCoursesTableView: UITableView!
    @IBOutlet weak var oscureView: UIView!
    var deleteConfirmView :UIView!
    var sharedSource : SharedCoursesSource!
    func setAllExpanded(){
        for sect in sharedSource.dataSource{
            sect.expanded = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCreateCategoryView()
        manageCoursesTableView.setEditing(true, animated: false)
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
        sharedSource = SharedCoursesSource.getUniqueIstance()
        sharedSource.addObserverDelegate(observer: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130//Menu sx/
            revealViewController().delegate = self
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        if sharedSource.isEmpty() {
            self.manageCoursesTableView.startWaitingData()
            sharedSource.reloadSourceFromAPI(fromController: self) { (flag) in
                self.manageCoursesTableView.stopWaitingData()
                self.manageCoursesTableView.reloadData()
            }
        }
        else{
            self.setAllExpanded()
            self.manageCoursesTableView.reloadData()
        }
    }
    
    func dataSourceUpdated(byController: UIViewController?) { //observer function
           if let controller = byController{
               if controller != self {self.manageCoursesTableView.reloadData()}
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
        let courseCode = sharedSource.dataSource[sourceIndexPath.section].teachings[sourceIndexPath.row].code
        let newCatCode = sharedSource.dataSource[destinationIndexPath.section].course.code
    
        let api = BackendAPI.getUniqueIstance(fromController: self)
        
        api.moveCourse(codCourse: courseCode!, newCat: newCatCode!) { (JSONResponse) in
            print(JSONResponse ?? "null")
            self.sharedSource.reloadSourceFromAPI(fromController: self) { (flag) in
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sharedSource.dataSource[section].expanded {
            return sharedSource.dataSource[section].teachings.count
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
        var dataElement : Teaching!
        //TODO:Error next line nil
        dataElement = sharedSource.dataSource[indexPath.section].teachings[indexPath.row]
        cell.teachingNameLabel.text = dataElement.name
        cell.teacherNameLabel.text = dataElement.teacherName
        cell.arrowImage.image =  nil
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let  controller = segue.destination as? TeachingViewController{
            let index = sender as! IndexPath
            controller.teachingDataSource = sharedSource.dataSource[index.section].teachings[index.row]
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 45))
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        if manageCoursesTableView.isEditing && section != sharedSource.dataSource.count-1 {
            let removeButton = UIButton.init(frame: CGRect(x: 10, y: 10, width: 25, height: 25))
            removeButton.setBackgroundImage(UIImage.init(named: "removex"), for: .normal)
            removeButton.tag = section
            removeButton.addTarget(self, action: #selector(showRemoveSectionConfirmView), for: .touchUpInside)
            button.addSubview(removeButton)
        }
        button.setTitle(sharedSource.dataSource[section].course.name, for: .normal)
        if sharedSource.dataSource[section].expanded {
            let SSAnimator = CoreSSAnimation.getUniqueIstance()
            SSAnimator.rotate180Degrees(view: button, animated: false)
        }
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.elementsLikeNavBarColor, for: .normal)
        button.backgroundColor = UIColor.lightSectionColor
        button.tag = section
        return button
    }
    
    func signOutCourse(indexPath : IndexPath, completion: @escaping (Bool)->Void){
        //TODO:next line can be nil
        print("Signout")
        let code = sharedSource.dataSource[indexPath.section].teachings[indexPath.row].code
        let api  = BackendAPI.getUniqueIstance(fromController: self)
        api.deleteCourse(codCourse: code!) { (JSONResponse) in
            guard JSONResponse != nil else{completion(false);return}
            self.sharedSource.reloadSourceFromAPI(fromController: self) { (flag) in
                guard flag else {completion(false); return}
                self.manageCoursesTableView.reloadData()
                completion(true)
            }
        }
    }
    
    
    @objc private func unsuscribe(sender: UIButton){
        print("Unsuscribe")
        var view = sender.superview!
        let indexPath = sender.accessibilityElements?[1] as! IndexPath
        let CF = ConfirmView.getUniqueIstance()
        CF.startWaiting(confirmView: &view)
        self.signOutCourse(indexPath: indexPath) { (success) in
            CF.stopWaiting(confirmView: &view)
            if success {
                let SSAnimator = CoreSSAnimation.getUniqueIstance()
                SSAnimator.collapseViewInSourceFrame(sourceFrame: self.categoryHeaderView.frame, viewToCollapse: view, oscureView: self.oscureView, elementsInsideView: nil) { (flag) in
                        view.removeFromSuperview()
                }
            }
        }
       
    }
    @objc private func closeUnsuscribeView(sender: UIButton){
        let view = sender.superview!
        let indexPath = sender.accessibilityElements?[1] as! IndexPath
        let frameTb = self.manageCoursesTableView.rectForRow(at: indexPath)
        let frame = self.manageCoursesTableView.convert(frameTb, to: self.view)
        let SSAnimator = CoreSSAnimation.getUniqueIstance()
        SSAnimator.collapseViewInSourceFrame(sourceFrame: frame, viewToCollapse: view, oscureView: self.oscureView, elementsInsideView: nil) { (flag) in
            view.removeFromSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let CV = ConfirmView.getUniqueIstance()
            let titleLabel = CV.getTitleLabel(text: "Attenzione")
            let descLabel = CV.getDescriptionLabel(text: "Sei sicuro di voler rimuovere l'iscrizione a questo corso?")
            descLabel.adjustsFontSizeToFitWidth = true
            descLabel.minimumScaleFactor = 0.7
            let cancelButton = CV.getButton(position: .left, dataToAttach: indexPath, title: "Annulla", selector: #selector(closeUnsuscribeView(sender:)), target: self)
            let confirmButton = CV.getButton(position: .right, dataToAttach: indexPath, title: "Conferma", selector: #selector(unsuscribe(sender:)), target: self)
            let view = CV.getView(titleLabel: titleLabel, descLabel: descLabel, buttons: [cancelButton,confirmButton], dataToAttach: nil)
            view.backgroundColor = UIColor.createCategoryViewColor
            self.view.addSubview(view)
            let SSAnimator = CoreSSAnimation.getUniqueIstance()
            let frameTb = self.manageCoursesTableView.rectForRow(at: indexPath)
            let frame = self.manageCoursesTableView.convert(frameTb, to: self.view)
            SSAnimator.expandViewFromSourceFrame(sourceFrame: frame, viewToExpand: view, elementsInsideView: nil, oscureView: self.oscureView) { (flag) in }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sharedSource.dataSource.count
    }
    
    @objc private func removeSection(button : UIButton){
        let section = button.accessibilityElements?[1] as! Int
        let api = BackendAPI.getUniqueIstance(fromController: self)
        //TODO: next line can be nil
        api.deleteCategory(idCat: self.sharedSource.dataSource[section].course.code) { (JSONResponse) in
            self.sharedSource.reloadSourceFromAPI(fromController: self) { (flag) in
                self.manageCoursesTableView.reloadData()
                let SSAnimator = CoreSSAnimation.getUniqueIstance()
                SSAnimator.collapseViewInSourceFrame(sourceFrame: self.categoryHeaderView.frame, viewToCollapse: button.superview!, oscureView: self.oscureView, elementsInsideView: nil) { (flag) in
                }
            }
        }
    }
    
    @objc func showRemoveSectionConfirmView(button : UIButton){
        let section = button.tag
        let CV = ConfirmView.getUniqueIstance()
        let titleLabel = CV.getTitleLabel(text: "Sei sicuro di voler eliminare questa categoria?")
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.7
        let descLabel = CV.getDescriptionLabel(text: "I corsi all'interno saranno spostati in Default")
        descLabel.adjustsFontSizeToFitWidth = true
        descLabel.minimumScaleFactor = 0.7
        let cancelButton = CV.getButton(position: .left, dataToAttach: section, title: "Annulla", selector: #selector(closeRemoveSectionConfirmView), target: self)
        let confirmButton = CV.getButton(position: .right, dataToAttach: section, title: "Conferma", selector: #selector(removeSection(button:)), target: self)
        let view = CV.getView(titleLabel: titleLabel, descLabel: descLabel, buttons: [cancelButton,confirmButton], dataToAttach: nil)
        view.backgroundColor = UIColor.createCategoryViewColor
        self.view.addSubview(view)
        
        let SSAnimator = CoreSSAnimation.getUniqueIstance()
        let frameTb = self.manageCoursesTableView.rect(forSection: section)
        let frame = self.manageCoursesTableView.convert(frameTb, to: self.view)
        SSAnimator.expandViewFromSourceFrame(sourceFrame: frame, viewToExpand: view, elementsInsideView: nil, oscureView: self.oscureView) { (flag) in }
    }
    @objc private func closeRemoveSectionConfirmView(sender : UIButton){
        let section = sender.accessibilityElements?[1] as! Int
        let frameTb = self.manageCoursesTableView.rect(forSection: section)
        let frame = self.manageCoursesTableView.convert(frameTb, to: self.view)
        let SSAnimator = CoreSSAnimation.getUniqueIstance()
        //let frame = self.categoryHeaderView.frame
        let view = sender.superview!
        SSAnimator.collapseViewInSourceFrame(sourceFrame: frame, viewToCollapse: view, oscureView: self.oscureView, elementsInsideView: nil) { (flag) in
            view.removeFromSuperview()
        }
    }
    
    @objc func closeCreateCategory(){
        closeCreateCategoryViewAnimated()
    }
    
    @objc func createCategoryWithName(button : UIButton){
        print("creo categoria")
        guard let t =  createCategoryTextField.text else{ return }
        guard t != "" else{ return }
        let api = BackendAPI.getUniqueIstance(fromController: self)
        api.createCategory(catTitle: t) { (JSONResponse) in
            print(JSONResponse ?? "null")
            self.sharedSource.reloadSourceFromAPI(fromController: self) { (flag) in
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

