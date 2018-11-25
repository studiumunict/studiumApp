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
    
    @IBOutlet var vetrinaButton: UIButton!
    @IBOutlet var avvisiButton: UIButton!
    @IBOutlet var descrizioneButton: UIButton!
    @IBOutlet var documentiButton: UIButton!
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*if revealViewController() != nil { //Menu laterale
            revealViewController().rearViewRevealWidth = view.bounds.width - 70
            revealViewController().delegate = self
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }*/
        
        viewAppoggio.bounds.size = CGSize(width: self.view.frame.width, height: self.view.frame.height - (vetrinaButton.frame.height + nomeCorsoLabel.frame.height + nomeProfessoreLabel.frame.height)) //definisco le dimensioni reali e di autolayout per la scrollView
        
        scrollView.delegate = self
        scrollView.bounds.size = CGSize(width: viewAppoggio.frame.width, height: scrollView.frame.height) //definisco le dimensioni reali
        scrollView.contentSize = CGSize(width: viewAppoggio.frame.width * 4, height: scrollView.frame.height) //definisco il 'range' o contenuto della scrollView
        
        //imposta le dimensione e le posizioni delle varie pagine rispetto alla scrollView
        vetrinaView.frame = CGRect(x: 0, y: 0, width: viewAppoggio.frame.width, height: viewAppoggio.frame.height)
        avvisiView.frame = CGRect(x: viewAppoggio.bounds.width, y: scrollView.contentOffset.y, width: scrollView.frame.width, height: viewAppoggio.bounds.height)
        descrizioneView.frame = CGRect(x: viewAppoggio.bounds.width * 2, y: scrollView.contentOffset.y, width: scrollView.frame.width, height: viewAppoggio.bounds.height)
        documentiView.frame = CGRect(x: viewAppoggio.bounds.width * 3, y: scrollView.contentOffset.y, width: scrollView.frame.width, height: viewAppoggio.bounds.height)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*if revealViewController() != nil { //Menu laterale
            revealViewController().rearViewRevealWidth = view.bounds.width - 70
            revealViewController().delegate = self
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }*/
        
        vetrinaButton.backgroundColor = UIColor.lightGray
        avvisiButton.backgroundColor = UIColor.darkGray
        descrizioneButton.backgroundColor = UIColor.darkGray
        documentiButton.backgroundColor = UIColor.darkGray
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //conta l'indice della pagina corrente
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        
        //i bottoni vengono evidenziati quando si cambia pagina
        switch Int(page) {
        case 0:
            vetrinaButton.backgroundColor = UIColor.lightGray
            avvisiButton.backgroundColor = UIColor.darkGray
            descrizioneButton.backgroundColor = UIColor.darkGray
            documentiButton.backgroundColor = UIColor.darkGray
        case 1:
            vetrinaButton.backgroundColor = UIColor.darkGray
            avvisiButton.backgroundColor = UIColor.lightGray
            descrizioneButton.backgroundColor = UIColor.darkGray
            documentiButton.backgroundColor = UIColor.darkGray
        case 2:
            vetrinaButton.backgroundColor = UIColor.darkGray
            avvisiButton.backgroundColor = UIColor.darkGray
            descrizioneButton.backgroundColor = UIColor.lightGray
            documentiButton.backgroundColor = UIColor.darkGray
        case 3:
            vetrinaButton.backgroundColor = UIColor.darkGray
            avvisiButton.backgroundColor = UIColor.darkGray
            descrizioneButton.backgroundColor = UIColor.darkGray
            documentiButton.backgroundColor = UIColor.lightGray
        default:
            break
        }
    }

    @IBAction func sendToVetrinaView(_ sender: UIButton) {
        scrollView.scrollRectToVisible(vetrinaView.frame, animated: false)
        vetrinaButton.backgroundColor = UIColor.lightGray
        avvisiButton.backgroundColor = UIColor.darkGray
        descrizioneButton.backgroundColor = UIColor.darkGray
        documentiButton.backgroundColor = UIColor.darkGray
    }
    
    @IBAction func sendToAvvisiView(_ sender: UIButton) {
        scrollView.scrollRectToVisible(avvisiView.frame, animated: false)
        vetrinaButton.backgroundColor = UIColor.darkGray
        avvisiButton.backgroundColor = UIColor.lightGray
        descrizioneButton.backgroundColor = UIColor.darkGray
        documentiButton.backgroundColor = UIColor.darkGray
    }
    
    @IBAction func sendToDescrizioneView(_ sender: UIButton) {
        scrollView.scrollRectToVisible(descrizioneView.frame, animated: false)
        vetrinaButton.backgroundColor = UIColor.darkGray
        avvisiButton.backgroundColor = UIColor.darkGray
        descrizioneButton.backgroundColor = UIColor.lightGray
        documentiButton.backgroundColor = UIColor.darkGray
    }
    
    @IBAction func sendToDocumentiView(_ sender: Any) {
        scrollView.scrollRectToVisible(documentiView.frame, animated: false)
        vetrinaButton.backgroundColor = UIColor.darkGray
        avvisiButton.backgroundColor = UIColor.darkGray
        descrizioneButton.backgroundColor = UIColor.darkGray
        documentiButton.backgroundColor = UIColor.lightGray
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
