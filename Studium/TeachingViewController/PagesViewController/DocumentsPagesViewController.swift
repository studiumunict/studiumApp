//
//  DocumentsPageViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 10/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class DocumentsPageViewController: DocumentsViewController{
    weak var thisTeaching: Teaching!
    weak var teachingController : TeachingViewController!
    
    override func viewDidAppear(_ animated: Bool) {
        //non fa nulla perchè sennò si avrebbero problemi con l'orientation usata per il documentInteractionController.
        //il tutto è implementato invece nel TeachingController perchè il lavigationController è il suo.
    }
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
    override func setHeaderViewLayout() {
        headerView.backgroundColor = UIColor.lightWhite
        headerView.layer.borderWidth = 0.5
        headerView.layer.borderColor = UIColor.primaryBackground.cgColor
        titleLabel.text = fs.currentFolder.title
        addNewFolderButton.isHidden = true
    }
    override  func openFile(tempUrl: URL) {
        teachingController.openFile(tempUrl: tempUrl)
    }
    override func setupActionsView(){
        setUpActionsViewLayout()
        let actionsViewLabel = setUpActionsViewLabel()
        let addFavouriteButton = setUpAddInFavouriteActionButton()
        let cancelButton = setUpCancelActionButton()
    
        self.actionsView.addSubview(actionsViewLabel)
        self.actionsView.addSubview(addFavouriteButton)
        self.actionsView.addSubview(cancelButton)
    }
    
    private func setUpCloseConfirmActionButton() -> UIButton{
        let closeConfirmButton = UIButton(frame: CGRect(x: 0, y: 100 , width: 200, height: 40))
        closeConfirmButton.center.x = self.actionsView.center.x - 20
        closeConfirmButton.backgroundColor = UIColor.lightWhite
        closeConfirmButton.setTitleColor(UIColor.textBlueColor, for: .normal)
        closeConfirmButton.accessibilityElements = [IndexPath]()
        closeConfirmButton.addTarget(self, action: #selector(closeActionsView), for: .touchUpInside)
        closeConfirmButton.setTitle("Chiudi", for: .normal)
        closeConfirmButton.titleLabel?.font = UIFont(name: "System", size: 9)
        closeConfirmButton.layer.cornerRadius = 5.0
        closeConfirmButton.layer.borderWidth = 2.0
        closeConfirmButton.layer.borderColor = UIColor.secondaryBackground.cgColor
        closeConfirmButton.alpha = 0.0
        return closeConfirmButton
    
    }
    
    private func setUpActionsViewConfirmationLabel() -> UILabel{
        let label = UILabel.init(frame: CGRect(x: 10, y: 20, width: actionsView.frame.size.width - 20, height: 20))
        label.text =  "Documenti aggiunti ai preferiti!"
        label.textColor = UIColor.lightWhite
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        label.alpha = 0.0
        return label
    }
    
    
    private func setUpActionsViewCheersLabel() -> UILabel{
        let label = UILabel.init(frame: CGRect(x: 10 , y: 45, width: actionsView.frame.size.width - 20, height: 20))
        label.text = "Troverai i documenti nella sezione \"Documenti\" "
        label.textColor = UIColor.lightGray
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .center
        label.alpha = 0.0
        return label
    }
    
    func setupActionViewForFavouriteAddingConfirm(){
        //setUpActionsViewLayout()
         for sv in self.actionsView.subviews{
            UIView.animate(withDuration: 0.3, animations: {
                sv.alpha = 0.0
                
            }) { (flag) in
                sv.removeFromSuperview()
            }
        }
        let actionsViewConfirmationLabel = setUpActionsViewConfirmationLabel()
        let actionsViewCheersLabel = setUpActionsViewCheersLabel()
        let closeActionsViewButton = setUpCloseConfirmActionButton()
        actionsViewConfirmationLabel.alpha = 0.0
        actionsViewCheersLabel.alpha = 0.0
        closeActionsViewButton.alpha = 0.0
        self.actionsView.addSubview(actionsViewConfirmationLabel)
        self.actionsView.addSubview(actionsViewCheersLabel)
        self.actionsView.addSubview(closeActionsViewButton)
        UIView.animate(withDuration: 0.3) {
            actionsViewConfirmationLabel.alpha = 1.0
            actionsViewCheersLabel.alpha = 1.0
            closeActionsViewButton.alpha = 1.0
        }
        
    }
    @objc func addToSelectedDocumentsToFavourite(){
        let permanentFS = PermanentDocSystem.getUniqueIstance()
        let thisCourseFolder = Doc.init(title: thisTeaching.name , path: "/"+thisTeaching.name, type: "folder",courseID: thisTeaching.code)
        let appendedFolder = permanentFS.appendChild(toDoc: permanentFS.root, child: thisCourseFolder)
        permanentFS.appendChilds(toDoc: appendedFolder, childs: selectionList)
        //closeActionsView()
        setupActionViewForFavouriteAddingConfirm()
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
