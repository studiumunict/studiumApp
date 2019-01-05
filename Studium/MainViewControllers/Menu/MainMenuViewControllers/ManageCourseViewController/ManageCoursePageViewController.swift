//
//  ManageCoursePageViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 17/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class ManageCoursePageViewController: UIViewController, SWRevealViewControllerDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    @IBOutlet weak var viewAppoggio: UIView!
    @IBOutlet var stackView: UIStackView!
    
    //gestione
    @IBOutlet var manageCourseButtonView: UIView!
    @IBOutlet var manageCourseButton: UIButton!
    @IBOutlet var manageCourseButtonLabel: UILabel!
    
    
    //iscrizione
    @IBOutlet var signUpCourseButtonView: UIView!
    @IBOutlet var signUpCourseButton: UIButton!
    @IBOutlet var signUpCourseButtonLabel: UILabel!
    
    
    let pageViewController: UIPageViewController!  = UIPageViewController(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
    lazy var navControllerList: [UIViewController]! = { return nil }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        imageView.image = UIImage.init(named: "menu")
        let buttonView = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        buttonView.addSubview(imageView)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: buttonView)
        
      
        self.viewAppoggio.backgroundColor =  UIColor.primaryBackground
        self.signUpCourseButtonView.backgroundColor = UIColor.clear
        self.manageCourseButtonView.backgroundColor = UIColor.buttonSelected
        navControllerList = {
            let nc1 = storyboard!.instantiateViewController(withIdentifier: "ManageCourseController")
            let nc2 = storyboard!.instantiateViewController(withIdentifier: "BrowseAndSearchController")
            let browseAndSearch = nc2 as! BrowseAndSearchCoursesViewController
            browseAndSearch.tabController = self
            let manage = nc1 as! ManageCourseViewController
            manage.tabController = self
            return [nc1, nc2]
        }()
          setNavBarForManagement()
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130//Menu sx/
            revealViewController().delegate = self
             self.navigationItem.leftBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))))
            navControllerList[0].view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        //self.view.backgroundColor = UIColor.primaryBackground
       // stackView.backgroundColor = UIColor.secondaryBackground
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.view.frame = CGRect(x: 0.0, y: 0.0, width: self.viewAppoggio.frame.width, height: self.viewAppoggio.frame.height)
        self.viewAppoggio.addSubview(pageViewController.view)
       // self.view.addSubview(pageViewController.view)
        
        if let fisrtViewController = navControllerList.first {
            pageViewController.setViewControllers([fisrtViewController], direction: .forward, animated: true, completion: nil)
        }
        
        
        manageCourseButtonLabel.text = "Gestisci Corsi"
        customButtons(button: manageCourseButton, image: "courses", action: #selector(self.sendManageCourse(_:)))
        manageCourseButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sendManageCourse(_:))))
        
        signUpCourseButtonLabel.text = "Iscriviti ai corsi"
        customButtons(button: signUpCourseButton, image: "showcase", action: #selector(self.sendSignUpCourse(_:)))
        signUpCourseButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sendSignUpCourse(_:))))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130//Menu sx/
            revealViewController().delegate = self
             self.navigationItem.leftBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))))
            navControllerList[0].view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
    
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        print("moved")
        let manageController = navControllerList[0] as! ManageCourseViewController
        switch position {
            
        case .right:
            print("right")
            //apri menu
            if manageController.createCategoryTextField.isFirstResponder {
                manageController.createCategoryTextField.resignFirstResponder()
            }
            
            
            break
        case .left :
            //chiudi menu
            print("move to left")
            if manageController.createCategoryView.isHidden ==  false{
                manageController.createCategoryTextField.becomeFirstResponder()
            }
            
            
            break
            
        default:
            break
        }
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else{return}
        if previousViewControllers.last == navControllerList[0] {
            //siamo in iscrizione
            setNavBarForSignUp()
            self.manageCourseButtonView.backgroundColor = UIColor.clear
            self.signUpCourseButtonView.backgroundColor = UIColor.buttonSelected
            
        }
        else{
            setNavBarForManagement()
            self.signUpCourseButtonView.backgroundColor = UIColor.clear
            self.manageCourseButtonView.backgroundColor = UIColor.buttonSelected
            
        }
        
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = navControllerList.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard navControllerList.count > previousIndex else {
            return nil
        }
        
       
        
        return navControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = navControllerList.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = vcIndex + 1
        
        guard navControllerList.count != nextIndex else {
            return nil
        }
        
        guard navControllerList.count > nextIndex else {
            return nil
        }
        
        
        
        return navControllerList[nextIndex]
    }
    
    
    
    private func customButtons(button: UIButton!, image: String!, action: Selector?){
        let customImageView = UIImageView(frame: CGRect(x: button.frame.size.width/2 - 16, y: button.frame.size.height/2 - 15, width: 32, height: 30))
        customImageView.image = UIImage(named: image!)
        button.addSubview(customImageView)
        button.addTarget(self, action: action!, for: UIControl.Event.touchUpInside)
    }
    
    
    //iscriviti
    @objc func sendManageCourse(_ sender: Any) {
        pageViewController.setViewControllers([navControllerList[0]], direction: .forward, animated: false, completion: nil)
        setNavBarForManagement()
        self.signUpCourseButtonView.backgroundColor = UIColor.clear
        self.manageCourseButtonView.backgroundColor = UIColor.buttonSelected
        
    }
    
    @objc func sendSignUpCourse(_ sender: Any) {
        pageViewController.setViewControllers([navControllerList[1]], direction: .forward, animated: false, completion: nil)
       setNavBarForSignUp()
        self.signUpCourseButtonView.backgroundColor = UIColor.buttonSelected
        self.manageCourseButtonView.backgroundColor = UIColor.clear
    }

    func setNavBarForSignUp(){
        self.navigationItem.title =  "Iscriviti ai corsi"
        let signUpVc = navControllerList[1] as! BrowseAndSearchCoursesViewController
        if signUpVc.cdsSearchBar.isHidden {
            signUpVc.setSearchIconOnSearchButton()
        }
        else{
            signUpVc.setCancelIconOnSearchButton()
        }
    }
    func setNavBarForManagement(){
        self.navigationItem.rightBarButtonItem = nil
        let manageVc = navControllerList[0] as! ManageCourseViewController
        manageVc.setEditIconOnTabBar()
        self.navigationItem.title =  "Gestisci corsi"
       //
    }
    
}
