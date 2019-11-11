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
   // @IBOutlet weak var errorInfoDescriptionTextView: UITextView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var descrizioneLabel: UILabel!
    @IBOutlet var headerView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var addNewFolderButton: UIButton!
    @IBOutlet var selectButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
   
    @IBOutlet weak var selectedActionButton: UIButton!
    
    var selectionList = [Doc]() //Lista contenente gli elementi della selezione multipla
    var fs = DocSystem() //contiene tutti gli elementi a partire da root. E' un albero.
    //var documentController: UIDocumentInteractionController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightWhite
        self.view.layer.borderColor = UIColor.primaryBackground.cgColor
        self.view.layer.borderWidth = 0.5
        setRevealViewControllerParameters()
        //loadDocumentsList()
        collectionView.dataSource = self
        collectionView.delegate = self
        //fs.currentFolder.addChild(item: Doc.init(title: "Titolo1", path: "/titolo1", type: .folder))
       
        if fs.currentFolder.childs.count == 0 {
            setEmptyContentLayout()
        } else {
            setFullContentLayout()
        }
        reloadCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setRevealViewControllerParameters()
    }
    
    func setErrorLabelText() {
        errorMessageLabel.text = "Non ci sono documenti preferiti salvati."
        //errorInfoDescriptionTextView.text = "Puoi aggiungere un documento dalla sezione Documenti di un qualsiasi corso."
    }
    
    func hideElementsOfView() {
        descrizioneLabel.isHidden = true
        headerView.isHidden = true
        collectionView.isHidden = true
        selectedActionButton.isHidden = true
    }
    
    func showError() {
        setErrorLabelText()
        errorMessageLabel.isHidden = false
        errorMessageLabel.layer.zPosition = 2
        //errorInfoDescriptionTextView.isHidden = false
    }
    
    func setEmptyContentLayout(){
        setErrorLabelText()
        showError()
        //errorInfoDescriptionTextView.backgroundColor = self.view.backgroundColor
        hideElementsOfView()
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
    
    func setFullContentLayout(){
        setHeaderViewLayout()
        reloadDescriptionLabel()
        setSelectedActionButtonLayout()
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
        if cellType == .file {
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
            if fs.currentFolder.childs[indexPath.item].type == .folder {
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
    
    func reloadCollectionView(){
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
        selectionList.remove(at: index)
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
    
    
    @IBAction func backButtonBarSelected(_ sender: UIButton) {
        fs.goToParent()
        reloadCollectionView()
    }
    
   /* @IBAction func addNewFolderSelected(_ sender: UIButton) {
        
        let newFolder = Docs(title: "Nuova cartella", path: fs.currentFolder.path + "/Nuova cartella", type: .folder)
        
        if subList.isEmpty {
            newFolder.setPrev(prev: folderEmptySelected)
        } else {
            newFolder.setPrev(prev: subList.first?.prev)
        }
        
        documentsList.append(newFolder)
        subList.append(newFolder)
        
        collectionView.reloadData()
        reloadDescriptionLabel()
    }*/
    private func hideSelectedActionButton(){
        selectedActionButton.isHidden = true
    }
    private func showSelectedActionButton(){
        selectedActionButton.isEnabled = false // prima si devono selezionare elementi
        selectedActionButton.isHidden = false
    }
    
    @IBAction func didMultipleSelectionSelected() {
        if collectionView.allowsMultipleSelection {
            selectButton.isSelected = false
            collectionView.allowsMultipleSelection = false
            deselectAllCells()
            setBackButtonState()
            addNewFolderButton.isEnabled = true
            hideSelectedActionButton()
        } else {
            collectionView.allowsMultipleSelection = true
            backButton.isEnabled = false
            addNewFolderButton.isEnabled = false
            selectButton.isSelected = true
            showSelectedActionButton()
        }
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
    
   
    @IBAction func selectedActionButtonClicked(_ sender: Any) {
        
    }
    
    /*@IBAction func deleteButtonSelected(_ sender: UIButton) {
        var i: Int, j: Int
        
        while !selectionList.isEmpty {
            i = 0
            for item in subList {
                if item == selectionList[0] {
                    subList.remove(at: i)
                    break
                }
                i += 1
            }
            
            i = 0
            for item in documentsList {
                if item == selectionList[0] {
                    if item.TypeDoc == .folder {
                        removeDocsInDocumentsListRecursive(array: item.next)
                        while !indexes.isEmpty {
                            j = 0
                            for x in documentsList {
                                if x == indexes[0] {
                                    documentsList.remove(at: j)
                                }
                                j += 1
                            }
                            indexes.removeFirst()
                        }
                    }
                    documentsList.remove(at: i)
                    break
                }
                i += 1
            }
            selectionList.removeFirst()
        }
        
        didMultipleSelectionSelected()
        collectionView.reloadData()
        resetCell()
    }*/
    
    //var indexes = [Docs]()
    
   /* internal func removeDocsInDocumentsListRecursive(array: [Docs]) {
        for item in array {
            if item.TypeDoc == .folder && !item.next.isEmpty {
                removeDocsInDocumentsListRecursive(array: item.next)
            }
        }
        
        indexes.append(contentsOf: array)
    }
    */
    
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
    

}
