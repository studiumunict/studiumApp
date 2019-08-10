//
//  DocumentsViewController.swift
//  Studium
//
//  Created by Simone Scionti on 23/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit


class DocumentsViewController: UIViewController, SWRevealViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var errorMessageLabel: UILabel!
    @IBOutlet weak var errorInfoDescriptionTextView: UITextView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var descrizioneLabel: UILabel!
    @IBOutlet var headerView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var addNewFolderButton: UIButton!
    @IBOutlet var selectButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var selectedStackView: UIStackView!
    @IBOutlet var deleteButton: UIButton!

    var documentsList = [Docs]() //Completa
    var subList = [Docs]() //Lista contenente gli elementi di una cartella..
    var selectionList = [Docs]() //Lista contenente gli elementi della selezione multipla
    var folderEmptySelected: Docs!
    var prevIndexItem: Int!
    var fileSelected: Docs!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightWhite
        self.view.layer.borderColor = UIColor.primaryBackground.cgColor
        self.view.layer.borderWidth = 0.5
        setRevealViewControllerParameters()
        loadDocumentsList()
        collectionView.dataSource = self
        collectionView.delegate = self
        if documentsList.isEmpty {
            setControllerForEmptyList()
        } else {
            setControllerForListWithElements()
        }
       
    }
    override func viewDidAppear(_ animated: Bool) {
        setRevealViewControllerParameters()
    }
    
    func setErrorLabelText() {
        errorMessageLabel.text = "Non ci sono documenti preferiti salvati."
        errorInfoDescriptionTextView.text = "Puoi aggiungere un documento dalla sezione Documenti di un qualsiasi corso."
    }
    func hideElementsOfView() {
        descrizioneLabel.isHidden = true
        headerView.isHidden = true
        selectedStackView.isHidden = true
        collectionView.isHidden = true
    }
    
    func showError() {
        setErrorLabelText()
        errorMessageLabel.isHidden = false
        errorInfoDescriptionTextView.isHidden = false
    }
    
    func setControllerForEmptyList(){
        print("empty")
        showError()
        errorInfoDescriptionTextView.backgroundColor = self.view.backgroundColor
        hideElementsOfView()
    }
    func setControllerForListWithElements(){
        reloadList(currentDoc: nil)
        headerView.backgroundColor = UIColor.lightWhite
        headerView.layer.borderWidth = 0.5
        headerView.layer.borderColor = UIColor.primaryBackground.cgColor
        titleLabel.text = "Home"
        backButton.titleLabel?.text = "Back"
        backButton.isEnabled = false
        backButton.titleLabel?.textColor = UIColor.elementsLikeNavBarColor
        selectedStackView.layer.borderColor = UIColor.primaryBackground.cgColor
        selectedStackView.layer.borderWidth = 0.5
        selectedStackView.clipsToBounds = true
        
    }
    
    private func setRevealViewControllerParameters(){
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
        
        
        documentsList.append(Docs(path: "cartella1", type: .folder))
        documentsList.append(Docs(path: "file1", type: .file))
        documentsList.append(Docs(path: "file2", type: .file))
        documentsList.append(Docs(path: "file3", type: .file))
        documentsList.append(Docs(path: "file4", type: .file))
        documentsList.append(Docs(path: "file5", type: .file))
        documentsList.append(Docs(path: "file6", type: .file))
        documentsList.append(Docs(path: "file7", type: .file))
        documentsList.append(Docs(path: "file8", type: .file))
        documentsList.append(Docs(path: "file9", type: .file))
        documentsList.append(Docs(path: "file10", type: .file))
        documentsList.append(Docs(path: "file11", type: .file))
        documentsList.append(Docs(path: "file12", type: .file))
        documentsList.append(Docs(path: "file13", type: .file))
        documentsList[12].setPrev(prev: documentsList[0])
        documentsList[13].setPrev(prev: documentsList[0])
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "docsCell", for: indexPath) as! DocumentsCollectionViewCell
        
        switch subList[indexPath.item].TypeDoc {
        case .file?:
            cell.update(image: "showcase", title: subList[indexPath.item].path!, description: "")
            
        case .folder?:
            if subList[indexPath.item].next.count == 1 {
                cell.update(image: "folder", title: subList[indexPath.item].path!, description: "1 elemento")
            } else {
                cell.update(image: "folder", title: subList[indexPath.item].path!, description: String(subList[indexPath.item].next.count) + " elementi")
            }
            
        default:
            break
        }
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.allowsMultipleSelection {
            if !selectionList.contains(subList[indexPath.item]){
                selectionList.append(subList[indexPath.item])
            }
            
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.backgroundColor = UIColor.lightSectionColor
            
        } else {
            if subList[indexPath.item].TypeDoc == .folder {
                if subList[indexPath.item].next.isEmpty {
                    folderEmptySelected = subList[indexPath.item]
                }
                prevIndexItem = indexPath.item
                reloadList(currentDoc: subList[indexPath.item])
                self.collectionView.reloadData()
                backButton.isEnabled = true
                titleLabel.text = subList.isEmpty ? folderEmptySelected.path! : subList.first?.prev.path!
            } else { //Visualizza il file
                print("file selezionato:: \((subList[indexPath.item].path)!)")
                fileSelected = subList[indexPath.item]
                self.performSegue(withIdentifier: "segueToFileDetail", sender: nil)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.backgroundColor = cell.isSelected ? UIColor.lightSectionColor : UIColor.clear
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard collectionView.allowsMultipleSelection else {
            return
        }
        
        guard !selectionList.isEmpty else {
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        guard cell?.backgroundColor != UIColor.clear else {
            return
        }
        
        var i: Int = 0
        for x in selectionList {
            if x == subList[indexPath.item] {
                break
            }
            i += 1
        }
        
        cell?.backgroundColor = UIColor.clear
        selectionList.remove(at: i)
    }
    
    
    //Margini
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 5, bottom: 5, right: 5)
    }
    
    // Dimensioni della cella
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width - 30) / 3, height: 135)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    //Rispetto a currentDocs, popola subList con i suoi successori
    private func reloadList(currentDoc: Docs!) {
        subList.removeAll()
        
        if currentDoc != nil {
            for x in documentsList {
                if x == currentDoc {
                    for z in x.next {
                        subList.append(z)
                    }
                }
            }
        } else {
            for x in documentsList {
                if x.prev == nil {
                    subList.append(x)
                }
            }
        }
        
        reloadDescriptionLabel()
    }
    
    private func reloadDescriptionLabel() {
        if subList.count == 1 {
            descrizioneLabel.text = "1 elemento"
        } else {
            descrizioneLabel.text = String(subList.count) + " elementi"
        }
    }
    
    
    @IBAction func backButtonBarSelected(_ sender: UIButton) {
        if subList.isEmpty {
            reloadList(currentDoc: folderEmptySelected.prev)
        } else {
            reloadList(currentDoc: documentsList[prevIndexItem].prev)
        }
        
        collectionView.reloadData()
        
        if subList.first?.prev == nil {
            backButton.isEnabled = false
            titleLabel.text = "Home"
        } else {
            titleLabel.text = subList.first?.prev.path!
        }
    }
    
    @IBAction func addNewFolderSelected(_ sender: UIButton) {
        let newFolder = Docs(path: "Nuova cartella", type: .folder)
        
        if subList.isEmpty {
            newFolder.setPrev(prev: folderEmptySelected)
        } else {
            newFolder.setPrev(prev: subList.first?.prev)
        }
        
        documentsList.append(newFolder)
        subList.append(newFolder)
        
        collectionView.reloadData()
        reloadDescriptionLabel()
    }
    
    @IBAction func didMultipleSelectionButtonSelected(_ sender: UIButton) {
        didMultipleSelectionSelected()
    }
    
    private func didMultipleSelectionSelected() {
        if collectionView.allowsMultipleSelection {
            selectButton.titleLabel?.text = "Seleziona"
            collectionView.allowsMultipleSelection = false
            resetCell()
        } else {
            selectButton.titleLabel?.text = "Fatto"
            collectionView.allowsMultipleSelection = true
        }
        
        backButton.isEnabled = subList.first?.prev != nil && !collectionView.allowsMultipleSelection
        addNewFolderButton.isEnabled = !collectionView.allowsMultipleSelection
        descrizioneLabel.isHidden = collectionView.allowsMultipleSelection
        selectedStackView.isHidden = !collectionView.allowsMultipleSelection
    }
    
    private func resetCell() {
        if selectionList.isEmpty {
            for i in 0..<subList.count {
                let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 0))
                cell?.backgroundColor = UIColor.clear
            }
            return
        }
        
        var i: Int
        while !selectionList.isEmpty {
            i = 0
            for item in subList {
                if item == selectionList[0] {
                    let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 0))
                    cell?.backgroundColor = UIColor.clear
                    
                    break
                }
                i += 1
            }
            
            selectionList.removeFirst()
        }
    }
    
    @IBAction func deleteButtonSelected(_ sender: UIButton) {
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
    }
    
    var indexes = [Docs]()
    
    private func removeDocsInDocumentsListRecursive(array: [Docs]) {
        for item in array {
            if item.TypeDoc == .folder && !item.next.isEmpty {
                removeDocsInDocumentsListRecursive(array: item.next)
            }
        }
        
        indexes.append(contentsOf: array)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToFileDetail" {
            (segue.destination as! FileDetailViewController).file = fileSelected
        }
    }
    

}
