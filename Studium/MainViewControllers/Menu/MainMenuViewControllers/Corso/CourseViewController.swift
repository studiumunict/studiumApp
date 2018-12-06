//
//  CourseViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 24/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class CourseViewController: UIViewController, UIScrollViewDelegate, SWRevealViewControllerDelegate {

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Definire le dimensioni dei menu
        /*if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = view.bounds.width - 70 //Menu sx
            revealViewController()?.rightViewController = 160 //Menu dx
            revealViewController().delegate = self
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }*/
        
        viewAppoggio.bounds.size = CGSize(width: self.view.frame.width, height: self.view.frame.height - (stackView.frame.height + courseNameLabel.frame.height + nameTeacherLabel.frame.height)) //definisco le dimensioni reali e di autolayout per la scrollView
        
        scrollView.delegate = self
        scrollView.bounds.size = CGSize(width: viewAppoggio.frame.width, height: scrollView.frame.height) //definisco le dimensioni reali
        scrollView.contentSize = CGSize(width: viewAppoggio.frame.width * 5, height: scrollView.frame.height) //definisco il 'range' o contenuto della scrollView
        
        //imposta le dimensione e le posizioni delle varie pagine rispetto alla scrollView
        showcaseView.frame = CGRect(x: 0, y: 0, width: viewAppoggio.frame.width, height: viewAppoggio.frame.height)
        notifyView.frame = CGRect(x: viewAppoggio.bounds.width, y: scrollView.contentOffset.y, width: scrollView.frame.width, height: viewAppoggio.bounds.height)
        descriptionView.frame = CGRect(x: viewAppoggio.bounds.width * 2, y: scrollView.contentOffset.y, width: scrollView.frame.width, height: viewAppoggio.bounds.height)
        documentsView.frame = CGRect(x: viewAppoggio.bounds.width * 3, y: scrollView.contentOffset.y, width: scrollView.frame.width, height: viewAppoggio.bounds.height)
        bookingView.frame = CGRect(x: viewAppoggio.bounds.width * 4, y: scrollView.contentOffset.y, width: scrollView.frame.width, height: viewAppoggio.bounds.height)
        
        // ---
        //nameTeacherLabel.layer.borderWidth = 1.0 //setta tutti i bordi correttamente per intero su XS Max
        nameTeacherLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.black, thickness: 0.7) //Non setta per tutta la width il bordo su XS Max
        
        showcaseView.layer.addBorder(edge: UIRectEdge.left, color: UIColor.black, thickness: 0.5)
        showcaseView.layer.addBorder(edge: UIRectEdge.right, color: UIColor.black, thickness: 0.25)
        notifyView.layer.addBorder(edge: UIRectEdge.left, color: UIColor.black, thickness: 0.25)
        notifyView.layer.addBorder(edge: UIRectEdge.right, color: UIColor.black, thickness: 0.25)
        descriptionView.layer.addBorder(edge: UIRectEdge.left, color: UIColor.black, thickness: 0.25)
        descriptionView.layer.addBorder(edge: UIRectEdge.right, color: UIColor.black, thickness: 0.25)
        documentsView.layer.addBorder(edge: UIRectEdge.left, color: UIColor.black, thickness: 0.25)
        documentsView.layer.addBorder(edge: UIRectEdge.right, color: UIColor.black, thickness: 0.25)
        bookingView.layer.addBorder(edge: UIRectEdge.left, color: UIColor.black, thickness: 0.25)
        bookingView.layer.addBorder(edge: UIRectEdge.right, color: UIColor.black, thickness: 0.5)
        stackView.layer.addBorder(edge: UIRectEdge.top, color: UIColor.black, thickness: 0.7)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Definire le dimensioni dei menu
        /*if revealViewController() != nil {
         revealViewController().rearViewRevealWidth = view.bounds.width - 70 //Menu sx
         revealViewController()?.rightViewController = 160 //Menu dx
            revealViewController().delegate = self
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }*/
        
        self.view.backgroundColor = #colorLiteral(red: 0.146052599, green: 0.146084398, blue: 0.146048367, alpha: 1)
        showcaseButton.backgroundColor = #colorLiteral(red: 0.3292481303, green: 0.3293089271, blue: 0.3292401433, alpha: 1)
        notifyButton.backgroundColor = #colorLiteral(red: 0.146052599, green: 0.146084398, blue: 0.146048367, alpha: 1)
        descriptionButton.backgroundColor = #colorLiteral(red: 0.146052599, green: 0.146084398, blue: 0.146048367, alpha: 1)
        documentsButton.backgroundColor = #colorLiteral(red: 0.146052599, green: 0.146084398, blue: 0.146048367, alpha: 1)
        bookingButton.backgroundColor = #colorLiteral(red: 0.146052599, green: 0.146084398, blue: 0.146048367, alpha: 1)
    }
    
    
    func setAllDarkGray(){
        showcaseButton.backgroundColor = #colorLiteral(red: 0.146052599, green: 0.146084398, blue: 0.146048367, alpha: 1)
        notifyButton.backgroundColor = #colorLiteral(red: 0.146052599, green: 0.146084398, blue: 0.146048367, alpha: 1)
        descriptionButton.backgroundColor = #colorLiteral(red: 0.146052599, green: 0.146084398, blue: 0.146048367, alpha: 1)
        documentsButton.backgroundColor = #colorLiteral(red: 0.146052599, green: 0.146084398, blue: 0.146048367, alpha: 1)
        bookingButton.backgroundColor = #colorLiteral(red: 0.146052599, green: 0.146084398, blue: 0.146048367, alpha: 1)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //conta l'indice della pagina corrente
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        
        //i bottoni vengono evidenziati quando si cambia pagina
        switch Int(page) {
        case 0:
            setAllDarkGray()
            showcaseButton.backgroundColor = #colorLiteral(red: 0.3292481303, green: 0.3293089271, blue: 0.3292401433, alpha: 1)
            
        case 1:
            setAllDarkGray()
            notifyButton.backgroundColor = #colorLiteral(red: 0.3292481303, green: 0.3293089271, blue: 0.3292401433, alpha: 1)
            
        case 2:
            setAllDarkGray()
            descriptionButton.backgroundColor = #colorLiteral(red: 0.3292481303, green: 0.3293089271, blue: 0.3292401433, alpha: 1)
            
        case 3:
            setAllDarkGray()
            documentsButton.backgroundColor = #colorLiteral(red: 0.3292481303, green: 0.3293089271, blue: 0.3292401433, alpha: 1)
            
        case 4:
            setAllDarkGray()
            bookingButton.backgroundColor = #colorLiteral(red: 0.3292481303, green: 0.3293089271, blue: 0.3292401433, alpha: 1)
        default:
            break
        }
    }

    @IBAction func sendToShowcaseView(_ sender: UIButton) {
        scrollView.scrollRectToVisible(showcaseView.frame, animated: false)
        setAllDarkGray()
        showcaseButton.backgroundColor = #colorLiteral(red: 0.3292481303, green: 0.3293089271, blue: 0.3292401433, alpha: 1)
        
    }
    
    @IBAction func sendToNotifyView(_ sender: UIButton) {
        scrollView.scrollRectToVisible(notifyView.frame, animated: false)
        setAllDarkGray()
        notifyButton.backgroundColor = #colorLiteral(red: 0.3292481303, green: 0.3293089271, blue: 0.3292401433, alpha: 1)
    }
    
    @IBAction func sendToDescriptionView(_ sender: UIButton) {
        scrollView.scrollRectToVisible(descriptionView.frame, animated: false)
        setAllDarkGray()
        descriptionButton.backgroundColor = #colorLiteral(red: 0.3292481303, green: 0.3293089271, blue: 0.3292401433, alpha: 1)
    }
    
    @IBAction func sendToDocumentsView(_ sender: UIButton) {
        scrollView.scrollRectToVisible(documentsView.frame, animated: false)
        setAllDarkGray()
        documentsButton.backgroundColor = #colorLiteral(red: 0.3292481303, green: 0.3293089271, blue: 0.3292401433, alpha: 1)
    }
    
    @IBAction func sendToBookingView(_ sender: UIButton) {
        scrollView.scrollRectToVisible(bookingView.frame, animated: false)
        setAllDarkGray()
        bookingButton.backgroundColor = #colorLiteral(red: 0.3292481303, green: 0.3293089271, blue: 0.3292401433, alpha: 1)
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
