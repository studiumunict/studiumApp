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
          errorInfoDescriptionTextView.text = ""
    }
    override func showError() {
        errorMessageLabel.isHidden = false
    }
    override func loadDocumentsList() {
        //DO NOTHING.
        //il metodo non fa nulla perchè il chiamante ha già settato i documenti.
        print("Error: documenti già impostati dal chiamante")
    }
    
  
    
    
}
