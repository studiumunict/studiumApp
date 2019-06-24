//
//  PortaleStudentiViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 18/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit
import WebKit

class PortaleStudentiViewController: UIViewController, WKNavigationDelegate, SWRevealViewControllerDelegate {

    @IBOutlet var errorMessageLabel: UILabel!
    @IBOutlet var webView: WKWebView!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var viewAppoggio: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var forwardButton: UIButton!
    @IBOutlet var homeButton: UIButton!
    let urlPortale = "https://studenti.smartedu.unict.it/WorkFlow2011/Logon/Logon.aspx?ReturnUrl=%2f"
    
    var isLoaded: Bool = false
    
    let reachability = Reachability()!
    
    
    deinit {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        imageView.image = UIImage.init(named: "menu")
        var buttonView = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        buttonView.addSubview(imageView)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: buttonView)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 2.5, width: 25.5, height: 25))
        imageView.image = UIImage.init(named: "search") //Cambiare icona con una di 'reload'
        buttonView = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 27.5))
        buttonView.addSubview(imageView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: buttonView)
        self.navigationItem.rightBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.reloadWebView)))
        
        //Definire le dimensioni dei menu
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130//Menu sx/
            revealViewController().delegate = self
            self.navigationItem.leftBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))))
            webView.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        self.view.backgroundColor = UIColor.lightWhite
        self.view.layer.borderColor = UIColor.primaryBackground.cgColor
        self.view.layer.borderWidth = 0.5
        
        self.navigationItem.title = "Portale Studenti"
        
        viewAppoggio.backgroundColor = UIColor.lightWhite
        viewAppoggio.layer.borderWidth = 0.4
        viewAppoggio.layer.borderColor = UIColor.primaryBackground.cgColor
        
        customButtons(button: backButton, image: "arrow", rotazione: (.pi)/2 )
        
        customButtons(button: homeButton, image: "home", rotazione: nil)
        
        customButtons(button: forwardButton, image: "arrow", rotazione: 3*(.pi)/2 )
        
        webView.navigationDelegate = self
        
        let webViewKeyPathsToObserve = ["loading", "estimatedProgress", "title"]
        for keyPath in webViewKeyPathsToObserve {
            webView.addObserver(self, forKeyPath: keyPath, options: .new, context: nil)
        }
        
        webView.load(URLRequest(url: URL(string: urlPortale)!))
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        //Quando apre le view, se il menu' è aperto lo chiude
        if (revealViewController().frontViewPosition != FrontViewPosition.left) {
            revealViewController().frontViewPosition = .left
        }
        
        //Definire le dimensioni dei menu
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130//Menu sx
            revealViewController().delegate = self
            self.navigationItem.leftBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))))
            webView.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
      
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
        
    }
    
    
    
    
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        switch position {
        case .right: //Uno dei due menu è aperto
            webView.scrollView.isUserInteractionEnabled = false
            viewAppoggio.isUserInteractionEnabled = false
            
        case .left: //Tutti i menu sono chiusi
            webView.scrollView.isUserInteractionEnabled = true
            viewAppoggio.isUserInteractionEnabled = true
            
        default:
            break
        }
    }
    
    
    @objc func reloadWebView() {
        webView.reload()
    }
    
    
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
                webView.load(URLRequest(url: URL(string: urlPortale)!))
            }
        }
        
    }
    
    
    private func customButtons(button: UIButton!, image: String!, rotazione: CGFloat!){
        let customImageView = UIImageView(frame: CGRect(x: button.frame.size.width/2 - 16, y: button.frame.size.height/2 - 10, width: 22, height: 22))
        customImageView.image = UIImage(named: image!)?.withRenderingMode(.alwaysTemplate)
        customImageView.tintColor = UIColor.navigationBarColor
        
        if rotazione != nil {
            customImageView.transform = CGAffineTransform(rotationAngle: rotazione)
        }
        
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
            
        case "title":
            if let str = webView.title {
                self.navigationItem.title = str
            }
            
        default:
            break
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("\n\n didFailLoadWithError, error: ", error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("\n\n didFinish")
        isLoaded = true
    }
    
    
    
    
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        webView.goBack()
    }
    
    @IBAction func forwardButtonPressed(_ sender: UIButton) {
        webView.goForward()
    }
    
    @IBAction func homeButtonPressed(_ sender: UIButton) {
        webView.load(URLRequest(url: URL(string: urlPortale)!))
    }

}
