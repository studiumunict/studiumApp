//
//  NotifyPageViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 10/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class NotifyPageViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var errorMessageLabel: UILabel!
    @IBOutlet fileprivate weak var tableView: UITableView!
    fileprivate var dataSource = NotifyTableDataSource()
    
    var notifyList: [Notify]!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 10))
        self.view.backgroundColor = UIColor.lightWhite
        self.view.layer.borderColor = UIColor.primaryBackground.cgColor
        self.view.layer.borderWidth = 0.5
        
        
        if notifyList != nil && notifyList.count > 0 {
            
            errorMessageLabel.isHidden = true
            tableView.isHidden = false
            setupTableView()
            
            var i: Int = notifyList.count-1
            while i >= 0 {
                dataSource.items.append(ContentCell(data: notifyList[i].date, title: notifyList[i].title, description: notifyList[i].message))
                i -= 1
            }
            
        } else {
            
            errorMessageLabel.isHidden = false
            errorMessageLabel.text = "Questo insegnamento non ha ancora inoltrato avvisi."
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NotifyCell
        
        cell.state = .expanded
        dataSource.addExpandedIndexPath(indexPath)
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NotifyCell
        
        cell.state = .collapsed
        dataSource.removeExpandedIndexPath(indexPath)
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}
