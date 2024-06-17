//
//  InsertMailViewController.swift
//  2022-ios
//
//  Created by user206629 on 5/19/22.
//

import UIKit
import Firebase
 
class InsertMailViewController: UIViewController, UITextFieldDelegate{
    
    @IBAction private func tapToCloseKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var emailTextF: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red:118.0/255.0, green:240.0/255.0, blue:152.0/255.0, alpha: 1.0).cgColor,
            UIColor(red:157.0/255.0, green:128.0/255.0, blue:251.0/255.0, alpha: 1.0).cgColor]
        gradient.frame = btnSend.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        btnSend.layer.insertSublayer(gradient, at: 0)
        btnSend.layer.cornerRadius = 13
        btnSend.layer.masksToBounds = true
        btnSend.layer.cornerRadius = 12.0
        setSendButton(enabled: false)

        
        emailTextF.delegate = self
        emailTextF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
    }
    
    @objc func textFieldChanged(_ target:UITextField) {
        let email = emailTextF.text
        let formFilled = email != nil && email != ""
        setSendButton(enabled: formFilled)
    }
    
    func setSendButton(enabled:Bool) {
        if enabled {
            btnSend.alpha = 1.0
            btnSend.isEnabled = true
        } else {
            btnSend.alpha = 0.5
            btnSend.isEnabled = false
        }
    }
    
    @IBAction func sendCorreoAction(_ sender: Any) {
        guard let email = emailTextF.text else { return }
        
        setSendButton(enabled: false)

        Auth.auth().sendPasswordReset(withEmail: email){(error) in
            if error != nil{
                print("Error logging in: \(error!.localizedDescription)")
                let error = UIAlertController (title: "Error", message:
                    "El correo electrónico es incorrecto", preferredStyle: .alert)
                error.addAction(UIAlertAction(title: "Aceptar", style: .default))
                self.present(error, animated: true, completion: nil)
            }else{
                print("Enviado")
                let message = UIAlertController (title: "Mensaje", message:
                    "Se envió correo electronico de cambio de contraseña", preferredStyle: .alert)
                message.addAction(UIAlertAction(title: "Aceptar", style: .default))
                self.present(message, animated: true, completion: nil)
            }
            
        }
    
    }
    
    

}
        
    


