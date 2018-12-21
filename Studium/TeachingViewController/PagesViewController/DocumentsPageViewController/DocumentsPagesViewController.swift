//
//  DocumentsPageViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 10/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class DocumentsPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var errorMessageLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var descrizioneLabel: UILabel!
    @IBOutlet var headerNavigationItem: UINavigationItem!
    @IBOutlet var backButtonBar: UIBarButtonItem!
    @IBOutlet var addNewFolderButtonBar: UIBarButtonItem!
    @IBOutlet var selectButtonBar: UIBarButtonItem!
    
    
    var documentsList: [Docs]! //Completa
    var subList = [Docs]() //Lista contenente gli elementi di una cartella
    var selectionList = [Docs]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightWhite
        self.view.layer.borderColor = UIColor.primaryBackground.cgColor
        self.view.layer.borderWidth = 0.5
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        reloadList(currentDoc: nil)
        
        headerNavigationItem.title = "Home"
        backButtonBar.title = "Back"
        backButtonBar.isEnabled = false
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "docsCell", for: indexPath) as! DocumentsCollectionViewCell
        
        if subList[indexPath.item].type == .file {
            cell.imageDoc.image = UIImage(named: "showcase")
        } else {
            cell.imageDoc.image = UIImage(named: "folder")
        }
        
        cell.titleDocLabel.text = subList[indexPath.item].path!
        
        if subList[indexPath.item].type == .folder {
            if subList[indexPath.item].next.count == 1 {
                cell.descriptionDocLabel.text = "1 elemento"
            } else {
                cell.descriptionDocLabel.text = String(subList[indexPath.item].next.count) + " elementi"
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if subList[indexPath.item].type == .folder {
            reloadList(currentDoc: subList[indexPath.item])
            collectionView.reloadData()
            backButtonBar.isEnabled = true
            headerNavigationItem.title = subList.first?.prev.path!
        } //else visualizza il file
    }
    
    
    //Margini
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    /* Dimensioni della cella
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        <#code#>
    } */
    
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
                if x.path! == currentDoc.path! {
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
        
        if subList.count == 1 {
            descrizioneLabel.text = "1 elemento"
        } else {
            descrizioneLabel.text = String(subList.count) + " elementi"
        }
    }
    
    
    @IBAction func backButtonBarSelected(_ sender: UIBarButtonItem) {
        reloadList(currentDoc: subList.first?.prev.prev)
        collectionView.reloadData()
        
        if subList.first?.prev == nil {
            backButtonBar.isEnabled = false
            headerNavigationItem.title = "Home"
        } else {
            headerNavigationItem.title = subList.first?.prev.path!
        }
    }
    
    @IBAction func addNewFolderSelected(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func didMultipleSelectionSelected(_ sender: UIBarButtonItem) {
        if collectionView.allowsMultipleSelection {
            selectButtonBar.title = "Seleziona"
            //le celle ritornano al design di default
            collectionView.allowsMultipleSelection = false
        } else {
            selectButtonBar.title = "Fatto"
            //le celle cambiano design
            collectionView.allowsMultipleSelection = true
        }
    }

}
