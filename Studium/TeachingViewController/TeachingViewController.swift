//
//  TeachingViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 24/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class TeachingViewController: UIViewController, UIScrollViewDelegate, SWRevealViewControllerDelegate {

    
    deinit{
        print("deinit teaching")
    }
    @IBOutlet var viewAppoggio: UIView! //Contiene la scrollView
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var stackView: UIStackView!
    
    // --- MARK: Stack View ---
    @IBOutlet var showcaseButton: UIButton!
    @IBOutlet var notifyButton: UIButton!
    @IBOutlet var descriptionButton: UIButton!
    @IBOutlet var documentsButton: UIButton!
    @IBOutlet var bookingButton: UIButton!
    
    @IBOutlet var courseNameLabel: UILabel!
    @IBOutlet var nameTeacherLabel: UILabel!
    
    // --- MARK: Vetrina View ---
    @IBOutlet var showcaseView: UIView!
    @IBOutlet var loadingIndicatorShowcaseView: UIActivityIndicatorView!
    @IBOutlet var errorMessageLabelShowcaseView: UILabel!
    
    
    // --- MARK: Avvisi View ---
    @IBOutlet var notifyView: UIView!
    @IBOutlet var notifyPickerView: UIPickerView!
    @IBOutlet var notifyTitleLabel: UILabel!
    @IBOutlet var notifyMessageTextView: UITextView!
    
    
    // --- MARK: Descrizione View ---
    @IBOutlet var descriptionView: UIView!
    @IBOutlet var descriptionMessageTextView: UITextView!
    
    // --- MARK: Documenti View ---
    @IBOutlet var documentsView: UIView!
    
    // --- MARK: Prenotazioni View ---
    @IBOutlet var bookingView: UIView!
    
    
    // --- MARK: Variables ---
    var teachingDataSource: Teaching! //Pre inizializzato solo con: name, code
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Definire le dimensioni dei menu
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 160//Menu sx/
            revealViewController().delegate = self
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            viewAppoggio.addGestureRecognizer(revealViewController().panGestureRecognizer())
            scrollView.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        setNewTeachingDataSource() //Inizializza i nuovi dati del teachingDataSource scaricandoli dal db
        
        courseNameLabel.text = teachingDataSource.name
        nameTeacherLabel.text = teachingDataSource.teacherName
        
        if teachingDataSource.haveShowcase != nil && teachingDataSource.haveShowcase {
            errorMessageLabelShowcaseView.isHidden = true
            loadingIndicatorShowcaseView.isHidden = true
        } else {
            errorMessageLabelShowcaseView.isHidden = false
        }
        
        if teachingDataSource.haveDescription != nil && teachingDataSource.haveDescription {
            descriptionMessageTextView.text = teachingDataSource.descriptionText
        } else {
            descriptionMessageTextView.text = "Nessuna descrizione per questo insegnamento."
        }
        
        /*if teachingDataSource.haveDocuments != nil {
            <#statements#>
        } else {
            <#statements#>
        }
        
        if teachingDataSource.haveBooking != nil {
            <#statements#>
        } else {
            <#statements#>
        }*/
        
        
        
        navigationItem.title = "Insegnamento"
        self.view.backgroundColor = UIColor.primaryBackground
        nameTeacherLabel.backgroundColor = UIColor.lightWhite
        courseNameLabel.backgroundColor = UIColor.lightWhite
        showcaseView.backgroundColor = UIColor.lightWhite
        notifyView.backgroundColor = UIColor.lightWhite
        descriptionView.backgroundColor = UIColor.lightWhite
        documentsView.backgroundColor = UIColor.lightWhite
        bookingView.backgroundColor = UIColor.lightWhite
        
        setAllPrimaryBackgroundColor()
        
        customizeButton(button: showcaseButton, backgroundColor: UIColor.secondaryBackground, image: UIImage(named: "avv_action"), title: "Vetrina")
        customizeButton(button: notifyButton, backgroundColor: UIColor.primaryBackground, image: UIImage(named: "avv_action"), title: "Avvisi")
        customizeButton(button: descriptionButton, backgroundColor: UIColor.primaryBackground, image: UIImage(named: "avv_action"), title: "Descrizione")
        customizeButton(button: documentsButton, backgroundColor: UIColor.primaryBackground, image: UIImage(named: "avv_action"), title: "Documenti")
        customizeButton(button: bookingButton, backgroundColor: UIColor.primaryBackground, image: UIImage(named: "avv_action"), title: "Prenotazioni")
        
        
        
        viewAppoggio.bounds.size = CGSize(width: self.view.frame.width, height: self.view.frame.height - (stackView.frame.height + courseNameLabel.frame.height + nameTeacherLabel.frame.height)) //definisco le dimensioni reali e di autolayout per la scrollView
        
        scrollView.delegate = self
        scrollView.bounds.size = CGSize(width: viewAppoggio.frame.width, height: scrollView.frame.height) //definisco le dimensioni reali
        scrollView.contentSize = CGSize(width: viewAppoggio.frame.width * 5, height: 1.0) //definisco il 'range' o contenuto della scrollView
        scrollView.bounces = false
        
        //imposta le dimensione e le posizioni delle varie pagine rispetto alla scrollView
        showcaseView.frame = CGRect(x: 0, y: 0, width: viewAppoggio.frame.width, height: viewAppoggio.frame.height)
        notifyView.frame = CGRect(x: viewAppoggio.bounds.width, y: scrollView.contentOffset.y, width: scrollView.frame.width, height: viewAppoggio.bounds.height)
        descriptionView.frame = CGRect(x: viewAppoggio.bounds.width * 2, y: scrollView.contentOffset.y, width: scrollView.frame.width, height: viewAppoggio.bounds.height)
        documentsView.frame = CGRect(x: viewAppoggio.bounds.width * 3, y: scrollView.contentOffset.y, width: scrollView.frame.width, height: viewAppoggio.bounds.height)
        bookingView.frame = CGRect(x: viewAppoggio.bounds.width * 4, y: scrollView.contentOffset.y, width: scrollView.frame.width, height: viewAppoggio.bounds.height)
        
        // ---
        //nameTeacherLabel.layer.borderWidth = 1.0 //setta tutti i bordi correttamente per intero su XS Max
        nameTeacherLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.primaryBackground, thickness: 0.7) //Non setta per tutta la width il bordo su XS Max
        
        showcaseView.layer.addBorder(edge: UIRectEdge.left, color: UIColor.primaryBackground, thickness: 0.5)
        showcaseView.layer.addBorder(edge: UIRectEdge.right, color: UIColor.primaryBackground, thickness: 0.25)
        notifyView.layer.addBorder(edge: UIRectEdge.left, color: UIColor.primaryBackground, thickness: 0.25)
        notifyView.layer.addBorder(edge: UIRectEdge.right, color: UIColor.primaryBackground, thickness: 0.25)
        descriptionView.layer.addBorder(edge: UIRectEdge.left, color: UIColor.primaryBackground, thickness: 0.25)
        descriptionView.layer.addBorder(edge: UIRectEdge.right, color: UIColor.primaryBackground, thickness: 0.25)
        documentsView.layer.addBorder(edge: UIRectEdge.left, color: UIColor.primaryBackground, thickness: 0.25)
        documentsView.layer.addBorder(edge: UIRectEdge.right, color: UIColor.primaryBackground, thickness: 0.25)
        bookingView.layer.addBorder(edge: UIRectEdge.left, color: UIColor.primaryBackground, thickness: 0.25)
        bookingView.layer.addBorder(edge: UIRectEdge.right, color: UIColor.primaryBackground, thickness: 0.5)
        stackView.layer.addBorder(edge: UIRectEdge.top, color: UIColor.primaryBackground, thickness: 0.7)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        //Quando apre le view, se il menu' è aperto lo chiude
        if (revealViewController().frontViewPosition != FrontViewPosition.left) {
            revealViewController().frontViewPosition = .left
        }
        
        //Definire le dimensioni dei menu
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 160//Menu sx/
            revealViewController().delegate = self
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            viewAppoggio.addGestureRecognizer(revealViewController().panGestureRecognizer())
            scrollView.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        switch position {
        case .right: //Uno dei due menu è aperto
            scrollView.isScrollEnabled = false
            stackView.isUserInteractionEnabled = false
            
        case .left: //Tutti i menu sono chiusi
            scrollView.isScrollEnabled = true
            stackView.isUserInteractionEnabled = true
            
        default:
            break
        }
    }
    
    func setNewTeachingDataSource(){ //Scarica i dati dal db
        teachingDataSource.completeDataSource(teacherName: "Allocco", haveShowcase: nil, haveDescription: nil, haveDocuments: nil, haveBooking: nil, descriptionText: nil)
    }
    
    func customizeButton(button: UIButton!, backgroundColor: UIColor!, image: UIImage!, title: String!) {
        button.backgroundColor = backgroundColor
        button.setImage(image, for: .normal)
        button.titleLabel?.text = title
        button.titleLabel?.textColor = UIColor.lightWhite
        button.imageEdgeInsets = UIEdgeInsets(top: 6.5, left: button.bounds.width / 3, bottom: button.bounds.height / 2 - 6.5, right: -5)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: -37, right: 0)
    }
    
    func setAllPrimaryBackgroundColor(){
        showcaseButton.backgroundColor = UIColor.primaryBackground
        notifyButton.backgroundColor = UIColor.primaryBackground
        descriptionButton.backgroundColor = UIColor.primaryBackground
        documentsButton.backgroundColor = UIColor.primaryBackground
        bookingButton.backgroundColor = UIColor.primaryBackground
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //conta l'indice della pagina corrente
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        
        //i bottoni vengono evidenziati quando si cambia pagina
        switch Int(page) {
        case 0:
            setAllPrimaryBackgroundColor()
            showcaseButton.backgroundColor = UIColor.secondaryBackground
            scrollView.addGestureRecognizer(revealViewController().panGestureRecognizer())
            
        case 1:
            setAllPrimaryBackgroundColor()
            notifyButton.backgroundColor = UIColor.secondaryBackground
            scrollView.removeGestureRecognizer(revealViewController().panGestureRecognizer())
            
        case 2:
            setAllPrimaryBackgroundColor()
            descriptionButton.backgroundColor = UIColor.secondaryBackground
            scrollView.removeGestureRecognizer(revealViewController().panGestureRecognizer())
            
        case 3:
            setAllPrimaryBackgroundColor()
            documentsButton.backgroundColor = UIColor.secondaryBackground
            scrollView.removeGestureRecognizer(revealViewController().panGestureRecognizer())
            
        case 4:
            setAllPrimaryBackgroundColor()
            bookingButton.backgroundColor = UIColor.secondaryBackground
            scrollView.removeGestureRecognizer(revealViewController().panGestureRecognizer())
        default:
            break
        }
    }

    @IBAction func sendToShowcaseView(_ sender: UIButton) {
        scrollView.scrollRectToVisible(showcaseView.frame, animated: false)
        setAllPrimaryBackgroundColor()
        showcaseButton.backgroundColor = UIColor.secondaryBackground
        
    }
    
    @IBAction func sendToNotifyView(_ sender: UIButton) {
        scrollView.scrollRectToVisible(notifyView.frame, animated: false)
        setAllPrimaryBackgroundColor()
        notifyButton.backgroundColor = UIColor.secondaryBackground
    }
    
    @IBAction func sendToDescriptionView(_ sender: UIButton) {
        scrollView.scrollRectToVisible(descriptionView.frame, animated: false)
        setAllPrimaryBackgroundColor()
        descriptionButton.backgroundColor = UIColor.secondaryBackground
    }
    
    @IBAction func sendToDocumentsView(_ sender: UIButton) {
        scrollView.scrollRectToVisible(documentsView.frame, animated: false)
        setAllPrimaryBackgroundColor()
        documentsButton.backgroundColor = UIColor.secondaryBackground
    }
    
    @IBAction func sendToBookingView(_ sender: UIButton) {
        scrollView.scrollRectToVisible(bookingView.frame, animated: false)
        setAllPrimaryBackgroundColor()
        bookingButton.backgroundColor = UIColor.secondaryBackground
    }
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
