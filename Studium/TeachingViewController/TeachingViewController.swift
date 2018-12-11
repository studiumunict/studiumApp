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
        
        //completeTeachingDataSource() //Inizializza i nuovi dati del teachingDataSource scaricandoli dal db
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
            
            //passare i valori. ES:
            vc3.descriptionText = teachingDataSource.descriptionText
            
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
        
        self.view.backgroundColor = UIColor.primaryBackground
        
        courseNameLabel.backgroundColor = UIColor.primaryBackground
        courseNameLabel.textColor = UIColor.lightWhite
        nameTeacherLabel.backgroundColor = UIColor.primaryBackground
        nameTeacherLabel.textColor = UIColor.lightWhite
        
        
        //setAllButtonsViewWithPrimaryBackgroundColor()
        showcaseButtonView.backgroundColor = UIColor.secondaryBackground
        
        
        //Cambiare l'immagine per i vari bottoni
        customButtons(button: showcaseButton, image: "home")
        customButtons(button: notifyButton, image: "avv")
        customButtons(button: descriptionButton, image: "descr")
        customButtons(button: documentsButton, image: "folder")
        customButtons(button: bookingButton, image: "courses")
        
        
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
        
        setAllButtonsViewWithPrimaryBackgroundColor()
        
        switch vc {
        case is ShowcasePageViewController:
            showcaseButtonView.backgroundColor = UIColor.secondaryBackground
            if revealViewController() != nil {
                vc.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            }
            
        case is NotifyPageViewController:
            notifyButtonView.backgroundColor = UIColor.secondaryBackground
            
        case is DescriptionPageViewController:
            descriptionButtonView.backgroundColor = UIColor.secondaryBackground
            
        case is DocumentsPageViewController:
            documentsButtonView.backgroundColor = UIColor.secondaryBackground
            
        case is BookingPageViewController:
            bookingButtonView.backgroundColor = UIColor.secondaryBackground
            
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
    
    
    
    func completeTeachingDataSource(){ //Scarica i dati dal db
        teachingDataSource.completeDataSource(haveShowcase: nil, haveDocuments: nil, haveBooking: nil, descriptionText: "ciao")
        
        courseNameLabel.text = teachingDataSource.name
        nameTeacherLabel.text = teachingDataSource.teacherName
        
        if teachingDataSource.signedUp! {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "star_full")?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "star_empty")?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
        }
        /*
        if teachingDataSource.haveShowcase != nil && teachingDataSource.haveShowcase {
            vc1.errorMessageLabel.isHidden = true
            vc1.loadingIndicator.isHidden = true
        } else {
            vc1.errorMessageLabel.isHidden = false
        }
        
        if let val = teachingDataSource.descriptionText {
            vc3.descriptionTextView.text = val
        } else {
            vc3.descriptionTextView.text = "Nessuna descrizione per questo insegnamento."
        }*/
    
    }
    
    
    
    func setAllButtonsViewWithPrimaryBackgroundColor(){
        showcaseButtonView.backgroundColor = UIColor.primaryBackground
        notifyButtonView.backgroundColor = UIColor.primaryBackground
        descriptionButtonView.backgroundColor = UIColor.primaryBackground
        documentsButtonView.backgroundColor = UIColor.primaryBackground
        bookingButtonView.backgroundColor = UIColor.primaryBackground
    }
    
    
    func customButtons(button: UIButton!, image: String!){
        let customImageView = UIImageView(frame: CGRect(x: 8, y: 5, width: 40, height: 35))
        customImageView.image = UIImage(named: image!)
        button.addSubview(customImageView)
    }
    
    
    
    @IBAction func sendToShowcaseView(_ sender: UIButton) {
        pageViewController.setViewControllers([viewControllerList[0]], direction: .forward, animated: false, completion: nil)
        setAllButtonsViewWithPrimaryBackgroundColor()
        showcaseButtonView.backgroundColor = UIColor.secondaryBackground
    }
    
    @IBAction func sendToNotifyView(_ sender: UIButton) {
        pageViewController.setViewControllers([viewControllerList[1]], direction: .forward, animated: false, completion: nil)
        setAllButtonsViewWithPrimaryBackgroundColor()
        notifyButtonView.backgroundColor = UIColor.secondaryBackground
    }
    
    @IBAction func sendToDescriptionView(_ sender: UIButton) {
        pageViewController.setViewControllers([viewControllerList[2]], direction: .forward, animated: false, completion: nil)
        setAllButtonsViewWithPrimaryBackgroundColor()
        descriptionButtonView.backgroundColor = UIColor.secondaryBackground
    }
    
    @IBAction func sendToDocumentsView(_ sender: UIButton) {
        pageViewController.setViewControllers([viewControllerList[3]], direction: .forward, animated: false, completion: nil)
        setAllButtonsViewWithPrimaryBackgroundColor()
        documentsButtonView.backgroundColor = UIColor.secondaryBackground
    }
    
    @IBAction func sendToBookingView(_ sender: UIButton) {
        pageViewController.setViewControllers([viewControllerList[4]], direction: .forward, animated: false, completion: nil)
        setAllButtonsViewWithPrimaryBackgroundColor()
        bookingButtonView.backgroundColor = UIColor.secondaryBackground
    }

}
