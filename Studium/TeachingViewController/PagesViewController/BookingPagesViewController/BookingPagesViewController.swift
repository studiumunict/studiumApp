//
//  BookingPageViewController.swift
//  Studium
//
//  Created by Simone Scionti on 13/12/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import UIKit

class BookingPageViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var bookingTableView: UITableView!
    var dataSource = BookingTableDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookingTableView.delegate = self
        bookingTableView.dataSource = dataSource
        self.view.backgroundColor = UIColor.lightWhite
        self.view.layer.borderColor = UIColor.primaryBackground.cgColor
        self.view.layer.borderWidth = 0.5
        self.bookingTableView.backgroundColor = UIColor.lightWhite
        self.view.backgroundColor = UIColor.lightWhite
    }
    
    private func getSectionButton(forSection: Int, tableView: UITableView)-> UIButton{
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 45))
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        button.setTitle(dataSource.items[forSection].sectionName, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.lightSectionColor, for: .normal)
        button.backgroundColor = UIColor.elementsLikeNavBarColor//UIColor.lightSectionColor
        button.tag = forSection
        if dataSource.items[forSection].booking.count > 0  {
            button.addTarget(self, action: #selector(self.removeOrExpandRows), for: .touchUpInside)
        }
        return button
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = getSectionButton(forSection: section,tableView: tableView)
        let arrowImageView = UIImageView.init(frame: CGRect(x: 10, y: button.frame.height/2 - 7.5, width: 15, height: 15))
        arrowImageView.image = UIImage.init(named: "arrow")?.withRenderingMode(.alwaysTemplate);
        arrowImageView.tintColor = UIColor.lightSectionColor
        button.addSubview(arrowImageView)
        if dataSource.items[section].expanded {
            let SSAnimator = CoreSSAnimation.getUniqueIstance()
            SSAnimator.rotate180Degrees(view: button, animated: false)
        }
        return button
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = getSingleBookingController() as! SingleBookingPageViewController
        vc.booking = dataSource.items[indexPath.section].booking[indexPath.row]
        self.present(vc, animated: true) {
            
        }
    }
    private func getSingleBookingController() -> UIViewController{
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let controller = storyboard.instantiateViewController(withIdentifier: "singleBookingPageViewController")
        //controller.modalPresentationStyle = .popover
           return controller
       }
    
    @objc func removeOrExpandRows(button : UIButton ){
        let SSAnimator = CoreSSAnimation.getUniqueIstance()
        SSAnimator.rotate180Degrees(view: button, animated: true)
        let sect = button.tag
        var indices = [IndexPath]()
        var row = 0
        for _ in dataSource.items[sect].booking{ // salva tutti gli indici
            indices.append(IndexPath.init(row: row, section: sect))
            row += 1
        }
        if dataSource.items[sect].expanded == true{ //RIMUOVE LE RIGHE
            dataSource.items[sect].expanded = false
            self.bookingTableView.deleteRows(at: indices, with: .fade)
        }
        else{
            dataSource.items[sect].expanded = true
            self.bookingTableView.insertRows(at: indices, with: .fade)
        }
    }
    

}
