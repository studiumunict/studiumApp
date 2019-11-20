//
//  DocumentsViewController.swift
//  Studium
//
//  Created by Simone Scionti on 23/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit


class DocumentsViewController: UIViewController, SWRevealViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIDocumentInteractionControllerDelegate {
    @IBOutlet var errorMessageLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var descrizioneLabel: UILabel!
    @IBOutlet var headerView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var addNewFolderButton: UIButton!
    @IBOutlet var selectButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var selectedActionButton: UIButton!
    var actionsView: UIView!
    @IBOutlet var oscureView : UIView!
    @IBOutlet weak var createFolderLabel: UILabel!
    @IBOutlet weak var createFolderTextField: UITextField!
    @IBOutlet weak var createFolderCancelButton: UIButton!
    @IBOutlet weak var createFolderConfirmButton: UIButton!
    @IBOutlet weak var createFolderView: UIView!
    var selectionList = [Doc]() //Lista contenente gli elementi della selezione multipla
    internal var fs: TempDocSystem!
    private var emptyContent :Bool! = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightWhite
        self.view.layer.borderColor = UIColor.primaryBackground.cgColor
        self.view.layer.borderWidth = 0.5
        self.createFolderView.isHidden = true
        self.oscureView.isHidden = true
        setRevealViewControllerParameters()
        collectionView.dataSource = self
        collectionView.delegate = self
        setUpOscureView()
        setUpCreateFolderView()
        fillDocSystem()
        if fs.root.childs.count == 0 {
            setEmptyContentLayout()
        } else {
            setFullContentLayout()
        }
        reloadCollectionView()
    }
    internal func fillDocSystem(){ //fileSystemPermanente
        fs = PermanentDocSystem.getUniqueIstance()
    }
    override func viewDidAppear(_ animated: Bool) {
        setRevealViewControllerParameters()
    }
    
    func setErrorLabelText() {
        errorMessageLabel.text = "Non ci sono documenti preferiti salvati. Puoi aggiungere documenti alla sezione preferiti dalla pagina di un qualsiasi corso di tuo interesse."
    }
    
    func hideElementsOfView() {
        descrizioneLabel.isHidden = true
        headerView.isHidden = true
        collectionView.isHidden = true
        selectedActionButton.isHidden = true
    }
    func showElementsOfView(){
        descrizioneLabel.isHidden = false
        headerView.isHidden = false
        collectionView.isHidden = false
        selectedActionButton.isHidden = false
    }
    
    func showError() {
        setErrorLabelText()
        errorMessageLabel.isHidden = false
        errorMessageLabel.layer.zPosition = 2
    }
    func hideError(){
        errorMessageLabel.isHidden = true
    }

    func setHeaderViewLayout(){
        headerView.backgroundColor = UIColor.lightWhite
        headerView.layer.borderWidth = 0.5
        headerView.layer.borderColor = UIColor.primaryBackground.cgColor
        titleLabel.text = fs.currentFolder.title
    }
    func setSelectedActionButtonLayout(){
        selectedActionButton.clipsToBounds = true
        selectedActionButton.layer.cornerRadius = 7.0
        selectedActionButton.isHidden = true
    }
    
    func setEmptyContentLayout(){
        setErrorLabelText()
        showError()
        hideElementsOfView()
        emptyContent = true
    }
    func setFullContentLayout(){
        hideError()
        showElementsOfView()
        setHeaderViewLayout()
        reloadDescriptionLabel()
        setSelectedActionButtonLayout()
        emptyContent = false
    }
    
    func checkContent(){
        if emptyContent && fs.root.childs.count > 0{
            print("Setto full content")
            setFullContentLayout()
        }
        else if !emptyContent && fs.root.childs.count == 0{
            print("Setto Empty Content")
            setEmptyContentLayout()
        }
    }
    
    func loadDocumentsList(){
        //questa funzione tira fuori tutta la directory dal coredata.
        //essa non viene utilizzata in DocumentsPageController.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fs.currentFolder.childs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "docsCell", for: indexPath) as! DocumentsCollectionViewCell
        let cellType = fs.currentFolder.childs[indexPath.item].type
        if cellType == "file" {
            cell.update(image: "showcase", title: fs.currentFolder.childs[indexPath.item].title!, description: "")
        }
        else{
            if fs.currentFolder.childs[indexPath.item].childs.count == 1 {
                cell.update(image: "folder_1", title: fs.currentFolder.childs[indexPath.item].title!, description: "1 elemento")
            } else {
                cell.update(image: "folder_1", title: fs.currentFolder.childs[indexPath.item].title!, description: String(fs.currentFolder.childs[indexPath.item].childs.count) + " elementi")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.allowsMultipleSelection {
            selectionList.append(fs.currentFolder.childs[indexPath.item])
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.backgroundColor = UIColor.lightSectionColor
            selectedActionButton.isEnabled = true
        }
        else { //abbiamo cliccato una folder
            if fs.currentFolder.childs[indexPath.item].type == "folder" {
                backButton.isEnabled = true
                titleLabel.text = fs.currentFolder.childs[indexPath.item].title
                fs.goToChild(childDoc: fs.currentFolder.childs[indexPath.item])
                reloadCollectionView()
            }
            else { //Visualizza il file
                print("file selezionato:: \((fs.currentFolder.childs[indexPath.item].path)!)")
                openDocument(fs.currentFolder.childs[indexPath.item].path)
            }
        }
    }
    
    func setBackButtonState(){
        if fs.currentFolder.parent == nil{
            self.backButton.isEnabled = false
        }
        else {
            self.backButton.isEnabled = true
        }
    }
    func reloadTitleLabel(){
        self.titleLabel.text = fs.currentFolder.title
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadCollectionView()
    }
    func reloadCollectionView(){
        print("CheckContent")
        self.checkContent()
        self.setBackButtonState()
        self.collectionView.reloadData()
        self.reloadTitleLabel()
        self.reloadDescriptionLabel()
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.backgroundColor = cell.isSelected ? UIColor.lightSectionColor : UIColor.clear
    }
    
    func getSelectedCellIndex(cellTitle: String) -> Int {
        var i: Int = 0
        for doc in selectionList {
            if cellTitle == doc.title { return i }
            i += 1
        }
        return -1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard collectionView.allowsMultipleSelection else { return }
        let cell = collectionView.cellForItem(at: indexPath) as! DocumentsCollectionViewCell
        let index = getSelectedCellIndex(cellTitle: cell.titleDocLabel.text!)
        cell.backgroundColor = UIColor.clear
        if index < selectionList.count && index > -1 {
             selectionList.remove(at: index)
        }
        if selectionList.count == 0 { selectedActionButton.isEnabled = false }
    }
    
    //Margini
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 5, bottom: 5, right: 5)
    }
    
    // Dimensioni della cella
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width - 30) / 3, height: 113)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    internal func reloadDescriptionLabel() {
        if fs.currentFolder.childs.count == 1 {
            descrizioneLabel.text = "1 elemento"
        } else {
            descrizioneLabel.text = String(fs.currentFolder.childs.count) + " elementi"
        }
    }
    
    @IBAction func backButtonBarClicked(_ sender: UIButton) {
        fs.goToParent()
        reloadCollectionView()
    }
    
    @IBAction func addNewFolderClicked(_ sender: UIButton) {
        let SSAnimator = CoreSSAnimation.getUniqueIstance()
        self.createFolderView.translatesAutoresizingMaskIntoConstraints = false
        //self.createFolderView
        SSAnimator.expandViewFromSourceView(viewToOpen: self.createFolderView, elementsInsideView: nil, sourceView: self.addNewFolderButton, oscureView: self.oscureView) { (flag) in
            self.createFolderTextField.becomeFirstResponder()
        }
    }
    private func hideSelectedActionButton(){
        let SSAnimator = CoreSSAnimation.getUniqueIstance()
        SSAnimator.closeViewWithFadeIn(viewToClose: self.selectedActionButton) { (flag) in
           
        }
        //selectedActionButton.isHidden = true
    }
    private func showSelectedActionButton(){
         // prima si devono selezionare elementi
        //selectedActionButton.isHidden = false
        self.selectedActionButton.isEnabled = false
        let SSAnimator = CoreSSAnimation.getUniqueIstance()
        SSAnimator.openViewWithFadeIn(viewToOpen: self.selectedActionButton) { (flag) in
            //self.selectedActionButton.isEnabled = false
        }
    }
    
    
    @IBAction func multipleSelectionClicked() {
        if collectionView.allowsMultipleSelection {
            cancelSelection()
        } else {
            startSelection()
        }
    }
    
    private func startSelection(){
        collectionView.allowsMultipleSelection = true
        backButton.isEnabled = false
        addNewFolderButton.isEnabled = false
        selectButton.isSelected = true
        showSelectedActionButton()
    }
    private func cancelSelection(){
        selectButton.isSelected = false
        collectionView.allowsMultipleSelection = false
        deselectAllCells()
        setBackButtonState()
        addNewFolderButton.isEnabled = true
        hideSelectedActionButton()
    }
    
    internal func deselectAllCells(){
        for i in 0..<fs.currentFolder.childs.count {
            let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 0))
            cell?.backgroundColor = UIColor.clear
            cell?.isSelected = false
        }
        selectionList.removeAll()
        return
    }
    internal func setUpOscureView(){
        //oscureView = UIView.init(frame: self.view.frame)
        oscureView.backgroundColor = UIColor.primaryBackground
        oscureView.alpha = 0.0
        //oscureView.layer.zPosition = 0
        //self.view.addSubview(oscureView)
    }
    internal func setUpMoveActionButton()-> UIButton{
        let moveButton = UIButton(frame: CGRect(x: 0, y: 0, width: actionsView.frame.size.width * 0.8 - 3, height: 40))
        moveButton.center = CGPoint(x: actionsView.center.x, y: actionsView.center.y * 1.6 - 38)
         moveButton.clipsToBounds = true
        //addFavouriteButton.layer.cornerRadius = 5.0
         moveButton.backgroundColor = UIColor.lightWhite
         moveButton.setTitleColor(UIColor.textBlueColor, for: .normal)
         moveButton.setTitle("Sposta in una cartella", for: .normal)
         moveButton.titleLabel?.font = UIFont(name: "System", size: 9)
        //addFavouriteButton.layer.borderColor = UIColor.secondaryBackground.cgColor
        //addFavouriteButton.layer.borderWidth = 1.0
         moveButton.addTarget(self, action: #selector(moveSelectedDocuments), for: .touchUpInside)
         moveButton.layer.addBorder(edge: .all, color: #colorLiteral(red: 0.9961728454, green: 0.9902502894, blue: 1, alpha: 1), thickness: 0.5)
        //roundTopRadius(radius: 5.0, view: addFavouriteButton)
        //createFolderConfirmButton.layer.zPosition = 3
        
        //roundRightRadius(radius: 5.0, view: createFolderConfirmButton)
        return  moveButton
    }
    @objc func moveSelectedDocuments(){
        
    }
    @objc func deleteSelectedDocuments(){
        //sarebbe il caso di far comparire un alert
        fs.removeChilds(childs: self.selectionList)
        closeActionsView()
        reloadCollectionView()
    }
    internal func setUpDeleteActionButton()-> UIButton{
         let deleteButton = UIButton(frame: CGRect(x: 0, y: 0, width: actionsView.frame.size.width * 0.8, height: 40))
         deleteButton.center = CGPoint(x: actionsView.center.x, y: actionsView.center.y * 1.6 - (38*2))
          deleteButton.clipsToBounds = true
         //addFavouriteButton.layer.cornerRadius = 5.0
         deleteButton.backgroundColor = UIColor.lightWhite
         deleteButton.setTitleColor(UIColor.textBlueColor, for: .normal)
         deleteButton.setTitle("Cancella selezionati", for: .normal)
         deleteButton.titleLabel?.font = UIFont(name: "System", size: 9)
         //addFavouriteButton.layer.borderColor = UIColor.secondaryBackground.cgColor
         //addFavouriteButton.layer.borderWidth = 1.0
         deleteButton.addTarget(self, action: #selector(deleteSelectedDocuments), for: .touchUpInside)
         deleteButton.layer.addBorder(edge: .all, color: #colorLiteral(red: 0.9961728454, green: 0.9902502894, blue: 1, alpha: 1), thickness: 0.5)
         roundTopRadius(radius: 5.0, view: deleteButton)
         //createFolderConfirmButton.layer.zPosition = 3
         
         //roundRightRadius(radius: 5.0, view: createFolderConfirmButton)
         return  deleteButton
    }
    
    
    
    @objc func closeActionsView(){
        let SSAnimator = CoreSSAnimation.getUniqueIstance()
        SSAnimator.collapseViewInSourceFrame(sourceFrame: self.selectedActionButton.frame, viewToCollapse: self.actionsView, oscureView: self.oscureView, elementsInsideView: nil) { (flag) in
            //annulla la selezione
            self.cancelSelection()
        }
    }
    
    internal func setUpCancelActionButton()-> UIButton{
         let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: actionsView.frame.size.width * 0.8, height: 40))
               cancelButton.center = CGPoint(x: actionsView.center.x, y: actionsView.center.y * 1.6)
               cancelButton.clipsToBounds = true
               //cancelButton.layer.cornerRadius = 5.0
               cancelButton.backgroundColor = UIColor.lightWhite
               cancelButton.setTitleColor(UIColor.textRedColor, for: .normal)
               cancelButton.setTitle("Annulla", for: .normal)
               cancelButton.titleLabel?.font = UIFont(name: "System", size: 9)
               //cancelButton.layer.borderColor = UIColor.secondaryBackground.cgColor
               //cancelButton.layer.borderWidth = 1.0
               cancelButton.layer.addBorder(edge: .bottom, color: #colorLiteral(red: 0.9961728454, green: 0.9902502894, blue: 1, alpha: 1), thickness: 0.5)
               roundBottomRadius(radius: 5.0, view: cancelButton)
               cancelButton.addTarget(self, action: #selector(closeActionsView), for: .touchUpInside)
               //createFolderConfirmButton.layer.zPosition = 3
               //roundRightRadius(radius: 5.0, view: createFolderConfirmButton)
               return cancelButton
    }
    internal func setUpActionsViewLabel()-> UILabel{
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: actionsView.frame.size.width * 0.9, height: 40))
        label.text = "Gestisci documenti selezionati"
        label.textColor = UIColor.lightWhite
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.center = CGPoint(x: actionsView.center.x, y: actionsView.center.y/3)
        return label
    }
    internal func setupActionsView(){
        setUpActionsViewLayout()
        let actionsViewLabel = setUpActionsViewLabel()
        let moveActionButton = setUpMoveActionButton() //presente solo in miei documenti
        let deleteActionButton = setUpDeleteActionButton() //presente solo in miei documenti
        //let addInFavouriteActionButton = setUpAddInFavouriteActionButton() //presente solo in pageController
        let cancelActionButton = setUpCancelActionButton() //sempre presente
        self.actionsView.addSubview(actionsViewLabel)
        self.actionsView.addSubview(moveActionButton)
        self.actionsView.addSubview(deleteActionButton)
        //self.actionsView.addSubview(addInFavouriteActionButton)
        self.actionsView.addSubview(cancelActionButton)
    }
    
    internal func setUpActionsViewLayout(){
        let newFrame = CGRect(x: 0, y: 0, width: self.view.frame.size.width * 0.9, height: 180)
        self.actionsView = UIView.init(frame: newFrame)
        self.view.addSubview(actionsView)
        self.actionsView.backgroundColor = UIColor.primaryBackground
        self.actionsView.layer.borderColor = UIColor.secondaryBackground.cgColor
        self.actionsView.layer.borderWidth = 1.0
        self.actionsView.layer.cornerRadius = 5.0
        self.actionsView.transform = CGAffineTransform(scaleX: 1, y: 0.01)
        self.actionsView.alpha = 0.0
        self.actionsView.layer.zPosition = 2
    }
    
    internal func setUpCreateFolderLabel(){
        createFolderLabel.textColor = UIColor.lightWhite
        createFolderLabel.font = UIFont.boldSystemFont(ofSize: 15)
        //UIFont.systemFont(ofSize: 20, weight: .semibold)
        createFolderLabel.textAlignment = .center
    }
    internal func setUpCreateFolderTextField(){
        createFolderTextField.backgroundColor = UIColor.lightWhite
    }
    
    internal func checkIfNameExists(name: String)->Bool{
        for doc in fs.currentFolder.childs{
            if doc.title == name { return true }
        }
        return false
    }
    private func showErrorTextField(textField : UITextField){
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = UIColor.textRedColor.cgColor
    }
    private func hideErrorTextField(textField : UITextField){
        textField.layer.borderWidth = 0.0
        textField.layer.borderColor = UIColor.clear.cgColor
    }
    @IBAction func createFolderWithName(){
        hideErrorTextField(textField: createFolderTextField)
        if createFolderTextField.text != nil && createFolderTextField.text != "" {
            let exists = checkIfNameExists(name: createFolderTextField.text!)
            if exists {
                showErrorTextField(textField: createFolderTextField)
                return
            }
             let SSAnimator = CoreSSAnimation.getUniqueIstance()
             SSAnimator.collapseViewInSourceView(viewToCollapse: self.createFolderView, elementsInsideView: nil, sourceView: self.addNewFolderButton, oscureView: self.oscureView) { (flag) in
                        print("collapsed create folder")
                        self.createFolderTextField.resignFirstResponder()
                        let newFolder = Doc(title: self.createFolderTextField.text!, path: self.fs.currentFolder.path + self.createFolderTextField.text!, type: "folder")
                        self.fs.appendChild(toDoc: self.fs.currentFolder, child: newFolder)
                        //newFolder.setParent(prev: self.fs.currentFolder)
                       // self.fs.currentFolder.addChild(item: newFolder)
                        self.reloadCollectionView()
                        self.createFolderTextField.text = ""
                 }
        }
        else{
            showErrorTextField(textField: createFolderTextField)
            return
        }
    }
    @IBAction func closeCreateFolderView(){
        hideErrorTextField(textField: createFolderTextField)
        let SSAnimator = CoreSSAnimation.getUniqueIstance()
            SSAnimator.collapseViewInSourceView(viewToCollapse: self.createFolderView, elementsInsideView: nil, sourceView: self.addNewFolderButton, oscureView: self.oscureView) { (flag) in
                       print("collapsed create folder")
                    self.createFolderTextField.resignFirstResponder()
                    self.createFolderTextField.text = ""
                }
    }
    internal func setUpCreateFolderConfirmButton(){
        createFolderConfirmButton.backgroundColor = UIColor.lightWhite
        createFolderConfirmButton.setTitleColor(UIColor.textBlueColor, for: .normal)
        createFolderConfirmButton.setTitle("Conferma", for: .normal)
        createFolderConfirmButton.layer.cornerRadius = 5.0
        createFolderConfirmButton.titleLabel?.font = UIFont(name: "System", size: 9)
        //createFolderConfirmButton.layer.zPosition = 3
        roundRightRadius(radius: 5.0, view: createFolderConfirmButton)
    }
    
    internal func setUpCreateFolderCancelButton(){
        createFolderCancelButton.backgroundColor = UIColor.lightWhite
        createFolderCancelButton.setTitle("Annulla", for: .normal)
        createFolderCancelButton.setTitleColor(UIColor.textRedColor, for: .normal)
        createFolderCancelButton.layer.cornerRadius = 5.0
        createFolderCancelButton.titleLabel?.font = UIFont(name: "System", size: 9)
        createFolderCancelButton.isEnabled = true
        //createFolderCancelButton.layer.zPosition = 3
        createFolderCancelButton.layer.addBorder(edge: .right, color: #colorLiteral(red: 0.9961728454, green: 0.9902502894, blue: 1, alpha: 1), thickness: 0.5)
        roundLeftRadius(radius: 5.0, view: createFolderCancelButton)
    }
    internal func setUpCreateFolderView(){
        setUpCreateFolderLabel()
        setUpCreateFolderTextField()
        setUpCreateFolderCancelButton()
        setUpCreateFolderConfirmButton()
        createFolderView.backgroundColor = UIColor.createCategoryViewColor
        createFolderView.layer.borderColor = UIColor.secondaryBackground.cgColor
        createFolderView.layer.borderWidth = 1.0
        createFolderView.layer.cornerRadius = 5.0
        //createFolderView.layer.zPosition = 3
          
        //createFolderView.addSubview(createFolderConfirmButton)
        //createFolderView.addSubview(createFolderCancelButton)
       }
    
   
    @IBAction func selectedActionButtonClicked(_ sender: Any) {
        setupActionsView()
        setUpOscureView()
        let SSAnimator = CoreSSAnimation.getUniqueIstance()
        SSAnimator.expandViewFromSourceFrame(sourceFrame: self.selectedActionButton.frame, viewToExpand: self.actionsView, elementsInsideView: nil, oscureView: self.oscureView) { (flag) in
            
        }
    }
    internal func openDocument(_ str: String) {
        print("openDocument \(str)")
        let dot = str.firstIndex(of: ".")!
        
        guard let url = Bundle.main.url(
                            forResource: String(str[..<dot]),
                            withExtension: String(str[str.index(after: dot)...])
                        )
        else { return }
        
        let vc = storyboard!.instantiateViewController(withIdentifier: "DocumentBrowserViewController") as! DocumentBrowserViewController
        vc.documentController = UIDocumentInteractionController(url: url)
        
        self.present(vc, animated: true, completion: nil)
        vc.openFile()
    }
    
    internal func setRevealViewControllerParameters(){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        imageView.image = UIImage.init(named: "menu")
        let buttonView = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        buttonView.addSubview(imageView)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: buttonView)
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130 //Menu sx
            revealViewController().delegate = self
            self.navigationItem.leftBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))))
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
    func roundLeftRadius(radius:CGFloat, view : UIView) {
          self.roundCorners(corners: [UIRectCorner.topLeft, UIRectCorner.bottomLeft], radius:radius, view: view)
      }
      
      func roundRightRadius(radius:CGFloat, view : UIView) {
          self.roundCorners(corners: [UIRectCorner.topRight, UIRectCorner.bottomRight], radius:radius, view: view)
      }
    func roundBottomRadius(radius:CGFloat, view : UIView) {
        self.roundCorners(corners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], radius:radius, view: view)
    }
    func roundTopRadius(radius:CGFloat, view : UIView) {
        self.roundCorners(corners: [UIRectCorner.topLeft, UIRectCorner.topRight], radius:radius, view: view)
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
