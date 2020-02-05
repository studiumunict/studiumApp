//
//  SingleBookingPageViewController.swift
//  Studium
//
//  Created by Simone Scionti on 13/12/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import UIKit

class SingleBookingPageViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.primaryBackground
        // where data is an Array of String
        label.text = prioritySource[row]
        return label

    }
    
    @IBOutlet weak var priorityLabel: UILabel!
    var confirmActionsView : UIView!
    @IBOutlet weak var priorityPickerView: UIPickerView!
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
    
    @IBOutlet weak var turnDateLabel: UILabel!
    @IBOutlet weak var turnDateValueLabel: UILabel!
    @IBOutlet weak var eventStackView: UIStackView!
    
    @IBOutlet weak var bookingStackView: UIStackView!
    
    @IBOutlet weak var oscureView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    var booking : Booking!
    //weak var bookingPageController: BookingPageViewController! da capire come fare bene
    let prioritySource = ["Bassa","Normale", "Alta"]
    
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var turnValueLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.oscureView.isHidden = true
        self.oscureView.layer.zPosition = 2
        oscureView.backgroundColor = UIColor.primaryBackground
        self.priorityPickerView.delegate = self
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
        confirmButton.isHidden = true
        
        setLabelColors()
        //setUpPickerView()
        setValuesLabelColors()
        hideAll()
        completeBookingData()
        
        
    }
    
    
    private func completeBookingData(){
        booking.completeBookingData(fromController: self) { (error, success) in
            //TODO: control flags
            self.setUpData()
            self.showAll()
            self.booking.selectedPriority = self.booking.priority //selected-> da passare. priority-> indica se la posso scegleire o no
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
        turnDateValueLabel.textColor = .secondaryBackground
        
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
        turnDateLabel.textColor = .primaryBackground
        priorityLabel.textColor = .primaryBackground
    }
    
    private func hideUselessInfo(){
        if !booking.isMultiTurn() || !booking.mine{
            eventStackView.arrangedSubviews[4].isHidden = true
            eventStackView.arrangedSubviews[5].isHidden = true
        }
        if !booking.canDefinePriority() {
            eventStackView.arrangedSubviews[6].isHidden = true
        }
       
    }
    
    private func setUpData(){
        eventNameValueLabel.text = booking.name
        eventLocationValueLabel.text = booking.place
        eventDescriptionValueLabel.text = booking.bookingDescription
        startDateValueLabel.text = booking.data
        bookingStartDateValueLabel.text = booking.openData
        bookingCloseDateValueLabel.text = booking.closeData
        bookingCloseHoursValueLabel.text = booking.closeHour + ":" + booking.closeMinute
        limitedBookingValueLabel.text = booking.limit == 1 ? "Si" : "No"
        turnValueLabel.text = booking.turnName
        turnDateValueLabel.text = booking.turnHour + ":" + booking.turnMinute + ", " + booking.turnDate
        setUpPriorityPickerView()
        setUpConfirmButton()
        hideUselessInfo()
        //limitedBookingValueLabel.textColor = .secondaryBackground
    }
    
    private func setUpPriorityPickerView(){
        if booking.mine{
            priorityPickerView.isUserInteractionEnabled = false
            //inserisci la priorità selezionata nel pickerView
            var prio : Int
            if let p = booking.selectedPriority{
                prio = 2 - p
            }
            else{
                prio = 0
            }
            priorityPickerView.selectRow(prio, inComponent: 0, animated: false)
            
        }
    }
    
    private func setUpConfirmButton(){
        confirmButton.isEnabled = false
        confirmButton.alpha = 0.0
        confirmButton.isHidden = false
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
            if self.booking.isLate(){
                self.confirmButton.isEnabled = false
                self.confirmButton.alpha = 0.6
            }
            else{
                self.confirmButton.isEnabled = true
                self.confirmButton.alpha = 1.0
            }
        
    }
    
    @IBAction func dismissButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        if !booking.mine{
            if booking.canDefinePriority(){ requestBookingWithPriority() }
            else{ requestBooking() }
        }
        else{
            cancelBooking()
        }
    }
    
    private func getConfirmViewTitleLabel() -> UILabel{
        let CF = ConfirmView.getUniqueIstance()
        return CF.getTitleLabel(text: "Prenotazione Confermata")
    }
    
    private func getCancelViewTitleLabel() -> UILabel{
        let CF = ConfirmView.getUniqueIstance()
        return CF.getTitleLabel(text: "Prenotazione cancellata")
    }
    private func getCancelViewDescLabel() -> UILabel{
        let CF = ConfirmView.getUniqueIstance()
        return CF.getDescriptionLabel(text: "Puoi trovare l'evento nella lista \"Altre prenotazioni\"")
    }
    private func getConfirmViewDescLabel() -> UILabel{
        let CF = ConfirmView.getUniqueIstance()
        return CF.getDescriptionLabel(text: "Puoi trovare l'evento nella lista \"Mie prenotazioni\"")
    }
    
    private func getActionsViewOkButton() -> UIButton{
        let CF = ConfirmView.getUniqueIstance()
        return CF.getButton(position: .alone, dataToAttach: nil, title: "Ok", selector: #selector(dismissView), target: self)
    }
    
    
    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func showConfirmActionsView(){
        
        let CF = ConfirmView.getUniqueIstance()
        let confirmTitleLabel = self.getConfirmViewTitleLabel()
        let confirmDescLabel = self.getConfirmViewDescLabel()
        let actionButton = self.getActionsViewOkButton()
        self.confirmActionsView = CF.getView(titleLabel: confirmTitleLabel, descLabel: confirmDescLabel, buttons: [actionButton], dataToAttach: nil)
        self.view.addSubview(confirmActionsView)
        self.confirmActionsView.layer.zPosition = 3
        let SSAnim  = CoreSSAnimation.getUniqueIstance()
        SSAnim.expandViewFromSourceFrame(sourceFrame: CGRect(x: 0, y: self.view.frame.size.height/1.2, width: self.view.frame.size.width, height: 100), viewToExpand: self.confirmActionsView, elementsInsideView: nil, oscureView: self.oscureView) { (flag) in
        }
    }
    
    private func showCancelActionsView(){
        
        let CF = ConfirmView.getUniqueIstance()
        let cancelTitleLabel = self.getCancelViewTitleLabel()
        let cancelDescLabel = self.getCancelViewDescLabel()
        let actionButton = self.getActionsViewOkButton()
        self.confirmActionsView = CF.getView(titleLabel: cancelTitleLabel, descLabel: cancelDescLabel, buttons: [actionButton], dataToAttach: nil)
        self.view.addSubview(confirmActionsView)
        self.confirmActionsView.layer.zPosition = 3
        let SSAnim  = CoreSSAnimation.getUniqueIstance()
        SSAnim.expandViewFromSourceFrame(sourceFrame: CGRect(x: 0, y: self.view.frame.size.height/1.2, width: self.view.frame.size.width, height: 100), viewToExpand: self.confirmActionsView, elementsInsideView: nil, oscureView: self.oscureView) { (flag) in
        }
    }
    
    private func requestBookingWithPriority(){
        booking.requestBooking(errorHandler: self, selectedPriority: 2 - self.priorityPickerView.selectedRow(inComponent: 0), notes: "") { (success) in
            if success{
                self.showConfirmActionsView()
            }
        }
    }
    private func requestBooking(){
        booking.requestBooking(errorHandler: self, notes: "") { (success) in
            if success{
                self.showConfirmActionsView()
            }
        }
    }
    private func cancelBooking(){
        booking.cancelBooking(errorHandler: self) { (success) in
            if success{
                self.showCancelActionsView()
            }
        }
    }
   
    
    
}
