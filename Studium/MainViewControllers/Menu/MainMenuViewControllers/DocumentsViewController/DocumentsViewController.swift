//
//  DocumentsViewController.swift
//  Studium
//
//  Created by Simone Scionti on 23/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit


class DocumentsViewController: UIViewController, SWRevealViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIDocumentInteractionControllerDelegate  {
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
    let documentInteractionController = UIDocumentInteractionController()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightWhite
        self.view.layer.borderColor = UIColor.primaryBackground.cgColor
        self.view.layer.borderWidth = 0.5
        self.documentInteractionController.delegate = self
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
    internal func disableControllerInteraction(){
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = false
        collectionView.allowsSelection = false
    }
    internal func enableControllerInteraction(){
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        self.view.isUserInteractionEnabled = true
        collectionView.allowsSelection = true
    }
    internal func fillDocSystem(){ //fileSystemPermanente
        fs = PermanentDocSystem.getUniqueIstance()
    }
    override func viewDidAppear(_ animated: Bool) {
        setRevealViewControllerParameters()
        appDelegate.isFilePresented = false
    }
    
    func setErrorLabelText() {
        errorMessageLabel.font = UIFont(name: "system", size: 12)
        errorMessageLabel.text = "Non ci sono documenti preferiti salvati. Puoi aggiungere documenti alla sezione preferiti selezionandone alcuni dalla pagina di un qualsiasi corso di tuo interesse."
        errorMessageLabel.numberOfLines = 5
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
            cell.update(type: "file", title: fs.currentFolder.childs[indexPath.item].title!, description: "")
        }
        else{
            if fs.currentFolder.childs[indexPath.item].childs.count == 1 {
                cell.update(type: "folder", title: fs.currentFolder.childs[indexPath.item].title!, description: "1 elemento")
            } else {
                cell.update(type: "folder", title: fs.currentFolder.childs[indexPath.item].title!, description: String(fs.currentFolder.childs[indexPath.item].childs.count) + " elementi")
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
                fileSelected(indexPath: indexPath)
            }
        }
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
           guard let navVC = self.navigationController else {
               return self
           }
           return navVC
       }
    
    func openFile(tempUrl: URL) {
        documentInteractionController.url = tempUrl
        documentInteractionController.uti = tempUrl.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = tempUrl.localizedName ?? tempUrl.lastPathComponent
        documentInteractionController.presentPreview(animated: true)
    }
    
    func fileSelected(indexPath: IndexPath){
            
            self.disableControllerInteraction()
            let cell = self.collectionView.cellForItem(at: indexPath) as! DocumentsCollectionViewCell
            cell.startActivityIndicator()
            let file =  fs.currentFolder.childs[indexPath.item]
            let fd = FileDownloader.getUniqueIstance()
            fd.downloadFile(courseID: file.courseID, fsDoc: file, completion: { (tempurl) in
                if let url = tempurl { //donwload effetturato
                    self.openFile(tempUrl: url)
                    self.appDelegate.isFilePresented = true
                }
                else{ //errore download
                    print("Errore apertura file")
                }
                cell.stopActyivityIndicator()
                self.enableControllerInteraction()
            })
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
    }
    private func showSelectedActionButton(){
        self.selectedActionButton.isEnabled = false
        let SSAnimator = CoreSSAnimation.getUniqueIstance()
        SSAnimator.openViewWithFadeIn(viewToOpen: self.selectedActionButton) { (flag) in
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
    }
    internal func setUpOscureView(){
        oscureView.backgroundColor = UIColor.primaryBackground
        oscureView.alpha = 0.0
    }
    internal func setUpMoveActionButton()-> UIButton{
        let CV = ConfirmView.getUniqueIstance()
        return CV.getButton(position: .center, dataToAttach: nil, title: "Sposta in una cartella", selector:   #selector(moveSelectedDocuments), target: self)
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
        let CV = ConfirmView.getUniqueIstance()
        return CV.getButton(position: .top, dataToAttach: nil, title: "Cancella selezionati", selector:  #selector(deleteSelectedDocuments), target: self)
    }

    @objc func closeActionsView(){
        let SSAnimator = CoreSSAnimation.getUniqueIstance()
        SSAnimator.collapseViewInSourceFrame(sourceFrame: self.selectedActionButton.frame, viewToCollapse: self.actionsView, oscureView: self.oscureView, elementsInsideView: nil) { (flag) in
            //annulla la selezione
            self.cancelSelection()
        }
    }
    
    internal func setUpCancelActionButton()-> UIButton{
        let CV = ConfirmView.getUniqueIstance()
        return CV.getButton(position: .bottom, dataToAttach: nil, title: "Annulla", selector: #selector(closeActionsView), target: self)
    }
    internal func setUpActionsViewLabel()-> UILabel{
        let CV = ConfirmView.getUniqueIstance()
        return CV.getTitleLabel(text: "Gestisci dodumenti selezionati")
    }
    internal func setupActionsView(){
        let CV = ConfirmView.getUniqueIstance()
        let deleteActionButton = setUpDeleteActionButton() //presente solo in miei documenti
        let moveActionButton = setUpMoveActionButton()
        let cancelActionButton = setUpCancelActionButton() //sempre presente
        let actionsViewLabel = setUpActionsViewLabel()
        self.actionsView = CV.getView(titleLabel: actionsViewLabel, descLabel: nil, buttons: [cancelActionButton,deleteActionButton,moveActionButton], dataToAttach: nil)
        self.view.addSubview(actionsView)
    }
    
    internal func setUpCreateFolderLabel(){
        createFolderLabel.textColor = UIColor.lightWhite
        createFolderLabel.font = UIFont.boldSystemFont(ofSize: 15)
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
                        self.createFolderTextField.resignFirstResponder()
                        let newFolder = Doc(title: self.createFolderTextField.text!, path: self.fs.currentFolder.path + self.createFolderTextField.text!, type: "folder", courseID: "")
                        let _ = self.fs.appendChild(toDoc: self.fs.currentFolder, child: newFolder)
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
        SSCustomLayers.getUniqueIstance().roundRightRadius(radius: 5.0, view: createFolderConfirmButton)
    }
    
    internal func setUpCreateFolderCancelButton(){
        createFolderCancelButton.backgroundColor = UIColor.lightWhite
        createFolderCancelButton.setTitle("Annulla", for: .normal)
        createFolderCancelButton.setTitleColor(UIColor.textRedColor, for: .normal)
        createFolderCancelButton.layer.cornerRadius = 5.0
        createFolderCancelButton.titleLabel?.font = UIFont(name: "System", size: 9)
        createFolderCancelButton.isEnabled = true
        createFolderCancelButton.layer.addBorder(edge: .right, color: #colorLiteral(red: 0.9961728454, green: 0.9902502894, blue: 1, alpha: 1), thickness: 0.5)
        SSCustomLayers.getUniqueIstance().roundLeftRadius(radius: 5.0, view: createFolderCancelButton)
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
       }
    
   
    @IBAction func selectedActionButtonClicked(_ sender: Any) {
        setupActionsView()
        setUpOscureView()
        let SSAnimator = CoreSSAnimation.getUniqueIstance()
        SSAnimator.expandViewFromSourceFrame(sourceFrame: self.selectedActionButton.frame, viewToExpand: self.actionsView, elementsInsideView: nil, oscureView: self.oscureView) { (flag) in
            //do nothing in completion
        }
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
    
}

