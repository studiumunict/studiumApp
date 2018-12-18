//
//  PortaleStudentiViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 18/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit
import WebKit

class PortaleStudentiViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var errorMessageLabel: UILabel!
    @IBOutlet var webView: WKWebView!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var viewAppoggio: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var forwardButton: UIButton!
    
  //  var isLoaded: Bool = false
    
    //let reachability = Reachability()!
    
    /*
    deinit {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightWhite
        self.view.layer.borderColor = UIColor.primaryBackground.cgColor
        self.view.layer.borderWidth = 0.5
        
        viewAppoggio.backgroundColor = UIColor.lightWhite
        viewAppoggio.layer.borderWidth = 0.4
        viewAppoggio.layer.borderColor = UIColor.primaryBackground.cgColor
        
        customButtons(button: backButton, image: "arrow", rotazione: (.pi)/2)
        customButtons(button: forwardButton, image: "arrow", rotazione: 3*(.pi)/2)
        
        webView.navigationDelegate = self
        
        let webViewKeyPathsToObserve = ["loading", "estimatedProgress"]
        for keyPath in webViewKeyPathsToObserve {
            webView.addObserver(self, forKeyPath: keyPath, options: .new, context: nil)
        }
        
        webView.load(URLRequest(url: URL(string: "https://google.com")!))
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      /*
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
        */
    }
    
    
    /*
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        
        if reachability.connection == .none {
            if isLoaded {
                webView.isHidden = false
                viewAppoggio.isHidden = false
                errorMessageLabel.isHidden = true
            } else {
                webView.isHidden = true
                viewAppoggio.isHidden = true
                errorMessageLabel.isHidden = false
                errorMessageLabel.text = "La connessione ad Internet sembra essere offline."
            }
            
        } else {
            webView.isHidden = false
            viewAppoggio.isHidden = false
            errorMessageLabel.isHidden = true
            
            if !isLoaded {
                webView.load(URLRequest(url: URL(string: "https://portalestudente.unict.it/portalestudente")!))
            }
        }
        
    }
    */
    
    private func customButtons(button: UIButton!, image: String!, rotazione: CGFloat!){
        let customImageView = UIImageView(frame: CGRect(x: button.frame.size.width/2 - 16, y: button.frame.size.height/2 - 10, width: 22, height: 22))
        customImageView.image = UIImage(named: image!)?.withRenderingMode(.alwaysTemplate)
        customImageView.tintColor = UIColor.navigationBarColor
        customImageView.transform = CGAffineTransform(rotationAngle: rotazione)
        
        button.addSubview(customImageView)
    }
    
    
    private func setBackForwardButton(button: UIButton, flag: Bool) {
        button.isEnabled = flag
        button.alpha = flag == true ? 1 : 0.3
    }
    
    
    
    
    
    
    
    // MARK: WebView
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case "estimatedProgress":
            progressBar.isHidden = webView.estimatedProgress == 1
            progressBar.setProgress(Float(webView.estimatedProgress), animated: true)
            
        case "loading":
            setBackForwardButton(button: backButton, flag: webView.canGoBack)
            setBackForwardButton(button: forwardButton, flag: webView.canGoForward)
            
        default:
            break
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("\n\n didFailLoadWithError, error: ", error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("\n\n didFinish")
      //  isLoaded = true
    }
    
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        print("backButton Pressed")
        webView.goBack()
    }
    
    @IBAction func forwardButtonPressed(_ sender: UIButton) {
        print("forwardButton Pressed")
        webView.goForward()
    }
    

}
