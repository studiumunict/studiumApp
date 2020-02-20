//
//  MenuTableViewController.swift
//  Studium
//
//  Created by Simone Scionti on 23/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController, SWRevealViewControllerDelegate {
    static var HomeFrontController : UINavigationController! = nil
    static var CourseFrontController : UINavigationController! = nil
    static var ProfileFrontController : UINavigationController! = nil
    static var DocsFrontController : UINavigationController! = nil
    static var ManageCourseFrontController : UINavigationController! = nil
    static var PortaleStudController : UINavigationController! = nil
    static var DevsCreditsController : UINavigationController! = nil
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = true
        preloadSmartEduController()
        //preloadProfileController()
    }

    func preloadSmartEduController(){
        if MenuTableViewController.PortaleStudController == nil {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PortaleStudNavigation") as! UINavigationController
            MenuTableViewController.PortaleStudController = vc
            vc.topViewController?.viewDidLoad()
        }
    }
    func preloadProfileController(){
        if MenuTableViewController.ProfileFrontController == nil {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileNavigation") as! UINavigationController
            MenuTableViewController.ProfileFrontController = vc
            vc.viewDidLoad()
            //vc.topViewController?.viewDidLoad()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            if MenuTableViewController.HomeFrontController == nil {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeNavigation") as! UINavigationController
                let segue = SWRevealViewControllerSeguePushController.init(identifier: "pushToHome", source: self, destination: vc)
                segue.perform()
                MenuTableViewController.HomeFrontController = vc
            }
            else{
                self.revealViewController()?.pushFrontViewController(MenuTableViewController.HomeFrontController, animated: true)
            }
        }
        else if indexPath.row == 1{
            if MenuTableViewController.CourseFrontController == nil {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CourseNavigation") as! UINavigationController
                let segue = SWRevealViewControllerSeguePushController.init(identifier: "pushToCourse", source: self, destination: vc)
                segue.perform()
                MenuTableViewController.CourseFrontController = vc
            }
            else{
                self.revealViewController()?.pushFrontViewController(MenuTableViewController.CourseFrontController, animated: true)
            }
            
            
        }
        else if indexPath.row == 2{
            if MenuTableViewController.ManageCourseFrontController == nil {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ManageCourseNavigation") as! UINavigationController
                let segue = SWRevealViewControllerSeguePushController.init(identifier: "pushToManageCourse", source: self, destination: vc)
                segue.perform()
                MenuTableViewController.ManageCourseFrontController = vc
            }
            else{
                self.revealViewController()?.pushFrontViewController(MenuTableViewController.ManageCourseFrontController, animated: true)
            }
            
            
        }
        else if indexPath.row == 3{
            if MenuTableViewController.ProfileFrontController == nil {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileNavigation") as! UINavigationController
                let segue = SWRevealViewControllerSeguePushController.init(identifier: "pushToProfile", source: self, destination: vc)
                segue.perform()
                MenuTableViewController.ProfileFrontController = vc
            }
            else{
                self.revealViewController()?.pushFrontViewController(MenuTableViewController.ProfileFrontController, animated: true)
            }
            
        }
        else if indexPath.row == 4{
            if MenuTableViewController.DocsFrontController == nil {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DocsNavigation") as! UINavigationController
                let segue = SWRevealViewControllerSeguePushController.init(identifier: "pushToDocs", source: self, destination: vc)
                segue.perform()
                MenuTableViewController.DocsFrontController = vc
            }
            else{
                self.revealViewController()?.pushFrontViewController(MenuTableViewController.DocsFrontController, animated: true)
            }
            
        }
        else if indexPath.row == 5{
            if MenuTableViewController.PortaleStudController == nil {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PortaleStudNavigation") as! UINavigationController
                let segue = SWRevealViewControllerSeguePushController.init(identifier: "pushToPortaleStud", source: self, destination: vc)
                segue.perform()
                MenuTableViewController.PortaleStudController = vc
            }
            else{
                self.revealViewController()?.pushFrontViewController(MenuTableViewController.PortaleStudController, animated: true)
            }
        }
        else if indexPath.row == 6{
            print("popToRoot")
            
            //execute logout
            
            let api =  BackendAPI.getUniqueIstance(fromController: nil)
            api.logout_v2 { (years) in
                self.dismiss(animated: true, completion: nil)
            }
            
            //self.removeFromParent()
            //self.navigationController?.removeFromParent()
           // self.navigationController?.popToRootViewController(animated: true)
        }
        else if indexPath.row == 7{
           //segue to credits
           // pushToDevs
            if MenuTableViewController.DevsCreditsController == nil {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DevsNavigation") as! UINavigationController
                let segue = SWRevealViewControllerSeguePushController.init(identifier: "pushToDevs", source: self, destination: vc)
                           segue.perform()
                MenuTableViewController.DevsCreditsController = vc
            }
            else{
                self.revealViewController()?.pushFrontViewController(MenuTableViewController.DevsCreditsController, animated: true)
            }
            
            
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
}
