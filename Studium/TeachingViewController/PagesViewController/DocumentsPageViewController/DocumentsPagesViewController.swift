//
//  DocumentsPageViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 10/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class DocumentsPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var errorMessageLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var descrizioneLabel: UILabel!
    
    
    var documentsList: [Docs]! //Completa
    var subList = [Docs]() //Lista contenente gli elementi di una cartella
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightWhite
        self.view.layer.borderColor = UIColor.primaryBackground.cgColor
        self.view.layer.borderWidth = 0.5
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        for x in documentsList {
            if x.prev == nil {
                subList.append(x)
            }
        }
        
        if subList.count == 1 {
            descrizioneLabel.text = "1 elemento"
        } else {
            descrizioneLabel.text = String(subList.count) + " elementi"
        }
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
        
        if subList[indexPath.item].next.count == 1 {
            cell.numberOfSubDocLabel.text = "1 elemento"
        } else {
            cell.numberOfSubDocLabel.text = String(subList[indexPath.item].next.count) + " elementi"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if subList[indexPath.item].type == .folder {
            reloadList(currentDoc: subList[indexPath.item])
            collectionView.reloadData()
            
            if subList.count == 1 {
                descrizioneLabel.text = "1 elemento"
            } else {
                descrizioneLabel.text = String(subList.count) + " elementi"
            }
        } //else visualizza il file
    }
    
    
    
    private func reloadList(currentDoc: Docs) {
        subList.removeAll()
        
        for x in documentsList {
            if x.path! == currentDoc.path! {
                for z in x.next {
                    subList.append(z)
                }
            }
        }
    }
    

}
