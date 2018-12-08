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
    
    @IBOutlet weak var showcaseButtonView: UIView!
    @IBOutlet var showcaseButton: UIButton!
   
    @IBOutlet weak var notifyButtonView: UIView!
    @IBOutlet var notifyButton: UIButton!
    
    
    @IBOutlet weak var descriptionButtonView: UIView!
    @IBOutlet var descriptionButton: UIButton!
    
    @IBOutlet weak var documentsButtonView: UIView!
    @IBOutlet var documentsButton: UIButton!
    
    
    @IBOutlet weak var bookingButtonView: UIView!
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
        
        /*documentsButton.imageView?.frame = CGRect(x: 10, y: 0, width: 20, height: 20)*/
      
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130//Menu sx/
            revealViewController().delegate = self
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            viewAppoggio.addGestureRecognizer(revealViewController().panGestureRecognizer())
            scrollView.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        completeTeachingDataSource() //Inizializza i nuovi dati del teachingDataSource scaricandoli dal db
        
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
        
        navigationItem.title = "Insegnamento"
        self.view.backgroundColor = UIColor.primaryBackground
        nameTeacherLabel.backgroundColor = UIColor.lightWhite
        courseNameLabel.backgroundColor = UIColor.lightWhite
        showcaseView.backgroundColor = UIColor.lightWhite
        notifyView.backgroundColor = UIColor.lightWhite
        descriptionView.backgroundColor = UIColor.lightWhite
        documentsView.backgroundColor = UIColor.lightWhite
        bookingView.backgroundColor = UIColor.lightWhite
        
        setAllButtonsPrimaryBackgroundColor()
        showcaseButtonView.backgroundColor = UIColor.secondaryBackground
       
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
            revealViewController().rearViewRevealWidth = 130//Menu sx/
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
            self.navigationController?.navigationBar.isUserInteractionEnabled = false
            
        case .left: //Tutti i menu sono chiusi
            scrollView.isScrollEnabled = true
            stackView.isUserInteractionEnabled = true
            self.navigationController?.navigationBar.isUserInteractionEnabled = true
            
        default:
            break
        }
    }
    
    func completeTeachingDataSource(){ //Scarica i dati dal db
        teachingDataSource.completeDataSource(teacherName: "Allocco", haveShowcase: nil, haveDescription: nil, haveDocuments: nil, haveBooking: nil, descriptionText: nil)
    }
    
    
    
    func setAllButtonsPrimaryBackgroundColor(){
        showcaseButtonView.backgroundColor = UIColor.primaryBackground
        notifyButtonView.backgroundColor = UIColor.primaryBackground
        descriptionButtonView.backgroundColor = UIColor.primaryBackground
        documentsButtonView.backgroundColor = UIColor.primaryBackground
        bookingButtonView.backgroundColor = UIColor.primaryBackground
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //conta l'indice della pagina corrente
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        
        //i bottoni vengono evidenziati quando si cambia pagina
        switch Int(page) {
        case 0:
            setAllButtonsPrimaryBackgroundColor()
            showcaseButtonView.backgroundColor = UIColor.secondaryBackground
            scrollView.addGestureRecognizer(revealViewController().panGestureRecognizer())
            
        case 1:
            setAllButtonsPrimaryBackgroundColor()
            notifyButtonView.backgroundColor = UIColor.secondaryBackground
            scrollView.removeGestureRecognizer(revealViewController().panGestureRecognizer())
            
        case 2:
            setAllButtonsPrimaryBackgroundColor()
            descriptionButtonView.backgroundColor = UIColor.secondaryBackground
            scrollView.removeGestureRecognizer(revealViewController().panGestureRecognizer())
            
        case 3:
            setAllButtonsPrimaryBackgroundColor()
            documentsButtonView.backgroundColor = UIColor.secondaryBackground
            scrollView.removeGestureRecognizer(revealViewController().panGestureRecognizer())
            
        case 4:
            setAllButtonsPrimaryBackgroundColor()
            bookingButtonView.backgroundColor = UIColor.secondaryBackground
            scrollView.removeGestureRecognizer(revealViewController().panGestureRecognizer())
        default:
            break
        }
    }

    @IBAction func sendToShowcaseView(_ sender: UIButton) {
        scrollView.scrollRectToVisible(showcaseView.frame, animated: false)
        setAllButtonsPrimaryBackgroundColor()
        showcaseButtonView.backgroundColor = UIColor.secondaryBackground
        
    }
    
    @IBAction func sendToNotifyView(_ sender: UIButton) {
        scrollView.scrollRectToVisible(notifyView.frame, animated: false)
        setAllButtonsPrimaryBackgroundColor()
        notifyButtonView.backgroundColor = UIColor.secondaryBackground
    }
    
    @IBAction func sendToDescriptionView(_ sender: UIButton) {
        scrollView.scrollRectToVisible(descriptionView.frame, animated: false)
        setAllButtonsPrimaryBackgroundColor()
        descriptionButtonView.backgroundColor = UIColor.secondaryBackground
    }
    
    @IBAction func sendToDocumentsView(_ sender: UIButton) {
        scrollView.scrollRectToVisible(documentsView.frame, animated: false)
        setAllButtonsPrimaryBackgroundColor()
        documentsButtonView.backgroundColor = UIColor.secondaryBackground
    }
    
    @IBAction func sendToBookingView(_ sender: UIButton) {
        scrollView.scrollRectToVisible(bookingView.frame, animated: false)
        setAllButtonsPrimaryBackgroundColor()
        bookingButtonView.backgroundColor = UIColor.secondaryBackground
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
