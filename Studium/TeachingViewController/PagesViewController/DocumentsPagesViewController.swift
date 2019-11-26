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
        let CV = ConfirmView.getUniqueIstance()
        let actionsViewLabel = setUpActionsViewLabel()
        let addFavouriteButton = setUpAddInFavouriteActionButton()
        let cancelButton = setUpCancelActionButton()
        self.actionsView = CV.getView(titleLabel: actionsViewLabel, buttons: [addFavouriteButton,cancelButton])
        self.view.addSubview(actionsView)
    }
    override func disableControllerInteraction() {
        collectionView.allowsSelection = false
        teachingController.navigationController?.navigationBar.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = false
        self.teachingController.view.isUserInteractionEnabled = false
    }
    override func enableControllerInteraction() {
        collectionView.allowsSelection = true
        teachingController.navigationController?.navigationBar.isUserInteractionEnabled = true
        self.view.isUserInteractionEnabled = true
        self.teachingController.view.isUserInteractionEnabled = true
    }
    private func setUpCloseConfirmActionButton() -> UIButton{
        let CV = ConfirmView.getUniqueIstance()
        return CV.getButton(position: .alone, title: "Chiudi", selector: #selector(closeActionsView), target: self)
    }
    
    private func setUpActionsViewConfirmationLabel() -> UILabel{
        let CV = ConfirmView.getUniqueIstance()
        return CV.getTitleLabel(text: "Documenti aggiunti ai preferiti!")
    }
    
    private func setUpActionsViewCheersLabel() -> UILabel{
        let CV = ConfirmView.getUniqueIstance()
        return CV.getDescriptionLabel(text: "Troverai i documenti nella sezione \"Documenti\" ")
    }
    
    func setupActionViewForFavouriteAddingConfirm(){
        let CV = ConfirmView.getUniqueIstance()
        let actionsViewConfirmationLabel = setUpActionsViewConfirmationLabel()
        let actionsViewCheersLabel = setUpActionsViewCheersLabel()
        let closeActionsViewButton = setUpCloseConfirmActionButton()
        CV.updateView(confirmView: &self.actionsView, titleLabel: actionsViewConfirmationLabel, descLabel: actionsViewCheersLabel, buttons: [closeActionsViewButton], dataToAttach: nil, animated: true)
    }
    @objc func addSelectedDocumentsToFavourite(){
        let permanentFS = PermanentDocSystem.getUniqueIstance()
        let thisCourseFolder = Doc.init(title: thisTeaching.name , path: "/"+thisTeaching.name, type: "folder",courseID: thisTeaching.code)
        let appendedFolder = permanentFS.appendChild(toDoc: permanentFS.root, child: thisCourseFolder)
        permanentFS.appendChilds(toDoc: appendedFolder, childs: selectionList)
        setupActionViewForFavouriteAddingConfirm()
    }
    private func setUpAddInFavouriteActionButton()-> UIButton{
        let CV = ConfirmView.getUniqueIstance()
        return CV.getButton(position: .centerTopRounded, dataToAttach: nil, title: "Aggiungi ai preferiti", selector: #selector(addSelectedDocumentsToFavourite), target: self)
    }

}
