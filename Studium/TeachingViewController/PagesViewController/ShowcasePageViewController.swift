//
//  ShowcasePageViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 10/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit
import WebKit

class ShowcasePageViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var errorMessageLabel: UILabel!
    @IBOutlet var webView: WKWebView!
    @IBOutlet var progressBar: UIProgressView!
    var isFirstController = false
    var showcaseHTML: String!
    var isLoaded: Bool = false
    
    let reachability = Reachability()!
    
    
    deinit {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightWhite
        self.view.layer.borderColor = UIColor.primaryBackground.cgColor
        self.view.layer.borderWidth = 0.5
        
        webView.navigationDelegate = self
        
        let webViewKeyPathsToObserve = ["loading", "estimatedProgress"]
        for keyPath in webViewKeyPathsToObserve {
            webView.addObserver(self, forKeyPath: keyPath, options: .new, context: nil)
        }
        
        
        if showcaseHTML != nil {
            webView.loadHTMLString(showcaseHTML!, baseURL: nil)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
        
    }
    
    
    
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        
        if reachability.connection == .none {
            if isLoaded {
                webView.isHidden = false
                errorMessageLabel.isHidden = true
            } else {
                webView.isHidden = true
                errorMessageLabel.isHidden = false
                errorMessageLabel.text = "La connessione ad Internet sembra essere offline."
            }
            
        } else {
            webView.isHidden = false
            errorMessageLabel.isHidden = true
            
            if !isLoaded {
                if showcaseHTML != nil {
                    webView.loadHTMLString(showcaseHTML!, baseURL: nil)
                }
            }
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressBar.isHidden = webView.estimatedProgress == 1
            progressBar.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }

    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("\n\n didFinish")
        isLoaded = true
    }
    
    
    
    
}
