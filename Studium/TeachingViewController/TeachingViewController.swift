//
//  TeachingViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 24/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class TeachingViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, SWRevealViewControllerDelegate {

    
    @IBOutlet weak var oscureLoadingView: UIView!
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
    weak var teachingDataSource: Teaching! //Pre inizializzato solo con: name, code, teacherName, signedUp
    
    let pageViewController: UIPageViewController!  = UIPageViewController(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
    lazy var viewControllerList: [UIViewController]! = { return nil }()
    
    
    
    func setOscureView(){
        
        oscureLoadingView.backgroundColor = UIColor.oscureColor
        oscureLoadingView.alpha = 1.0
        let spinner = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2 - 30, y: self.view.frame.height/2-200, width: 60, height: 60))
        oscureLoadingView.addSubview(spinner)
        if #available(iOS 13.0, *) {
            spinner.style = .large
        } else {
            // Fallback on earlier versions
        }
        spinner.startAnimating()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        courseNameLabel.text = teachingDataSource.name
        nameTeacherLabel.text = teachingDataSource.teacherName
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        //fai comparire una oscureView di Caricamento mentre vengono scaricati i dati
        self.setOscureView()
        self.oscureLoadingView.layer.zPosition = 2
      // self.oscureLoadingView.alpha = 0.8
        self.stackView.isHidden = true
        //let oscureView = createOscureView()
        //self.view.addSubview(oscureView)
        
        
        teachingDataSource.completeTeachingData { (flag) in
            self.istantiateViewControllers()
            self.stackView.translatesAutoresizingMaskIntoConstraints = false
            self.setPageViewController()
            self.pageViewController.dataSource = self
            self.pageViewController.delegate = self
            self.setPageControllerLayouts()
            self.setPanGestureOnFirstController()
            
            UIView.animate(withDuration: 0.5, animations: {
                self.oscureLoadingView.alpha = 0.0
            }) { (flag1) in
                self.oscureLoadingView.isHidden = true
            }
            //show stackView
            self.stackView.alpha = 0.0
            self.stackView.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.stackView.alpha = 1.0
            }
           
            
        }
    }
    
    private func setPanGestureOnFirstController(){
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130//Menu sx/
            revealViewController().delegate = self
            viewControllerList[0].view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
    private func istantiateViewControllers(){
        viewControllerList = {
            let sb = storyboard!
            let vc1 = sb.instantiateViewController(withIdentifier: "showcasePageViewController") as! ShowcasePageViewController
            let vc2 = sb.instantiateViewController(withIdentifier: "notifyPageViewController") as! NotifyPageViewController
            let vc3 = sb.instantiateViewController(withIdentifier: "syllabusPageViewController") as! SyllabusPageViewController
            let vc4 = sb.instantiateViewController(withIdentifier: "descriptionPageViewController") as! DescriptionPageViewController
            let vc5 = sb.instantiateViewController(withIdentifier: "documentsPageViewController") as! DocumentsPageViewController
            let vc6 = sb.instantiateViewController(withIdentifier: "bookingPageViewController") as! BookingPageViewController
            vc1.showcaseHTML = teachingDataSource.showcaseHTML
            vc2.notifyList = teachingDataSource.notifyList
            vc3.syllabusCode = teachingDataSource.syllabusCode
            vc4.descriptionText = teachingDataSource.descriptionText
            vc5.documentsList = teachingDataSource.documentsList
            vc6.haveBooking = teachingDataSource.haveBooking
            return [vc1, vc2, vc3, vc4, vc5, vc6]
        }()
    }
    private func setPageControllerLayouts(){
        viewAppoggio.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height - (stackView.frame.height + courseNameLabel.frame.height + nameTeacherLabel.frame.height)) //definisco le dimensioni reali e di autolayout per la scrollView
            
            pageViewController.view.frame = CGRect(x: 0.0, y: 0.0, width: viewAppoggio.frame.width, height: viewAppoggio.frame.height)
            viewAppoggio.addSubview(pageViewController.view)
            
            if let fisrtViewController = viewControllerList.first {
               pageViewController.setViewControllers([fisrtViewController], direction: .forward, animated: true, completion: nil)
            }
            
            navigationItem.title = "Insegnamento"
            navigationController?.view.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.secondaryBackground, thickness: 0.3)
        
            
            for x in stackView.subviews {
                if !x.isHidden {
                    x.backgroundColor = UIColor.buttonSelected
                    break
                }
            }
    }
    
    /*
    func completeTeachingDataSource(completion: @escaping (Any?)->Void){
        //Scarica i dati dal db riguardanti questo corso. Il codice del corso utile a scaricare dal db, lo prende dai dati stessi che sono già pre impostati sul teachingDataSource.
        //teachingDataSource.completeDataSource(showcaseHTML: nil, syllabusCode: "14927", haveBooking: false, descriptionText: nil)
        
        pullNotify()
        pullDescription()
        pullDocuments()
        
        
    }*/
    
    
    
    /*
    fileprivate func pullNotify() {
        let api =  BackendAPI.getUniqueIstance()
        api.getAvvisi(codCourse: teachingDataSource.code) { (JSONResponse) in
            print(JSONResponse)
            let JSONArray = JSONResponse as! [Any]
            for avviso in JSONArray{
                let avvisoDict = avviso as! [String: Any]
                self.teachingDataSource.addNewNotify(date: avvisoDict["data"] as? String, title: avvisoDict["title"] as? String, message: avvisoDict["content"] as? String)
            }
        }
        
        teachingDataSource.addNewNotify(date: "30/10/2018", title: "Date esami", message: "Giorno 2 novembre ci sarà la prima prova scritta.")
        teachingDataSource.addNewNotify(date: "25/11/2018", title: "Lezione rimandata", message: "Si avvisano gli studenti che giorno 26 novembre non ci sarà lezione.")
        teachingDataSource.addNewNotify(date: "05/12/2018", title: "Risultati della prova in itinere", message: "Tutti promossi. :)")
    }
    
    fileprivate func pullDescription() {
        teachingDataSource.setDescriptionText(description: "Questa è la descrizione")
    }
    
    fileprivate func pullDocuments() {
        teachingDataSource.addNewDocument(path: "./cartella1Ciao", type: .folder)
        teachingDataSource.addNewDocument(path: "./file1", type: .file)
        teachingDataSource.addNewDocument(path: "./file2", type: .file)
        teachingDataSource.addNewDocument(path: "./file3", type: .file)
        teachingDataSource.addNewDocument(path: "./file4", type: .file)
        teachingDataSource.addNewDocument(path: "./file5", type: .file)
        teachingDataSource.addNewDocument(path: "./file6", type: .file)
        teachingDataSource.addNewDocument(path: "./file7", type: .file)
        teachingDataSource.addNewDocument(path: "./file8", type: .file)
        teachingDataSource.addNewDocument(path: "./file9", type: .file)
        teachingDataSource.addNewDocument(path: "./file10", type: .file)
        teachingDataSource.addNewDocument(path: "./file11", type: .file)
        teachingDataSource.addNewDocument(path: "./file12", type: .file)
        teachingDataSource.addNewDocument(path: "./file13", type: .file)
        teachingDataSource.documentsList[12].setPrev(prev: teachingDataSource.documentsList[0])
        teachingDataSource.documentsList[13].setPrev(prev: teachingDataSource.documentsList[0])
    }
    
    */
    
    
    private func setPageViewController() {
        var i: Int
        
        if teachingDataSource.showcaseHTML == nil || teachingDataSource.showcaseHTML.isEmpty {
            showcaseButtonView.isHidden = true
            i = 0
            for x in viewControllerList {
                if x is ShowcasePageViewController {
                    viewControllerList.remove(at: i)
                    break
                }
                i += 1
            }
        } else {
            showcaseButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sendToShowcaseView(_:))))
            customButtons(button: showcaseButton, image: "showcase", action: #selector(self.sendToShowcaseView(_:)))
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
        } else {
            notifyButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sendToNotifyView(_:))))
            if teachingDataSource.notifyList.isEmpty {
                customButtons(button: notifyButton, image: "markedBell", action: #selector(self.sendToNotifyView(_:)))
            } else {
                customButtons(button: notifyButton, image: "bell", action: #selector(self.sendToNotifyView(_:)))
            }
        }
        
        if teachingDataSource.syllabusCode == nil || teachingDataSource.syllabusCode.isEmpty {
            syllabusButtonView.isHidden = true
            i = 0
            for x in viewControllerList {
                if x is SyllabusPageViewController {
                    viewControllerList.remove(at: i)
                    break
                }
                i += 1
            }
        } else {
            syllabusButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sendToSyllabusView(_:))))
            customButtons(button: syllabusButton, image: "description", action: #selector(self.sendToSyllabusView(_:)))
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
        } else {
            descriptionButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sendToDescriptionView(_:))))
            customButtons(button: descriptionButton, image: "description", action: #selector(self.sendToDescriptionView(_:)))
        }
        
        if teachingDataSource.documentsList == nil || teachingDataSource.documentsList.isEmpty {
            documentsButtonView.isHidden = true
            i = 0
            for x in viewControllerList {
                if x is DocumentsPageViewController {
                    viewControllerList.remove(at: i)
                    break
                }
                i += 1
            }
        } else {
            documentsButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sendToDocumentsView(_:))))
            customButtons(button: documentsButton, image: "folder", action: #selector(self.sendToDocumentsView(_:)))
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
        } else {
            bookingButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sendToBookingView(_:))))
            customButtons(button: bookingButton, image: "booking", action: #selector(self.sendToBookingView(_:)))
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
    
    
    
   private func setAllButtonsViewWithClearBackgroundColor(){
        showcaseButtonView.backgroundColor = UIColor.clear
        notifyButtonView.backgroundColor = UIColor.clear
        syllabusButtonView.backgroundColor = UIColor.clear
        descriptionButtonView.backgroundColor = UIColor.clear
        documentsButtonView.backgroundColor = UIColor.clear
        bookingButtonView.backgroundColor = UIColor.clear
    }
    
    
    private func customButtons(button: UIButton!, image: String!, action: Selector?){
        let customImageView = UIImageView(frame: CGRect(x: button.frame.size.width/2 - 16, y: button.frame.size.height/2 - 15, width: 32, height: 30))
        customImageView.image = UIImage(named: image!)
        button.addSubview(customImageView)
        button.addTarget(self, action: action!, for: UIControl.Event.touchUpInside)
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
            if viewControllerList != nil{
             viewControllerList[0].view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            }
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
    deinit{
        print("Deinit Teaching")
    }
    
    
}
