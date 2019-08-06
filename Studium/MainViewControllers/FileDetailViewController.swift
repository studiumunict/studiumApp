//
//  FileDetailViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 06/08/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import UIKit
import WebKit

class FileDetailViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var webView: WKWebView!
    
    var file: Docs!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("entro in fileDetail con \((file.path)!)")
        
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        /*let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "Website")!
        webView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        webView.load(request)*/
        
        webView.load(URLRequest(url: URL(fileURLWithPath: file.path)))
        webView.allowsBackForwardNavigationGestures = false
        
    }
    
    
    

}
