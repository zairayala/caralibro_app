//
//  LoginViewController.swift
//  2022-ios
//
//  Created by user206629 on 5/19/22.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var viewIngresa: UIView!
    
    @IBAction private func tapToCloseKeyboard(_ sender: UITapGestureRecognizer) {
            self.view.endEditing(true)
        }
    
    @IBOutlet weak var emailTextF: UITextField!
    @IBOutlet weak var passwordTextF: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red:118.0/255.0, green:240.0/255.0, blue:152.0/255.0, alpha: 1.0).cgColor,
            UIColor(red:157.0/255.0, green:128.0/255.0, blue:251.0/255.0, alpha: 1.0).cgColor]
        gradient.frame = btnLogin.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        btnLogin.layer.insertSublayer(gradient, at: 0)
        btnLogin.layer.cornerRadius = 13
        btnLogin.layer.masksToBounds = true
        btnLogin.layer.cornerRadius = 12.0

        btnLogin.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        setLoginButton(enabled: false)
        
        viewIngresa.layer.shadowColor = UIColor(red:119.0/255.0, green:42.0/255.0, blue:145.0/255.0, alpha: 1.0).cgColor
        viewIngresa.layer.shadowOffset = CGSize(width: 10, height: 10)
        viewIngresa.layer.shadowRadius = 1.7
        viewIngresa.layer.shadowOpacity = 0.45
        
        emailTextF.delegate = self
        passwordTextF.delegate = self
   
         
        emailTextF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTextF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)

    }
    
    @objc func textFieldChanged(_ target:UITextField) {
        let email = emailTextF.text
        let password = passwordTextF.text
        let formFilled = email != nil && email != "" && password != nil && password != ""
        setLoginButton(enabled: formFilled)
    }
    
    func setLoginButton(enabled:Bool) {
        if enabled {
            btnLogin.alpha = 1.0
            btnLogin.isEnabled = true
        } else {
            btnLogin.alpha = 0.5
            btnLogin.isEnabled = false
        }
    }
    
    @objc func handleSignIn() {
        guard let email = emailTextF.text else { return }
        guard let pass = passwordTextF.text else { return }
        
        setLoginButton(enabled: false)
        
        Auth.auth().signIn(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                self.dismiss(animated: false, completion: nil)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                mainTabBarController.modalPresentationStyle = .fullScreen
                self.present(mainTabBarController, animated: true, completion: nil)
                
            } else {
                print("Error logging in: \(error!.localizedDescription)")
                let error = UIAlertController (title: "Error", message:
                    "E-mail y/o contraseña incorrectos", preferredStyle: .alert)
                error.addAction(UIAlertAction(title: "Aceptar", style: .default))
                self.present(error, animated: true, completion:
                nil)

            }
        }
    }

}

