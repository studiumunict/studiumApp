//
//  SyllabusPageViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 14/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit
import WebKit

class SyllabusPageViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate {

    @IBOutlet var errorMessageLabel: UILabel!
    @IBOutlet var webView: WKWebView!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var viewAppoggio: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var forwardButton: UIButton!
    
    var syllabusCode: String!
    var isLoaded: Bool = false
 
    
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
        webView.scrollView.delegate = self
        
        let webViewKeyPathsToObserve = ["loading", "estimatedProgress"]
        for keyPath in webViewKeyPathsToObserve {
            webView.addObserver(self, forKeyPath: keyPath, options: .new, context: nil)
        }
        
        
        if syllabusCode != nil {
            webView.load(URLRequest(url: URL(string: "https://syllabus.unict.it/insegnamento.php?mod=" + syllabusCode!)!))
           // print("CARICO SYLLABUS: ", syllabusCode!)
        }
        
    }
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x > 0){
            scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
        }
    }
   
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
    
    
    func webView(_ webView: WKWebView, didFailLoadWithError error: Error) {
        print("\n\n didFailLoadWithError, error: ", error.localizedDescription)
        self.webView.scrollView.showsHorizontalScrollIndicator = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       // print("\n\n didFinish")
        
        isLoaded = true
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
       // print("\n\n webViewWebContentProcessDidTerminate")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        //print("\n\n didfail, error: ", error.localizedDescription )
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        //print("\n\n didFailProvisionalNavigation, error: ", error.localizedDescription)
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        //print("backButton Pressed")
        webView.goBack()
    }
    
    @IBAction func forwardButtonPressed(_ sender: UIButton) {
       // print("forwardButton Pressed")
        webView.goForward()
    }
    
}
