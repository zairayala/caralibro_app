//
//  ChatViewController.swift
//  2022-ios
//
//  Created by user190700 on 7/17/22.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITextFieldDelegate {
    
    var uid = ""
    var name = ""
    var lastname = ""
    var imageUrl = ""
    
    @IBOutlet weak var viewMessage: UIView!
        
    @IBOutlet weak var anchorBottomContentY: NSLayoutConstraint!
    
    @IBAction func tapToClose(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var messagetf: UITextField!
    @IBAction func sendMessage(_ sender: Any) {
        handleSend()
    }
    @IBOutlet weak var cvMessage: UICollectionView!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userlbl: UILabel!
    
    @IBAction func btnback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.registerKeyabordNotification()

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.unregisterKeyboardNotification()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagetf.delegate = self
        userlbl.text = name + " " + lastname
        userImage.loadUserImage(URLAddress: imageUrl)
        userImage.layer.cornerRadius = userImage.bounds.height / 2

    }
    
    func handleSend() {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let fromId = Auth.auth().currentUser?.uid
        let timestamp = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let values = ["text": messagetf.text!, "toId": self.uid, "fromId": fromId!, "timestamp": timestamp] as [String : Any]
        childRef.updateChildValues(values)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
}
extension ChatViewController {
    
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
        
            
            UIView.animate(withDuration: animationDuration) {
                self.anchorBottomContentY.constant = keyboardFrame.height
                self.view.layoutIfNeeded()
            }
        
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        
        UIView.animate(withDuration: animationDuration) {
            self.anchorBottomContentY.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}
extension UIImageView {
    func loadUserImage(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}

    
