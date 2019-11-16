//
//  NotifyPageViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 10/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class NotifyPageViewController: UIViewController, UITableViewDelegate, SWRevealViewControllerDelegate {

    @IBOutlet var errorMessageLabel: UILabel!
    @IBOutlet fileprivate weak var tableView: UITableView!
    var dataSource = NotifyTableDataSource()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 10))
        self.view.backgroundColor = UIColor.lightWhite
        self.view.layer.borderColor = UIColor.primaryBackground.cgColor
        self.view.layer.borderWidth = 0.5
        if dataSource.items.count > 0 {
            errorMessageLabel.isHidden = true
            tableView.isHidden = false
            setupTableView()
        }
        else {
            
            errorMessageLabel.isHidden = false
            errorMessageLabel.text = "Non sono ancora stati rilasciati avvisi."
            tableView.isHidden = true
        }
        
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.rowHeight = UITableView.automaticDimension 
        tableView.estimatedRowHeight = 200.0
        tableView.separatorStyle = .none
        
    }
    
    deinit{
        print("Deinit notifyPage")
    }
}
