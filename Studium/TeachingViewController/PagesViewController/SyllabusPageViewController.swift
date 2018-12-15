//
//  SyllabusPageViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 14/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit
import WebKit

class SyllabusPageViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var errorMessageLabel: UILabel!
    @IBOutlet var webView: WKWebView!
    @IBOutlet var progressBar: UIProgressView!
    
    var syllabusCode: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightWhite
        self.view.layer.borderColor = UIColor.primaryBackground.cgColor
        self.view.layer.borderWidth = 0.5
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
         
        if syllabusCode != nil {
            if syllabusCode!.last == "/"  {
                syllabusCode!.removeLast()
            }
            
            webView.load(URLRequest(url: URL(string: "https://syllabus.unict.it/insegnamento.php?mod=" + syllabusCode!)!))
        }
        
    
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressBar.isHidden = webView.estimatedProgress == 1
            progressBar.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("\n\n [Error webView]:\n", error.localizedDescription)
    }
    
}
