//
//  SelectedUserViewController.swift
//  2022-ios
//
//  Created by user190700 on 7/17/22.
//

import UIKit
import Firebase
import FirebaseStorage

class SelectedUserViewController: UIViewController {
    
    var name: String = ""
    var lastname: String = ""
    var email: String = ""
    var userImageUrl: String = ""
    
    @IBOutlet weak var fullNamelbl: UILabel!
    @IBOutlet weak var correolbl: UILabel!
    @IBOutlet weak var infolbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fullNamelbl.text = name + " " + lastname
        correolbl.text = email
        infolbl.text = "¡Hola! soy " + name
        profileImage.loadImage(URLAddress: userImageUrl)
        profileImage.layer.cornerRadius = self.profileImage.bounds.height / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension UIImageView {
    func loadImage(URLAddress: String) {
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
