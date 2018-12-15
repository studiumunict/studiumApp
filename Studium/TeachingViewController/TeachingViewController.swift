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
    
    @IBOutlet weak var syllabusButtonView: UIView!
    @IBOutlet var syllabusButton: UIButton!
    @IBOutlet var syllabusLabel: UILabel!
    
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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        completeTeachingDataSource()
        
        viewControllerList = {
            let sb = storyboard!
            let vc1 = sb.instantiateViewController(withIdentifier: "showcasePageViewController") as! ShowcasePageViewController
            let vc2 = sb.instantiateViewController(withIdentifier: "notifyPageViewController") as! NotifyPageViewController
            let vc3 = sb.instantiateViewController(withIdentifier: "syllabusPageViewController") as! SyllabusPageViewController
            let vc4 = sb.instantiateViewController(withIdentifier: "descriptionPageViewController") as! DescriptionPageViewController
            let vc5 = sb.instantiateViewController(withIdentifier: "documentsPageViewController") as! DocumentsPageViewController
            let vc6 = sb.instantiateViewController(withIdentifier: "bookingPageViewController") as! BookingPageViewController
            
            vc1.haveShowcase = teachingDataSource.haveShowcase
            vc2.notifyList = teachingDataSource.notifyList
            vc4.descriptionText = teachingDataSource.descriptionText
            vc5.haveDocuments = teachingDataSource.haveDocuments
            vc6.haveBooking = teachingDataSource.haveBooking
            
            return [vc1, vc2, vc3, vc4, vc5, vc6]
        }()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        setPageViewController()
        
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
    
        
        showcaseButtonView.backgroundColor = UIColor.buttonSelected
        
        showcaseButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sendToShowcaseView(_:))))
        notifyButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sendToNotifyView(_:))))
        syllabusButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sendToSyllabusView(_:))))
        descriptionButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sendToDescriptionView(_:))))
        documentsButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sendToDocumentsView(_:))))
        bookingButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sendToBookingView(_:))))
        
        if teachingDataSource.notifyList.isEmpty {
            customButtons(button: notifyButton, image: "markedBell")
        } else {
            customButtons(button: notifyButton, image: "bell")
        }
        customButtons(button: syllabusButton, image: "description") //da cambiare img
        customButtons(button: showcaseButton, image: "showcase")
        customButtons(button: descriptionButton, image: "description")
        customButtons(button: documentsButton, image: "folder")
        customButtons(button: bookingButton, image: "booking")
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
            viewControllerList[0].view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
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
            
        case is SyllabusPageViewController:
            syllabusButtonView.backgroundColor = UIColor.buttonSelected
            
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
        teachingDataSource.completeDataSource(haveShowcase: true, haveSyllabus: false, haveDocuments: false, haveBooking: false, descriptionText: "ciao")
        
        teachingDataSource.addNewNotify(date: "30/10/2018", title: "Date esami", message: "Giorno 2 novembre ci sarà la prima prova scritta.")
        teachingDataSource.addNewNotify(date: "25/11/2018", title: "Lezione rimandata", message: "Si avvisano gli studenti che giorno 26 novembre non ci sarà lezione.")
        teachingDataSource.addNewNotify(date: "05/12/2018", title: "Risultati della prova in itinere", message: "Tutti promossi. :)")
        
        courseNameLabel.text = teachingDataSource.name
        nameTeacherLabel.text = teachingDataSource.teacherName
    }
    
    func setPageViewController() {
        var i: Int
        
        if teachingDataSource.haveShowcase == nil || !teachingDataSource.haveShowcase {
            showcaseButtonView.isHidden = true
            i = 0
            for x in viewControllerList {
                if x is ShowcasePageViewController {
                    viewControllerList.remove(at: i)
                    break
                }
                i += 1
            }
        }
        
        if teachingDataSource.notifyList.isEmpty {
            notifyButtonView.isHidden = true
            i = 0
            for x in viewControllerList {
                if x is NotifyPageViewController {
                    viewControllerList.remove(at: i)
                    break
                }
                i += 1
            }
        }
        
        if teachingDataSource.haveSyllabus == nil || !teachingDataSource.haveSyllabus {
            syllabusButtonView.isHidden = true
            i = 0
            for x in viewControllerList {
                if x is SyllabusPageViewController {
                    viewControllerList.remove(at: i)
                    break
                }
                i += 1
            }
        }
        
        if teachingDataSource.descriptionText == nil || teachingDataSource.descriptionText.isEmpty {
            descriptionButtonView.isHidden = true
            i = 0
            for x in viewControllerList {
                if x is DescriptionPageViewController {
                    viewControllerList.remove(at: i)
                    break
                }
                i += 1
            }
        }
        
        if teachingDataSource.haveDocuments == nil || !teachingDataSource.haveDocuments {
            documentsButtonView.isHidden = true
            i = 0
            for x in viewControllerList {
                if x is DocumentsPageViewController {
                    viewControllerList.remove(at: i)
                    break
                }
                i += 1
            }
        }
        
        if teachingDataSource.haveBooking == nil || !teachingDataSource.haveBooking {
            bookingButtonView.isHidden = true
            i = 0
            for x in viewControllerList {
                if x is BookingPageViewController {
                    viewControllerList.remove(at: i)
                    break
                }
                i += 1
            }
        }
        
        switch viewControllerList.count {
        
        case 2:
            for x in stackView.subviews {
                stackView.addConstraint(x.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5, constant: 0))
            }
        
        case 3:
            for x in stackView.subviews {
                stackView.addConstraint(x.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1/3, constant: 0))
            }
            
        case 4:
            for x in stackView.subviews {
                stackView.addConstraint(x.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.25, constant: 0))
            }
            
        case 5:
            for x in stackView.subviews {
                stackView.addConstraint(x.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.2, constant: 0))
            }
            
        case 6:
            for x in stackView.subviews {
                stackView.addConstraint(x.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1/6, constant: 0))
            }
            
        case 7:
            for x in stackView.subviews {
                stackView.addConstraint(x.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1/7, constant: 0))
            }
        
        default:
            break
        }
    }
    
    
    
    func setAllButtonsViewWithClearBackgroundColor(){
        showcaseButtonView.backgroundColor = UIColor.clear
        notifyButtonView.backgroundColor = UIColor.clear
        syllabusButtonView.backgroundColor = UIColor.clear
        descriptionButtonView.backgroundColor = UIColor.clear
        documentsButtonView.backgroundColor = UIColor.clear
        bookingButtonView.backgroundColor = UIColor.clear
    }
    
    
    func customButtons(button: UIButton!, image: String!){
        let customImageView = UIImageView(frame: CGRect(x: button.frame.size.width/2 - 16, y: button.frame.size.height/2 - 15, width: 32, height: 30))
        customImageView.image = UIImage(named: image!)
        button.addSubview(customImageView)
    }
    

    
    
    @objc func sendToShowcaseView(_ sender: UIButton) {
        var i = 0
        for x in viewControllerList {
            if x is ShowcasePageViewController { break }
            i += 1
        }
        pageViewController.setViewControllers([viewControllerList[i]], direction: .forward, animated: false, completion: nil)
        setAllButtonsViewWithClearBackgroundColor()
        showcaseButtonView.backgroundColor = UIColor.buttonSelected
    }
    
    @objc func sendToNotifyView(_ sender: UIButton) {
        var i = 0
        for x in viewControllerList {
            if x is NotifyPageViewController { break }
            i += 1
        }
        pageViewController.setViewControllers([viewControllerList[i]], direction: .forward, animated: false, completion: nil)
        setAllButtonsViewWithClearBackgroundColor()
        notifyButtonView.backgroundColor = UIColor.buttonSelected
    }
    
    @objc func sendToSyllabusView(_ sender: UIButton) {
        var i = 0
        for x in viewControllerList {
            if x is SyllabusPageViewController { break }
            i += 1
        }
        pageViewController.setViewControllers([viewControllerList[i]], direction: .forward, animated: false, completion: nil)
        setAllButtonsViewWithClearBackgroundColor()
        syllabusButtonView.backgroundColor = UIColor.buttonSelected
    }
    
    @objc func sendToDescriptionView(_ sender: UIButton) {
        var i = 0
        for x in viewControllerList {
            if x is DescriptionPageViewController { break }
            i += 1
        }
        pageViewController.setViewControllers([viewControllerList[i]], direction: .forward, animated: false, completion: nil)
        setAllButtonsViewWithClearBackgroundColor()
        descriptionButtonView.backgroundColor = UIColor.buttonSelected
    }
    
    @objc func sendToDocumentsView(_ sender: UIButton) {
        var i = 0
        for x in viewControllerList {
            if x is DocumentsPageViewController { break }
            i += 1
        }
        pageViewController.setViewControllers([viewControllerList[i]], direction: .forward, animated: false, completion: nil)
        setAllButtonsViewWithClearBackgroundColor()
        documentsButtonView.backgroundColor = UIColor.buttonSelected
    }
    
    @objc func sendToBookingView(_ sender: UIButton) {
        var i = 0
        for x in viewControllerList {
            if x is BookingPageViewController { break }
            i += 1
        }
        pageViewController.setViewControllers([viewControllerList[i]], direction: .forward, animated: false, completion: nil)
        setAllButtonsViewWithClearBackgroundColor()
        bookingButtonView.backgroundColor = UIColor.buttonSelected
    }

}
