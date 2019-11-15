//
//  DocumentsPageViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 10/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class DocumentsPageViewController: DocumentsViewController{
    var thisTeachingTitle: String!
    //TODO:
    override func fillDocSystem() {
        //non fa nulla perchè è già scaricato dal server e settato dal teachingController
        //è un fs di tipo temporaneo
    }
    override func setErrorLabelText() {
          errorMessageLabel.text = "Il docente non ha aggiunto alcun documento al corso."
    }
    override func showError() {
        errorMessageLabel.isHidden = false
    }
    override func loadDocumentsList() {
        //il metodo non fa nulla perchè il chiamante ha già settato i documenti.
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
        let addInFavouriteActionButton = setUpAddInFavouriteActionButton() //presente solo in pageController
        let cancelActionButton = setUpCancelActionButton() //sempre presente
        self.actionsView.addSubview(actionsViewLabel)
        self.actionsView.addSubview(addInFavouriteActionButton)
        self.actionsView.addSubview(cancelActionButton)
    }
    @objc func addToSelectedDocumentsToFavourite(){
        let permanentFS = PermanentDocSystem.getUniqueIstance()
        let thisCourseFolder = Doc.init(title: thisTeachingTitle , path: "/"+thisTeachingTitle, type: "folder")
        let appendedFolder = permanentFS.appendChild(toDoc: permanentFS.root, child: thisCourseFolder)
        permanentFS.appendChilds(toDoc: appendedFolder, childs: selectionList)
        closeActionsView()
    }
    private func setUpAddInFavouriteActionButton()-> UIButton{
        let addFavouriteButton = UIButton(frame: CGRect(x: 0, y: 0, width: actionsView.frame.size.width * 0.8, height: 40))
        addFavouriteButton.center = CGPoint(x: actionsView.center.x, y: actionsView.center.y * 1.6 - 38)
        addFavouriteButton.clipsToBounds = true
        addFavouriteButton.backgroundColor = UIColor.lightWhite
        addFavouriteButton.setTitleColor(UIColor.textBlueColor, for: .normal)
        addFavouriteButton.setTitle("Aggiungi a preferiti", for: .normal)
        addFavouriteButton.titleLabel?.font = UIFont(name: "System", size: 9)
        addFavouriteButton.addTarget(self, action: #selector(addToSelectedDocumentsToFavourite), for: .touchUpInside)
        addFavouriteButton.layer.addBorder(edge: .all, color: #colorLiteral(red: 0.9961728454, green: 0.9902502894, blue: 1, alpha: 1), thickness: 0.5)
        roundTopRadius(radius: 5.0, view: addFavouriteButton)
        return addFavouriteButton
    }
    
    
    
}
