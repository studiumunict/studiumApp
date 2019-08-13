//
//  DocumentBrowserViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 13/08/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import UIKit

class DocumentBrowserViewController: UIViewController, UIDocumentInteractionControllerDelegate {

    var documentController = UIDocumentInteractionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func openFile() {
        documentController.delegate = self
        documentController.presentPreview(animated: false)
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        self.dismiss(animated: true, completion: nil)
    }

}
