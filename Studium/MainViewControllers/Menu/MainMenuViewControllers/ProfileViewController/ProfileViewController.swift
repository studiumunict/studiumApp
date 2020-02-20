//
//  ProfileViewController.swift
//  Studium
//
//  Created by Simone Scionti on 23/11/2018.
//  Copyright © 2018 Unict.it. All rights reserved.
//

import UIKit
import Photos

class ProfileViewController: UIViewController, SWRevealViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var universityCodeLabel: UILabel!
    @IBOutlet weak var codFiscaleLabel: UILabel!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var universityCodeView: UIView!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var emailView: UIView!
    var profileDataSource: Student!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        imagePicker.delegate =  self
        setupNavigationBar()
        setupRevealControllerParameters()
        setupUserImageView()
        setupUniversityCodeView()
        setupUsernameView()
        setupEmailView()
        profileDataSource = Student.getUniqueIstance() //ce l'abbiamo salvato dal login
        self.setStudentDatainViews()
    }
    func uploadSelectedimage(image : UIImage){
        print("uploadImage")
    
    }
    @objc func imageTapped( tapGestureRecognizer: UITapGestureRecognizer){
        print("imageTapped")
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.userImageView.contentMode = .scaleAspectFit
            self.userImageView.image = pickedImage
            uploadSelectedimage(image: pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
       /* super.viewDidAppear(true)
        self.userImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.imageTapped(tapGestureRecognizer:))))
        self.userImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.imageTapped(tapGestureRecognizer:))))
        userImageView.isUserInteractionEnabled =  true*/
    }
    
    private func setupNavigationBar(){
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.03487086296, green: 0.03488409892, blue: 0.0348691158, alpha: 1)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        imageView.image = UIImage.init(named: "menu")
        let buttonView = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        buttonView.addSubview(imageView)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: buttonView)
    }
    
    private func setupRevealControllerParameters(){
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130 //Menu sx
            revealViewController().delegate = self
            self.navigationItem.leftBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))))
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
    
    private func setupUserImageView(){
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.clipsToBounds = true
        userImageView.layer.borderWidth = 3.0
        userImageView.layer.borderColor = UIColor.secondaryBackground.cgColor
    }
    private func setupUniversityCodeView(){
        universityCodeView.layer.cornerRadius =  7.0
        universityCodeView.clipsToBounds = true
    }
    private func setupUsernameView(){
        usernameView.layer.cornerRadius =  7.0
        usernameView.clipsToBounds = true
    }
    private func setupPhoneNumberView(){
        phoneNumberView.layer.cornerRadius =  7.0
        phoneNumberView.clipsToBounds = true
    }
    private func setupEmailView(){
        emailView.layer.cornerRadius =  7.0
        emailView.clipsToBounds = true
    }
    
    func setStudentDatainViews(){
        codFiscaleLabel.text = profileDataSource.codFiscale
        universityCodeLabel.text = profileDataSource.code
        studentNameLabel.text = profileDataSource.name + " " + profileDataSource.surname
        emailLabel.text = profileDataSource.email
        phoneNumberLabel.text = profileDataSource.telNumber
        userImageView.image = profileDataSource.profileImage
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130 //Menu sx
            revealViewController().delegate = self
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
       
    }

}
