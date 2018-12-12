//
//  NotifyPageViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 10/12/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class NotifyPageViewController: UIViewController, UITableViewDelegate {

    //@IBOutlet var notifyPickerView: UIPickerView!
    //@IBOutlet var notifyTitleLabel: UILabel!
    //@IBOutlet var notifyMessageTextView: UITextView!
    @IBOutlet var errorMessageLabel: UILabel!
    @IBOutlet fileprivate weak var tableView: UITableView!
    fileprivate var dataSource = DataSource()
    
    var notifyList: [Notify]!
    
    /*override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightWhite
        self.view.layer.borderColor = UIColor.primaryBackground.cgColor
        self.view.layer.borderWidth = 0.5
        
        
        if notifyList != nil && notifyList.count > 0 {
        
            notifyPickerView.isHidden = false
            notifyTitleLabel.isHidden = false
            notifyMessageTextView.isHidden = false
            errorMessageLabel.isHidden = true
            notifyPickerView.delegate = self
            notifyPickerView.dataSource = self
            pickerView(notifyPickerView, didSelectRow: notifyPickerView.selectedRow(inComponent: 0), inComponent: 0)
            
        } else {
            
            notifyPickerView.isHidden = true
            notifyTitleLabel.isHidden = true
            notifyMessageTextView.isHidden = true
            errorMessageLabel.isHidden = false
            errorMessageLabel.text = "Questo insegnamento non ha ancora inoltrato avvisi."
            
        }
        
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let num = notifyList?.count else {
            return 0
        }
        
        return num
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return notifyList![row].date!
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        notifyTitleLabel.text = notifyList![row].title!
        notifyMessageTextView.text = notifyList![row].message!
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightWhite
        self.view.layer.borderColor = UIColor.primaryBackground.cgColor
        self.view.layer.borderWidth = 0.5
        
        
        if notifyList != nil && notifyList.count > 0 {
            
            errorMessageLabel.isHidden = true
            tableView.isHidden = false
            setupTableView()
            
            for x in notifyList {
                dataSource.items.append(ContentCell(data: x.date, title: x.title, description: x.message))
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
