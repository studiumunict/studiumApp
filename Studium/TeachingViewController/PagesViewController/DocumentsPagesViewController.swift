//
//  DocumentsPageViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 10/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class DocumentsPageViewController: DocumentsViewController{
    
    //TODO:
    //il suo DOcumentsDataSource è già dettato dal chiamante(teachingViewController)
    //deve essere fatto override del metodo evento : selectedFile()
    //esso deve permettere di aggiungere il file ai preferiti. Questo deve scaricare il file ed inserirlo in una cartella con il nome del corso. Poi questa cartella dev estar enella directory. Tutto ciò deve essere salvato sul coreData, in modo da essere poi tirato fuori con la funziona loadFiles() nell documentsViewController.
    
    //in realtà queste funzioni non verranno mai invocate, perchè quando non ci sono documenti, la pagina è proprio nascosta. Se spuntasse la pagina, queste funzioni permetterebero di mostrare errore all'utente per l'assenza di documenti.
    override func setErrorLabelText() {
          errorMessageLabel.text = "Il docente non ha aggiunto alcun documento al corso."
         // errorInfoDescriptionTextView.text = ""
    }
    override func showError() {
        errorMessageLabel.isHidden = false
    }
    override func loadDocumentsList() {
        //DO NOTHING.
        //il metodo non fa nulla perchè il chiamante ha già settato i documenti.
        print("Error: documenti già impostati dal chiamante")
    }
    override func setHeaderViewLayout() {
        headerView.backgroundColor = UIColor.lightWhite
        headerView.layer.borderWidth = 0.5
        headerView.layer.borderColor = UIColor.primaryBackground.cgColor
        titleLabel.text = fs.currentFolder.title
        addNewFolderButton.isHidden = true
    }
    override func setupActionsView(){
        setUpActionsViewLayout()
        let actionsViewLabel = setUpActionsViewLabel()
        //let moveActionButton = setUpMoveActionButton() //presente solo in miei documenti
        //let deleteActionButton = setUpDeleteActionButton() //presente solo in miei documenti
        let addInFavouriteActionButton = setUpAddInFavouriteActionButton() //presente solo in pageController
        let cancelActionButton = setUpCancelActionButton() //sempre presente
        //self.actionsView.addSubview(moveActionButton)
        //self.actionsView.addSubview(deleteActionButton)
        self.actionsView.addSubview(actionsViewLabel)
        self.actionsView.addSubview(addInFavouriteActionButton)
        self.actionsView.addSubview(cancelActionButton)
    }
    @objc func addToSelectedDocumentsToFavourite(){
        
    }
    private func setUpAddInFavouriteActionButton()-> UIButton{
        let addFavouriteButton = UIButton(frame: CGRect(x: 0, y: 0, width: actionsView.frame.size.width * 0.8, height: 40))
        addFavouriteButton.center = CGPoint(x: actionsView.center.x, y: actionsView.center.y * 1.6 - 38)
        addFavouriteButton.clipsToBounds = true
        //addFavouriteButton.layer.cornerRadius = 5.0
        addFavouriteButton.backgroundColor = UIColor.lightWhite
        addFavouriteButton.setTitleColor(UIColor.textBlueColor, for: .normal)
        addFavouriteButton.setTitle("Aggiungi a preferiti", for: .normal)
        addFavouriteButton.titleLabel?.font = UIFont(name: "System", size: 9)
        //addFavouriteButton.layer.borderColor = UIColor.secondaryBackground.cgColor
        //addFavouriteButton.layer.borderWidth = 1.0
        addFavouriteButton.addTarget(self, action: #selector(addToSelectedDocumentsToFavourite), for: .touchUpInside)
        addFavouriteButton.layer.addBorder(edge: .all, color: #colorLiteral(red: 0.9961728454, green: 0.9902502894, blue: 1, alpha: 1), thickness: 0.5)
        roundTopRadius(radius: 5.0, view: addFavouriteButton)
        //createFolderConfirmButton.layer.zPosition = 3
        
        //roundRightRadius(radius: 5.0, view: createFolderConfirmButton)
        return addFavouriteButton
    }
    
    
    
}
