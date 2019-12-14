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
    let urlHomepage = "https://studenti.smartedu.unict.it/Studenti/Default.aspx"
    var isLoaded: Bool = false
    var loggedIn = false
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarIcon()
        setupRevealControllerParameters()
        
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
        self.webView.load(URLRequest(url: URL(string: self.urlPortale)!))
        self.webView.isHidden = true
        self.homeButton.isEnabled = false
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

    fileprivate func setupRevealControllerParameters() {
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130//Menu sx/
            revealViewController().delegate = self
            self.navigationItem.leftBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))))
            webView.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
       
    fileprivate func setupNavBarIcon() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        imageView.image = UIImage.init(named: "menu")
        let buttonView = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        buttonView.addSubview(imageView)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: buttonView)
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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case "estimatedProgress":
            progressBar.isHidden = webView.estimatedProgress == 1
            progressBar.setProgress(Float(webView.estimatedProgress), animated: true)
            
        case "loading":
            let isInHomepage = webView.url?.absoluteString == urlHomepage
            setBackForwardButton(button: backButton, flag: webView.canGoBack && !isInHomepage )
            setBackForwardButton(button: forwardButton, flag: webView.canGoForward)
            
        case "title":
            if let str = webView.title {
                self.navigationItem.title = str
            }
            
        default:
            break
        }
    }
    
    func webView(_ webView: WKWebView, didFailLoadWithError error: Error) {
        print("\n\n didFailLoadWithError, error: ", error.localizedDescription)
    }
   
    private func autoLogin(){
        let studentCod = Session.getUniqueIstance().username
        let psw = PswEncryption.decode(str: Session.getUniqueIstance().encryptedPassword)
        let fillUsernameString = "document.getElementById('ctl01_contents_UserName').setAttribute('value','" + studentCod! + "');"
        let fillPasswordString = "document.getElementById('ctl01_contents_UserPassword').value = " + psw + ";"
        let clickButtonString = "document.getElementById('LogonButton').click()"
        let scriptStr = fillUsernameString + fillPasswordString + clickButtonString
        webView.evaluateJavaScript(scriptStr ) { (flag, Erorr) in
        }
    }
    
    private func showHomePage(){
        self.webView.isHidden = false
        self.homeButton.isEnabled = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if !isLoaded {
            autoLogin()
            isLoaded = true
            return
        }
        self.showHomePage()
        loggedIn = true
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        webView.goBack()
    }
    
    @IBAction func forwardButtonPressed(_ sender: UIButton) {
        webView.goForward()
    }
    
    @IBAction func homeButtonPressed(_ sender: UIButton) {
        webView.load(URLRequest(url: URL(string: urlHomepage)!))
    }

}
