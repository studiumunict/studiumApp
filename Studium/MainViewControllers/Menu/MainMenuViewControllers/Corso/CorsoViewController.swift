//
//  CorsoViewController.swift
//  Studium
//
//  Created by Francesco Petrosino on 24/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit

class CorsoViewController: UIViewController, UIScrollViewDelegate, SWRevealViewControllerDelegate {

    @IBOutlet var viewAppoggio: UIView! //Contiene la scrollView
    @IBOutlet var scrollView: UIScrollView!
    
    // --- MARK: Stack View ---
    @IBOutlet var vetrinaButton: UIButton!
    @IBOutlet var avvisiButton: UIButton!
    @IBOutlet var descrizioneButton: UIButton!
    @IBOutlet var documentiButton: UIButton!
    @IBOutlet var prenotazioniButton: UIButton!
    
    @IBOutlet var nomeCorsoLabel: UILabel!
    @IBOutlet var nomeProfessoreLabel: UILabel!
    
    // --- MARK: Vetrina View ---
    @IBOutlet var vetrinaView: UIView!
    @IBOutlet var indicatoreCaricamentoVetrinaView: UIActivityIndicatorView!
    @IBOutlet var messaggioErroreLabelVetrinaView: UILabel!
    
    
    // --- MARK: Avvisi View ---
    @IBOutlet var avvisiView: UIView!
    @IBOutlet var avvisoPickerView: UIPickerView!
    @IBOutlet var titoloAvvisoLabel: UILabel!
    @IBOutlet var testoAvvisoTextView: UITextView!
    
    
    // --- MARK: Descrizione View ---
    @IBOutlet var descrizioneView: UIView!
    @IBOutlet var descrizioneTextView: UITextView!
    
    // --- MARK: Documenti View ---
    @IBOutlet var documentiView: UIView!
    
    // --- MARK: Prenotazioni View ---
    @IBOutlet var prenotazioniView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Definire le dimensioni dei menu
        /*if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = view.bounds.width - 70 //Menu sx
            revealViewController()?.rightViewController = 160 //Menu dx
            revealViewController().delegate = self
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }*/
        
        viewAppoggio.bounds.size = CGSize(width: self.view.frame.width, height: self.view.frame.height - (vetrinaButton.frame.height + nomeCorsoLabel.frame.height + nomeProfessoreLabel.frame.height)) //definisco le dimensioni reali e di autolayout per la scrollView
        
        scrollView.delegate = self
        scrollView.bounds.size = CGSize(width: viewAppoggio.frame.width, height: scrollView.frame.height) //definisco le dimensioni reali
        scrollView.contentSize = CGSize(width: viewAppoggio.frame.width * 5, height: scrollView.frame.height) //definisco il 'range' o contenuto della scrollView
        
        //imposta le dimensione e le posizioni delle varie pagine rispetto alla scrollView
        vetrinaView.frame = CGRect(x: 0, y: 0, width: viewAppoggio.frame.width, height: viewAppoggio.frame.height)
        avvisiView.frame = CGRect(x: viewAppoggio.bounds.width, y: scrollView.contentOffset.y, width: scrollView.frame.width, height: viewAppoggio.bounds.height)
        descrizioneView.frame = CGRect(x: viewAppoggio.bounds.width * 2, y: scrollView.contentOffset.y, width: scrollView.frame.width, height: viewAppoggio.bounds.height)
        documentiView.frame = CGRect(x: viewAppoggio.bounds.width * 3, y: scrollView.contentOffset.y, width: scrollView.frame.width, height: viewAppoggio.bounds.height)
        prenotazioniView.frame = CGRect(x: viewAppoggio.bounds.width * 4, y: scrollView.contentOffset.y, width: scrollView.frame.width, height: viewAppoggio.bounds.height)
        
