//
//  SingleBookingPageViewController.swift
//  Studium
//
//  Created by Simone Scionti on 13/12/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import UIKit

class SingleBookingPageViewController: UIViewController {

    @IBOutlet weak var limitedBookingValueLabel: UILabel!
    @IBOutlet weak var bookingCloseHoursValueLabel: UILabel!
    @IBOutlet weak var bookingCloseDateValueLabel: UILabel!
    @IBOutlet weak var bookingStartDateValueLabel: UILabel!
    @IBOutlet weak var startDateValueLabel: UILabel!
    @IBOutlet weak var eventDescriptionValueLabel: UILabel!
    @IBOutlet weak var eventLocationValueLabel: UILabel!
    @IBOutlet weak var eventNameValueLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var limitedBookingLabel: UILabel!
    @IBOutlet weak var bookingCloseHoursLabel: UILabel!
    @IBOutlet weak var bookingCloseDateLabel: UILabel!
    @IBOutlet weak var bookingStartDateLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventHeaderLabel: UILabel!
    @IBOutlet weak var bookingHeaderLabel: UILabel!
    
    @IBOutlet weak var eventStackView: UIStackView!
    
    @IBOutlet weak var bookingStackView: UIStackView!
    
    @IBOutlet weak var dismissButton: UIButton!
    var booking : Booking!
    
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var turnValueLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightWhite
        // Do any additional setup after loading the view.
        eventHeaderLabel.backgroundColor = .elementsLikeNavBarColor
        eventHeaderLabel.layer.cornerRadius = 5.0
        eventHeaderLabel.clipsToBounds = true
        
        bookingHeaderLabel.backgroundColor = .elementsLikeNavBarColor
        bookingHeaderLabel.layer.cornerRadius = 5.0
        bookingHeaderLabel.clipsToBounds = true
        
        let image = UIImage.init(named: "close")?.withRenderingMode(.alwaysTemplate)
        dismissButton.setImage(image, for: .normal)
        dismissButton.imageView?.tintColor = .secondaryBackground
        
        confirmButton.layer.cornerRadius = 5.0
        confirmButton.clipsToBounds = true
        
        setLabelColors()
        setValuesLabelColors()
        hideAll()
        booking.completeBookingDataToDo(fromController: self) { (error, success) in
            //stop spinner
            //updateData
            self.setUpData()
            self.showAll()
        }
        
        
    }
    
    private func hideAll(){
        eventStackView.isHidden = true
        bookingStackView.isHidden = true
        confirmButton.isEnabled = false
    }
    
    private func showAll(){
        eventStackView.alpha = 0.0
        bookingStackView.alpha = 0.0
        eventStackView.isHidden = false
        bookingStackView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.eventStackView.alpha = 1.0
            self.bookingStackView.alpha = 1.0
            
        }
    }
    
    
    private func setValuesLabelColors(){
        eventNameValueLabel.textColor = .secondaryBackground
        eventLocationValueLabel.textColor = .secondaryBackground
        eventDescriptionValueLabel.textColor = .secondaryBackground
        startDateValueLabel.textColor = .secondaryBackground
        bookingStartDateValueLabel.textColor = .secondaryBackground
        bookingCloseDateValueLabel.textColor = .secondaryBackground
        bookingCloseHoursValueLabel.textColor = .secondaryBackground
        limitedBookingValueLabel.textColor = .secondaryBackground
        turnValueLabel.textColor = .secondaryBackground
    }
    
    private func setLabelColors(){
        eventNameLabel.textColor = .primaryBackground
        eventLocationLabel.textColor = .primaryBackground
        eventDescriptionLabel.textColor = .primaryBackground
        startDateLabel.textColor = .primaryBackground
        bookingStartDateLabel.textColor = .primaryBackground
        bookingCloseDateLabel.textColor = .primaryBackground
        bookingCloseHoursLabel.textColor = .primaryBackground
        limitedBookingLabel.textColor = .primaryBackground
        turnLabel.textColor = .primaryBackground
    }
    
    private func setUpData(){
        eventNameValueLabel.text = booking.name
        eventLocationValueLabel.text = booking.place == "" ? "Non specificato" : booking.place
        eventDescriptionValueLabel.text = booking.description == "" ? "Nessuna descrizione" : booking.description
        startDateValueLabel.text = booking.data
        bookingStartDateValueLabel.text = booking.openData
        bookingCloseDateValueLabel.text = booking.closeData
        bookingCloseHoursValueLabel.text = booking.closeHour + ":" + booking.closeMinute
        limitedBookingValueLabel.text = booking.limit == 1 ? "Si" : "No"
        
        if booking.limit == 0{
            //nascondi la label per l'orario del turno
            eventStackView.arrangedSubviews[4].isHidden = true
        }
        else{ //inserisci i dati orario turno
            turnValueLabel.text = booking.turnHour + ":" + booking.turnMinute
        }
        
        setUpConfirmButton()
        
        
        
        
        //limitedBookingValueLabel.textColor = .secondaryBackground
    }
    
    private func setUpConfirmButton(){
        confirmButton.isEnabled = false
        UIView.animate(withDuration: 0.2, animations: {
            self.confirmButton.alpha = 0.0
        }) { (flag) in
            var color : UIColor!
            if !self.booking.mine {
                color = UIColor.confirmButtonGreen
                self.confirmButton.setTitle("Conferma Prenotazione", for: UIControl.State.normal)
            }
            else{
                color = UIColor.confirmButtonRed
                self.confirmButton.setTitle("Cancella Prenotazione", for: UIControl.State.normal)
            }
            self.confirmButton.backgroundColor = color
            UIView.animate(withDuration: 0.2) {
                self.confirmButton.alpha = 1.0
            }
            if self.isLate(){
                self.confirmButton.isEnabled = false
                self.confirmButton.alpha = 0.6
            }
            else{
                self.confirmButton.isEnabled = true
                self.confirmButton.alpha = 1.0
            }
        }
        
        
        
        
    }

    private func isLate()-> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let openDateString = booking.openData + " " + "00:00"
        let closeDateString = booking.closeData + " " + booking.closeHour + ":" + booking.closeMinute
        let openDate = dateFormatter.date(from: openDateString)!
        let closeDate = dateFormatter.date(from: closeDateString)!
        let currentDate = Date()
        if currentDate >= openDate && currentDate < closeDate{
            return false
        }
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func dismissButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        if !booking.mine{
            confirmBooking()
        }
        else{
            cancelBooking()
        }
    }
    
    private func cancelBooking(){
        let api = BackendAPI.getUniqueIstance(fromController: self)
        api.cancelBooking(id: String(booking.id)) { (error, JSONResponse) in
            print(JSONResponse)
        }
    }
    private func confirmBooking(){
        let api = BackendAPI.getUniqueIstance(fromController: self)
        api.doBooking(id: String(booking.id), limit: String(booking.limit), prio: String(booking.priority), note: "") { (error, JSONResponse) in
            print(JSONResponse)
        }
    }
    
}
