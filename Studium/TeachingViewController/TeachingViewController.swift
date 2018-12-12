//
//  TeachingViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 24/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class TeachingViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, SWRevealViewControllerDelegate {

    
    @IBOutlet var viewAppoggio: UIView! //Contiene la scrollView
    @IBOutlet var stackView: UIStackView!
    
    @IBOutlet var rightMenuView: UIView!
    @IBOutlet var signedUpButton: UIButton!
    @IBOutlet var signedUpLabel: UILabel!
    
    @IBOutlet var courseNameLabel: UILabel!
    @IBOutlet var nameTeacherLabel: UILabel!
    
    // --- MARK: Stack View ---
    @IBOutlet weak var showcaseButtonView: UIView!
    @IBOutlet var showcaseButton: UIButton!
    @IBOutlet var showcaseLabel: UILabel!
    
    @IBOutlet weak var notifyButtonView: UIView!
    @IBOutlet var notifyButton: UIButton!
    @IBOutlet var notifyLabel: UILabel!
    
    @IBOutlet weak var descriptionButtonView: UIView!
    @IBOutlet var descriptionButton: UIButton!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet weak var documentsButtonView: UIView!
    @IBOutlet var documentsButton: UIButton!
    @IBOutlet var documentsLabel: UILabel!
    
    @IBOutlet weak var bookingButtonView: UIView!
    @IBOutlet var bookingButton: UIButton!
    @IBOutlet var bookingLabel: UILabel!
    
    // --- MARK: Variables ---
    var teachingDataSource: Teaching! //Pre inizializzato solo con: name, code, teacherName, signedUp
    let pageViewController: UIPageViewController!  = UIPageViewController(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
    lazy var viewControllerList: [UIViewController]! = { return nil }()
    
    
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
            viewControllerList[0].view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        completeTeachingDataSource()
        
        viewControllerList = {
            let sb = storyboard!
            let vc1 = sb.instantiateViewController(withIdentifier: "showcasePageViewController") as! ShowcasePageViewController
            let vc2 = sb.instantiateViewController(withIdentifier: "notifyPageViewController") as! NotifyPageViewController
            let vc3 = sb.instantiateViewController(withIdentifier: "descriptionPageViewController") as! DescriptionPageViewController
            let vc4 = sb.instantiateViewController(withIdentifier: "documentsPageViewController") as! DocumentsPageViewController
            let vc5 = sb.instantiateViewController(withIdentifier: "bookingPageViewController") as! BookingPageViewController
            
            vc1.haveShowcase = teachingDataSource.haveShowcase
            vc2.notifyList = teachingDataSource.notifyList
            vc3.descriptionText = teachingDataSource.descriptionText
            vc4.haveDocuments = teachingDataSource.haveDocuments
            vc5.haveBooking = teachingDataSource.haveBooking
            
            return [vc1, vc2, vc3, vc4, vc5]
        }()
        
        //Definire le dimensioni dei menu
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130//Menu sx/
            revealViewController().delegate = self
            viewControllerList[0].view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        
        viewAppoggio.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height - (stackView.frame.height + courseNameLabel.frame.height + nameTeacherLabel.frame.height)) //definisco le dimensioni reali e di autolayout per la scrollView
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        pageViewController.view.frame = CGRect(x: 0.0, y: 0.0, width: viewAppoggio.frame.width, height: viewAppoggio.frame.height)
        
        viewAppoggio.addSubview(pageViewController.view)
        
        if let fisrtViewController = viewControllerList.first {
           pageViewController.setViewControllers([fisrtViewController], direction: .forward, animated: true, completion: nil)
        }
        
        navigationItem.title = "Insegnamento"
        navigationController?.view.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.secondaryBackground, thickness: 0.3)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        imageView.image = UIImage.init(named: "menu")
        let buttonView = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        buttonView.addSubview(imageView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: buttonView)
        self.navigationItem.rightBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.signedUpClicked)))
        
        rightMenuView.backgroundColor = UIColor.primaryBackground
        rightMenuView.isHidden = true
        
        signedUpButton.layer.cornerRadius = 7.0
        signedUpButton.clipsToBounds = true
        signedUpButton.layer.borderWidth = 3.0
        signedUpButton.layer.borderColor = UIColor.secondaryBackground.cgColor
        signedUpButton.titleLabel?.textAlignment = .center
        
        signedUpLabel.layer.cornerRadius = 7.0
        signedUpLabel.clipsToBounds = true
        signedUpLabel.textAlignment = .center
        
        showcaseButtonView.backgroundColor = UIColor.buttonSelected
        
        if teachingDataSource.notifyList.isEmpty {
            customButtons(button: notifyButton, image: "markedBell")
        } else {
            customButtons(button: notifyButton, image: "bell")
        }
        customButtons(button: showcaseButton, image: "showcase")
        customButtons(button: descriptionButton, image: "description")
        customButtons(button: documentsButton, image: "folder")
        customButtons(button: bookingButton, image: "booking")
        
        stackView.layer.addBorder(edge: UIRectEdge.top, color: UIColor.secondaryBackground, thickness: 0.7)
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard viewControllerList.count > previousIndex else {
            return nil
        }
        
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = vcIndex + 1
        
        guard viewControllerList.count != nextIndex else {
            return nil
        }
        
        guard viewControllerList.count > nextIndex else {
            return nil
        }
        
        return viewControllerList[nextIndex]
    }
    

    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
    
        guard let vc = pageViewController.viewControllers?.first else { return }
        
        if revealViewController() != nil {
            vc.view.removeGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        setAllButtonsViewWithClearBackgroundColor()
        
        switch vc {
        case is ShowcasePageViewController:
            showcaseButtonView.backgroundColor = UIColor.buttonSelected
            if revealViewController() != nil {
                vc.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            }
            
        case is NotifyPageViewController:
            notifyButtonView.backgroundColor = UIColor.buttonSelected
            
        case is DescriptionPageViewController:
            descriptionButtonView.backgroundColor = UIColor.buttonSelected
            
        case is DocumentsPageViewController:
            documentsButtonView.backgroundColor = UIColor.buttonSelected
            
        case is BookingPageViewController:
            bookingButtonView.backgroundColor = UIColor.buttonSelected
            
        default:
            break
        }
    }
    
   
    
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        switch position {
        case .right: //Uno dei due menu è aperto
            //scrollView.isScrollEnabled = false
            stackView.isUserInteractionEnabled = false
            self.navigationController?.navigationBar.isUserInteractionEnabled = false
            
        case .left: //Tutti i menu sono chiusi
            //scrollView.isScrollEnabled = true
            stackView.isUserInteractionEnabled = true
            self.navigationController?.navigationBar.isUserInteractionEnabled = true
            
        default:
            break
        }
    }
    
    
    
    func completeTeachingDataSource(){
        //Scarica i dati dal db
        teachingDataSource.completeDataSource(haveShowcase: nil, haveDocuments: nil, haveBooking: nil, descriptionText: nil)
        
        teachingDataSource.addNewNotify(date: "30/10/2018", title: "Date esami", message: "Giorno 2 novembre ci sarà la prima prova scritta.")
        teachingDataSource.addNewNotify(date: "25/11/2018", title: "Lezione rimandata", message: "Si avvisano gli studenti che giorno 26 novembre non ci sarà lezione.")
        teachingDataSource.addNewNotify(date: "05/12/2018", title: "Risultati della prova in itinere", message: "Tutti promossi. :)")
        
        courseNameLabel.text = teachingDataSource.name
        nameTeacherLabel.text = teachingDataSource.teacherName
    }
    
    
    
    func setAllButtonsViewWithClearBackgroundColor(){
        showcaseButtonView.backgroundColor = UIColor.clear
        notifyButtonView.backgroundColor = UIColor.clear
        descriptionButtonView.backgroundColor = UIColor.clear
        documentsButtonView.backgroundColor = UIColor.clear
        bookingButtonView.backgroundColor = UIColor.clear
    }
    
    
    func customButtons(button: UIButton!, image: String!){
        let customImageView = UIImageView(frame: CGRect(x: button.frame.size.width/2 - 16, y: button.frame.size.height/2 - 15, width: 32, height: 30))
        customImageView.image = UIImage(named: image!)
        button.addSubview(customImageView)
    }
    
    
    @objc func signedUpClicked() {
        if rightMenuView.isHidden {
            reloadSignedUpView()
            rightMenuView.isHidden = false
        } else {
            rightMenuView.isHidden = true
        }
    }
    
    @IBAction func signedUpButtonClicked(_ sender: UIButton) {
        if teachingDataSource.signedUp {
            teachingDataSource.signedUp = false
            reloadSignedUpView()
        } else {
            teachingDataSource.signedUp = true
            reloadSignedUpView()
        }
    }
    
    func reloadSignedUpView() {
        if teachingDataSource.signedUp {
            signedUpLabel.text = "Sei iscritto."
            signedUpButton.titleLabel?.text = "Disiscriviti"
        } else {
            signedUpLabel.text = "Non risulti iscritto."
            signedUpButton.titleLabel?.text = "Iscriviti"
        }
    }
    
    
    @IBAction func sendToShowcaseView(_ sender: UIButton) {
        pageViewController.setViewControllers([viewControllerList[0]], direction: .forward, animated: false, completion: nil)
        setAllButtonsViewWithClearBackgroundColor()
        showcaseButtonView.backgroundColor = UIColor.buttonSelected
    }
    
    @IBAction func sendToNotifyView(_ sender: UIButton) {
        pageViewController.setViewControllers([viewControllerList[1]], direction: .forward, animated: false, completion: nil)
        setAllButtonsViewWithClearBackgroundColor()
        notifyButtonView.backgroundColor = UIColor.buttonSelected
    }
    
    @IBAction func sendToDescriptionView(_ sender: UIButton) {
        pageViewController.setViewControllers([viewControllerList[2]], direction: .forward, animated: false, completion: nil)
        setAllButtonsViewWithClearBackgroundColor()
        descriptionButtonView.backgroundColor = UIColor.buttonSelected
    }
    
    @IBAction func sendToDocumentsView(_ sender: UIButton) {
        pageViewController.setViewControllers([viewControllerList[3]], direction: .forward, animated: false, completion: nil)
        setAllButtonsViewWithClearBackgroundColor()
        documentsButtonView.backgroundColor = UIColor.buttonSelected
    }
    
    @IBAction func sendToBookingView(_ sender: UIButton) {
        pageViewController.setViewControllers([viewControllerList[4]], direction: .forward, animated: false, completion: nil)
        setAllButtonsViewWithClearBackgroundColor()
        bookingButtonView.backgroundColor = UIColor.buttonSelected
    }

}
