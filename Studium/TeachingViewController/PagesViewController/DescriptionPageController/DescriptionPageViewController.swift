//
//  DescriptionPageViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 10/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit


class DescriptionPageViewController: UIViewController, UITableViewDelegate, SWRevealViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var dataSource = DescriptionTableDataSource()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightWhite
        self.view.layer.borderColor = UIColor.primaryBackground.cgColor
        self.view.layer.borderWidth = 0.5
        setupTableView()
    }
    
    private func setupTableView() {
        self.tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 10))
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200.0
        tableView.separatorStyle = .none
        
    }
    
    deinit{
        print("Deinit descriptionPage")
    }
}