        // ---
        nomeProfessoreLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.black, spessore: 0.7)
        
        vetrinaView.layer.addBorder(edge: UIRectEdge.left, color: UIColor.black, spessore: 0.25)
        vetrinaView.layer.addBorder(edge: UIRectEdge.right, color: UIColor.black, spessore: 0.25)
        avvisiView.layer.addBorder(edge: UIRectEdge.left, color: UIColor.black, spessore: 0.25)
        avvisiView.layer.addBorder(edge: UIRectEdge.right, color: UIColor.black, spessore: 0.25)
        descrizioneView.layer.addBorder(edge: UIRectEdge.left, color: UIColor.black, spessore: 0.25)
        descrizioneView.layer.addBorder(edge: UIRectEdge.right, color: UIColor.black, spessore: 0.25)
        documentiView.layer.addBorder(edge: UIRectEdge.left, color: UIColor.black, spessore: 0.25)
        documentiView.layer.addBorder(edge: UIRectEdge.right, color: UIColor.black, spessore: 0.25)
        prenotazioniView.layer.addBorder(edge: UIRectEdge.left, color: UIColor.black, spessore: 0.25)
        prenotazioniView.layer.addBorder(edge: UIRectEdge.right, color: UIColor.black, spessore: 0.25)
        
        vetrinaButton.layer.addBorder(edge: UIRectEdge.right, color: UIColor.black, spessore: 0.7)
        vetrinaButton.layer.addBorder(edge: UIRectEdge.top, color: UIColor.black, spessore: 1.0)
        avvisiButton.layer.addBorder(edge: UIRectEdge.right, color: UIColor.black, spessore: 0.7)
        avvisiButton.layer.addBorder(edge: UIRectEdge.top, color: UIColor.black, spessore: 1.0)
        descrizioneButton.layer.addBorder(edge: UIRectEdge.right, color: UIColor.black, spessore: 0.7)
        descrizioneButton.layer.addBorder(edge: UIRectEdge.top, color: UIColor.black, spessore: 1.0)
        documentiButton.layer.addBorder(edge: UIRectEdge.right, color: UIColor.black, spessore: 0.7)
        documentiButton.layer.addBorder(edge: UIRectEdge.top, color: UIColor.black, spessore: 1.0)
        prenotazioniButton.layer.addBorder(edge: UIRectEdge.top, color: UIColor.black, spessore: 1.0)
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
        
        vetrinaButton.backgroundColor = #colorLiteral(red: 0.3292481303, green: 0.3293089271, blue: 0.3292401433, alpha: 1)
        avvisiButton.backgroundColor = #colorLiteral(red: 0.146052599, green: 0.146084398, blue: 0.146048367, alpha: 1)
        descrizioneButton.backgroundColor = #colorLiteral(red: 0.146052599, green: 0.146084398, blue: 0.146048367, alpha: 1)
        documentiButton.backgroundColor = #colorLiteral(red: 0.146052599, green: 0.146084398, blue: 0.146048367, alpha: 1)
        prenotazioniButton.backgroundColor = #colorLiteral(red: 0.146052599, green: 0.146084398, blue: 0.146048367, alpha: 1)
    }
    
    
    func setAllDarkGray(){
        vetrinaButton.backgroundColor = #colorLiteral(red: 0.146052599, green: 0.146084398, blue: 0.146048367, alpha: 1)
        avvisiButton.backgroundColor = #colorLiteral(red: 0.146052599, green: 0.146084398, blue: 0.146048367, alpha: 1)
        descrizioneButton.backgroundColor = #colorLiteral(red: 0.146052599, green: 0.146084398, blue: 0.146048367, alpha: 1)
        documentiButton.backgroundColor = #colorLiteral(red: 0.146052599, green: 0.146084398, blue: 0.146048367, alpha: 1)
        prenotazioniButton.backgroundColor = #colorLiteral(red: 0.146052599, green: 0.146084398, blue: 0.146048367, alpha: 1)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //conta l'indice della pagina corrente
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        
        //i bottoni vengono evidenziati quando si cambia pagina
        switch Int(page) {
        case 0:
            setAllDarkGray()
            vetrinaButton.backgroundColor = #colorLiteral(red: 0.3292481303, green: 0.3293089271, blue: 0.3292401433, alpha: 1)
            
        case 1:
            setAllDarkGray()
            avvisiButton.backgroundColor = #colorLiteral(red: 0.3292481303, green: 0.3293089271, blue: 0.3292401433, alpha: 1)
            
        case 2:
            setAllDarkGray()
            descrizioneButton.backgroundColor = #colorLiteral(red: 0.3292481303, green: 0.3293089271, blue: 0.3292401433, alpha: 1)
            
        case 3:
            setAllDarkGray()
            documentiButton.backgroundColor = #colorLiteral(red: 0.3292481303, green: 0.3293089271, blue: 0.3292401433, alpha: 1)
            
        case 4:
            setAllDarkGray()
            prenotazioniButton.backgroundColor = #colorLiteral(red: 0.3292481303, green: 0.3293089271, blue: 0.3292401433, alpha: 1)
        default:
            break
        }
    }

    @IBAction func sendToVetrinaView(_ sender: UIButton) {
        scrollView.scrollRectToVisible(vetrinaView.frame, animated: false)
        setAllDarkGray()
        vetrinaButton.backgroundColor = #colorLiteral(red: 0.3292481303, green: 0.3293089271, blue: 0.3292401433, alpha: 1)
        
    }
    
    @IBAction func sendToAvvisiView(_ sender: UIButton) {
        scrollView.scrollRectToVisible(avvisiView.frame, animated: false)
        setAllDarkGray()
        avvisiButton.backgroundColor = #colorLiteral(red: 0.3292481303, green: 0.3293089271, blue: 0.3292401433, alpha: 1)
    }
    
    @IBAction func sendToDescrizioneView(_ sender: UIButton) {
        scrollView.scrollRectToVisible(descrizioneView.frame, animated: false)
        setAllDarkGray()
        descrizioneButton.backgroundColor = #colorLiteral(red: 0.3292481303, green: 0.3293089271, blue: 0.3292401433, alpha: 1)
    }
    
    @IBAction func sendToDocumentiView(_ sender: UIButton) {
        scrollView.scrollRectToVisible(documentiView.frame, animated: false)
        setAllDarkGray()
        documentiButton.backgroundColor = #colorLiteral(red: 0.3292481303, green: 0.3293089271, blue: 0.3292401433, alpha: 1)
    }
    
    @IBAction func sendToPrenotazioniView(_ sender: UIButton) {
        scrollView.scrollRectToVisible(prenotazioniView.frame, animated: false)
        setAllDarkGray()
        prenotazioniButton.backgroundColor = #colorLiteral(red: 0.3292481303, green: 0.3293089271, blue: 0.3292401433, alpha: 1)
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
