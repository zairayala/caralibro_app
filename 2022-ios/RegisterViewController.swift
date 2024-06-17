//
//  RegisterViewController.swift
//  2022-ios
//
//  Created by user206629 on 5/21/22.
//
import Foundation
import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage

class RegisterViewController: UIViewController, UITextFieldDelegate{
    

    @IBOutlet weak var viewRegistra: UIImageView!
    @IBOutlet private weak var anchorCenterContentY: NSLayoutConstraint!

    @IBAction private func tapToCloseKeyboard(_ sender: UITapGestureRecognizer) {
            self.view.endEditing(true)
        }
    
    //MARK Outlets to register user
    @IBOutlet weak var nameTextF: UITextField!
    @IBOutlet weak var lastNameTextF: UITextField!
    @IBOutlet weak var emailTextF: UITextField!
    @IBOutlet weak var passwordTextF: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var imageProfile: UIImageView!
    
    var imagePicker:UIImagePickerController!
    var imagePro: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red:118.0/255.0, green:240.0/255.0, blue:152.0/255.0, alpha: 1.0).cgColor,
            UIColor(red:157.0/255.0, green:128.0/255.0, blue:251.0/255.0, alpha: 1.0).cgColor]
        gradient.frame = btnRegister.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        btnRegister.layer.insertSublayer(gradient, at: 0)
        btnRegister.layer.cornerRadius = 13
        btnRegister.layer.masksToBounds = true
        btnRegister.layer.cornerRadius = 12.0
        setRegisterButton(enabled: false)

        
        viewRegistra.layer.shadowColor = UIColor(red:119.0/255.0, green:42.0/255.0, blue:145.0/255.0, alpha: 1.0).cgColor
        viewRegistra.layer.shadowOffset = CGSize(width: 10, height: 10)
        viewRegistra.layer.shadowRadius = 1.7
        viewRegistra.layer.shadowOpacity = 0.45
        
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        imageProfile.isUserInteractionEnabled = true
        imageProfile.addGestureRecognizer(imageTap)
        imageProfile.layer.cornerRadius = imageProfile.bounds.height / 2
        imageProfile.clipsToBounds = true

        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        
        nameTextF.delegate = self
        lastNameTextF.delegate = self
        emailTextF.delegate = self
        passwordTextF.delegate = self
        
        
        nameTextF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        lastNameTextF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        emailTextF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTextF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
    }
    
    @objc func openImagePicker(_ sender:Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyabordNotification()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardNotification()
    }
    
    @objc func textFieldChanged(_ target:UITextField) {
        let name = nameTextF.text
        let lastname = lastNameTextF.text
        let email = emailTextF.text
        let password = passwordTextF.text
        let formfull = name != nil && name != "" && lastname != nil && lastname != "" && email != nil && email != "" && password != nil && password != ""
        setRegisterButton(enabled: formfull)
    }
    
    
    func setRegisterButton(enabled:Bool) {
        if enabled {
            btnRegister.alpha = 1.0
            btnRegister.isEnabled = true
        } else {
            btnRegister.alpha = 0.5
            btnRegister.isEnabled = false
        }
    }
    
    @IBAction func registerAction(_ sender: Any) {
        guard let name = nameTextF.text else { return }
        guard let lastname = lastNameTextF.text else { return }
        guard let email = emailTextF.text else { return }
        guard let password = passwordTextF.text else { return }
        guard let image = self.imagePro else { return }

        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }

        setRegisterButton(enabled: false)
        Auth.auth().createUser(withEmail: email, password: password){(authDataResult, error) in
            if error != nil{
                return
            }

            if let authData = authDataResult{
                print(authData.user.uid)
                var user = [
                    "uid": authData.user.uid,
                    "email": authData.user.email,
                    "userImageUrl": "",
                    "nombres": name,
                    "apellidos": lastname
                ]

            let storageRef = Storage.storage().reference(forURL: "gs://fir-caralibro.appspot.com")
            let storageUserRef = storageRef.child("usuarios").child(authData.user.uid)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            storageUserRef.putData(imageData, metadata: metadata, completion: {(storageMetaData, error) in
                if error != nil{
                    print("Error: \(error!.localizedDescription)")
                    return
                }
                
            //La foto de perfil es obligatoria

            storageUserRef.downloadURL(completion: { (url, error) in
                if let metaImageUrl = url?.absoluteString{ user["userImageUrl"] = metaImageUrl
                    Database.database().reference().child("usuarios").child(authData.user.uid).updateChildValues(user as [AnyHashable : Any], withCompletionBlock: {(error, ref) in
                            if error == nil{
                                print("Guardado")
                                let message = UIAlertController (title: "Mensaje", message:
                                    "Usuario registrado correctamente", preferredStyle: .alert)
                                message.addAction(UIAlertAction(title: "Aceptar", style: .default))
                                self.present(message, animated: true, completion:
                                nil)
                                self.setRegisterButton(enabled: false)
                                self.nameTextF.text = ""
                                self.lastNameTextF.text = ""
                                self.emailTextF.text = ""
                                self.passwordTextF.text = ""
                            }
                        })
                    }
                })
            })
        }
    }
 }
}


extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                imagePro = imageSelected
                imageProfile.image = imageSelected
            }
            if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                imagePro = imageOriginal
                imageProfile.image = imageOriginal
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
    
    
}

extension RegisterViewController {
    
    private func registerKeyabordNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
    }
    
    private func unregisterKeyboardNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        
        if keyboardFrame.origin.y < self.viewRegistra.frame.maxY {
            
            UIView.animate(withDuration: animationDuration) {
                self.anchorCenterContentY.constant = keyboardFrame.origin.y - self.viewRegistra.frame.maxY
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        
        UIView.animate(withDuration: animationDuration) {
            self.anchorCenterContentY.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}

    
