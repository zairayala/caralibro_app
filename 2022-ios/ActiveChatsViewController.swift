//
//  ActiveChatsViewController.swift
//  2022-ios
//
//  Created by user190700 on 7/17/22.
//

import UIKit
import Firebase

class ActiveChatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var messagesList = [Message]()
    
    @IBOutlet weak var tblMessage: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeMessages()
    }
    
    func observeMessages(){
        let ref = Database.database().reference().child("messages")
        ref.observe(DataEventType.value, with: { (snapshot) in
        
            if snapshot.childrenCount > 0 {
                
                self.messagesList.removeAll()
                
                for messages in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let messageObject = messages.value as? [String: AnyObject]
                    let messageFromId  = messageObject?["fromId"]
                    let messageText  = messageObject?["text"]
                    let messageTime = messageObject?["timestamp"]
                    let mesageToId = messageObject?["toId"]
                    
                    let message = Message(fromId: messageFromId as! String?, text: messageText as! String?, timestamp: messageTime as! NSNumber?, toId: mesageToId as! String?)
                    
                    self.messagesList.append(message)
                }
                
                self.tblMessage.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userUid = messagesList[indexPath.row].toId
        var userName = ""
        var userLastName = ""
        var userImageUrl = ""
        var userEmail = ""
        
        let ref = Database.database().reference().child("usuarios").child(userUid!)
        ref.observeSingleEvent(of: .value, with: { (snapshot)
            in
            if let users = snapshot.value as? [String: AnyObject]
            {
                userName  = (users["nombres"] as? String)!
                userLastName  = (users["apellidos"] as? String)!
                userImageUrl = (users["userImageUrl"] as? String)!
                userEmail = (users["email"] as? String)!
            }
        },withCancel: nil)
        
        let chatVC = self.storyboard?.instantiateViewController(identifier: "ChatViewController") as! ChatViewController
        chatVC.uid = userUid!
        chatVC.name = userName
        chatVC.lastname = userLastName
        chatVC.imageUrl = userImageUrl
        
        self.navigationController?.pushViewController(chatVC, animated: true)

     }

    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return messagesList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMessage", for: indexPath) as! TVCellChat
        let message = messagesList[indexPath.row]
        if let toId = message.toId{
            let ref = Database.database().reference().child("usuarios").child(toId)
            ref.observeSingleEvent(of: .value, with: { (snapshot)
                in
                if let users = snapshot.value as? [String: AnyObject]
                {
                    let userName  = users["nombres"] as? String
                    let userLastName  = users["apellidos"] as? String
                    let userImageUrl = users["userImageUrl"] as? String
                    let userEmail = users["email"] as? String

                    let fullname = userName! + " " + userLastName!
                    cell.fullname.text = fullname
                    cell.profileImage.loadImageChat(URLAddress: userImageUrl!)
                    cell.profileImage.layer.cornerRadius = cell.profileImage.bounds.height / 2

                }
            },withCancel: nil)
                
        }
        if let seconds = message.timestamp?.doubleValue{
            let timestampDate = NSDate(timeIntervalSince1970: seconds)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm:ss a"
            cell.time.text = dateFormatter.string(from: timestampDate as Date)
            
        }
        cell.messagepv.text = message.text
        return cell
    }
    
}
extension UIImageView {
    func loadImageChat(URLAddress: String) {
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

