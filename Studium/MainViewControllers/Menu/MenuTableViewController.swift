//
//  MenuTableViewController.swift
//  Studium
//
//  Created by Simone Scionti on 23/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

 var HomeFrontController : UINavigationController! = nil
 var CourseFrontController : UINavigationController! = nil
 var ProfileFrontController : UINavigationController! = nil
 var DocsFrontController : UINavigationController! = nil
 var ManageCourseFrontController : UINavigationController! = nil
 var PortaleStudController : UINavigationController! = nil



class MenuTableViewController: UITableViewController, SWRevealViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            print("HomeClicked")
            if HomeFrontController == nil {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeNavigation") as! UINavigationController
                let segue = SWRevealViewControllerSeguePushController.init(identifier: "pushToHome", source: self, destination: vc)
                segue.perform()
                HomeFrontController = vc
            }
            else{
                self.revealViewController()?.pushFrontViewController(HomeFrontController, animated: true)
            }
        }
        else if indexPath.row == 1{
            if CourseFrontController == nil {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CourseNavigation") as! UINavigationController
                let segue = SWRevealViewControllerSeguePushController.init(identifier: "pushToCourse", source: self, destination: vc)
                segue.perform()
                CourseFrontController = vc
            }
            else{
                self.revealViewController()?.pushFrontViewController(CourseFrontController, animated: true)
            }
            
            
        }
        else if indexPath.row == 2{
            if ManageCourseFrontController == nil {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ManageCourseNavigation") as! UINavigationController
                let segue = SWRevealViewControllerSeguePushController.init(identifier: "pushToManageCourse", source: self, destination: vc)
                segue.perform()
                ManageCourseFrontController = vc
            }
            else{
                self.revealViewController()?.pushFrontViewController(ManageCourseFrontController, animated: true)
            }
            
            
        }
        else if indexPath.row == 3{
            if ProfileFrontController == nil {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileNavigation") as! UINavigationController
                let segue = SWRevealViewControllerSeguePushController.init(identifier: "pushToProfile", source: self, destination: vc)
                segue.perform()
                ProfileFrontController = vc
            }
            else{
                self.revealViewController()?.pushFrontViewController(ProfileFrontController, animated: true)
            }
            
        }
        else if indexPath.row == 4{
            if DocsFrontController == nil {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DocsNavigation") as! UINavigationController
                let segue = SWRevealViewControllerSeguePushController.init(identifier: "pushToDocs", source: self, destination: vc)
                segue.perform()
                DocsFrontController = vc
            }
            else{
                self.revealViewController()?.pushFrontViewController(DocsFrontController, animated: true)
            }
            
        }
        else if indexPath.row == 5{
            if PortaleStudController == nil {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PortaleStudNavigation") as! UINavigationController
                let segue = SWRevealViewControllerSeguePushController.init(identifier: "pushToPortaleStud", source: self, destination: vc)
                segue.perform()
                PortaleStudController = vc
            }
            else{
                self.revealViewController()?.pushFrontViewController(PortaleStudController, animated: true)
            }
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
       
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
