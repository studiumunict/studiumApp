//
//  ManageCoursePageViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 17/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class ManageCoursePageViewController: UIViewController, SWRevealViewControllerDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var manageCourseView: UIView!
    @IBOutlet var manageCourseButton: UIButton!
    @IBOutlet var manageCourseLabel: UILabel!
    
    @IBOutlet var courseView: UIView!
    @IBOutlet var courseButton: UIButton!
    @IBOutlet var courseLabel: UILabel!
    
    
    let pageViewController: UIPageViewController!  = UIPageViewController(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
    lazy var navControllerList: [UINavigationController]! = { return nil }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navControllerList = {
            let nc1 = storyboard!.instantiateViewController(withIdentifier: "ManageCourseNavigation") as! UINavigationController
            let nc2 = storyboard!.instantiateViewController(withIdentifier: "CourseNavigation") as! UINavigationController
            
            return [nc1, nc2]
        }()
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130//Menu sx/
            revealViewController().delegate = self
            navControllerList[0].view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        self.view.backgroundColor = UIColor.primaryBackground
        stackView.backgroundColor = UIColor.navigationBarColor
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        pageViewController.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height - stackView.frame.height)
        
        self.view.addSubview(pageViewController.view)
        
        if let fisrtViewController = navControllerList.first {
            pageViewController.setViewControllers([fisrtViewController], direction: .forward, animated: true, completion: nil)
        }
        
        
        manageCourseLabel.text = "Gestisci Corsi"
        customButtons(button: manageCourseButton, image: "courses", action: #selector(self.sendManageCourse(_:)))
        manageCourseView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sendManageCourse(_:))))
        
        courseLabel.text = "I miei Corsi"
        customButtons(button: courseButton, image: "showcase", action: #selector(self.sendCourse(_:)))
        courseView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sendCourse(_:))))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 160//Menu sx/
            revealViewController().delegate = self
            navControllerList[0].view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
    
    
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = navControllerList.index(of: viewController as! UINavigationController) else {
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
        
        guard let vcIndex = navControllerList.index(of: viewController as! UINavigationController) else {
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
    
    
    
    @objc func sendManageCourse(_ sender: Any) {
        pageViewController.setViewControllers([navControllerList[0]], direction: .forward, animated: false, completion: nil)
    }
    
    @objc func sendCourse(_ sender: Any) {
        pageViewController.setViewControllers([navControllerList[1]], direction: .forward, animated: false, completion: nil)
    }

}
