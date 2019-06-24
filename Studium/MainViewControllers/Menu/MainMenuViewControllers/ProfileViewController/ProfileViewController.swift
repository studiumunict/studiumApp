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
    
    /*func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }*/
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
        print("cancelled")
        dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.userImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.imageTapped(tapGestureRecognizer:))))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate =  self
        self.userImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.imageTapped(tapGestureRecognizer:))))
        userImageView.isUserInteractionEnabled =  true
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.03487086296, green: 0.03488409892, blue: 0.0348691158, alpha: 1)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        imageView.image = UIImage.init(named: "menu")
        let buttonView = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        buttonView.addSubview(imageView)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: buttonView)
        
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 130 //Menu sx
            revealViewController().delegate = self
            self.navigationItem.leftBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))))
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.clipsToBounds = true
        userImageView.layer.borderWidth = 3.0
        userImageView.layer.borderColor = UIColor.secondaryBackground.cgColor
        
        
        universityCodeView.layer.cornerRadius =  7.0
        universityCodeView.clipsToBounds = true
        usernameView.layer.cornerRadius =  7.0
        usernameView.clipsToBounds = true
        phoneNumberView.layer.cornerRadius =  7.0
        phoneNumberView.clipsToBounds = true
        emailView.layer.cornerRadius =  7.0
        emailView.clipsToBounds = true
        
        let thisStudent = getStudent()
        setStudentDatainView(profileDataSource: thisStudent)
    }
    
    func getStudent() -> Student{
        profileDataSource = Student(codFiscale: "SCNSNR98P29C351C", code: "X81000123", name: "Simone Orazio", surname: "Scionti", telNumber: "12345678901", email: "ilking@dmi.unict.it", profileImage: UIImage.init(named: "logo"))
        return profileDataSource
    }
    
    func setStudentDatainView(profileDataSource: Student){
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
