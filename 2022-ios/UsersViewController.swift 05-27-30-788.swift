//
//  UsersViewController.swift
//  2022-ios
//
//  Created by user190700 on 7/17/22.
//

import UIKit
import Firebase

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var tblUsers: UITableView!
    
    var userList = [UserModel]()
    var filteredUsers = [UserModel]()
    var searching = false

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user  = userList[indexPath.row]
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SelectedUserViewController") as? SelectedUserViewController{
            vc.name = user.name!
            vc.lastname = user.lastName!
            vc.email = user.email!
            vc.userImageUrl = user.userImageUrl!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
     }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if searching
        {
            return filteredUsers.count
        }
        return userList.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
                
        if searching
        {
            cell.userlbl.text = filteredUsers[indexPath.row].name! + " " + filteredUsers[indexPath.row].lastName!
            cell.profileImage.load(URLAddress: filteredUsers[indexPath.row].userImageUrl!)
            cell.profileImage.layer.cornerRadius = cell.profileImage.bounds.height / 2
            cell.loadMessage.tag = indexPath.row
            cell.loadMessage.addTarget(self, action: #selector(addtoButton), for: .touchUpInside)

        }
        else
        {
            cell.userlbl.text = userList[indexPath.row].name! + " " + userList[indexPath.row].lastName!
            cell.profileImage.load(URLAddress: userList[indexPath.row].userImageUrl!)
            cell.profileImage.layer.cornerRadius = cell.profileImage.bounds.height / 2
            cell.loadMessage.tag = indexPath.row
            cell.loadMessage.addTarget(self, action: #selector(addtoButton), for: .touchUpInside)
        }
        

        return cell
    }
    
    @objc func addtoButton(sender: UIButton)
    {
        let indexPath1 = IndexPath(row:sender.tag, section: 0)
        let userUid = userList[indexPath1.row].uid
        let userName = userList[indexPath1.row].name
        let userLastname = userList[indexPath1.row].lastName
        let userImage = userList[indexPath1.row].userImageUrl
        
        let chatVC = self.storyboard?.instantiateViewController(identifier: "ChatViewController") as! ChatViewController
        chatVC.uid = userUid!
        chatVC.name = userName!
        chatVC.lastname = userLastname!
        chatVC.imageUrl = userImage!
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSearchController()
        
        let refUsers = Database.database().reference().child("usuarios")
        
        refUsers.observe(DataEventType.value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {
                
                self.userList.removeAll()
                
                for users in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let userObject = users.value as? [String: AnyObject]
                    let userName  = userObject?["nombres"]
                    let userLastName  = userObject?["apellidos"]
                    let userImageUrl = userObject?["userImageUrl"]
                    let userEmail = userObject?["email"]
                    let userUid = userObject?["uid"]
                    
                    let user = UserModel(name: userName as! String?, lastName: userLastName as! String?, userImageUrl: userImageUrl as! String?, email: userEmail as! String?, uid: userUid as! String?)
                    
                    self.userList.append(user)
                }
                
                self.tblUsers.reloadData()
            }
        })
        
    }
    
    func initSearchController()
    {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.placeholder = "Busca entre tu lista de contactos"
        searchController.searchBar.backgroundColor = UIColor.purpleColor
        searchController.searchBar.searchBarStyle = .minimal
        definesPresentationContext = true
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        filteredUsers.removeAll()
        tblUsers.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        let searchText = searchController.searchBar.text!
        if !searchText.isEmpty
        {
            searching = true
            filteredUsers.removeAll()
            for user in userList
            {
                let username = user.name! + " " + user.lastName!
                if username.lowercased().contains(searchText.lowercased())
                {
                    filteredUsers.append(user)
                }
            }
        }
        else
        {
            searching = false
            filteredUsers.removeAll()
            filteredUsers = userList
        }
        
        tblUsers.reloadData()
    }
    
}
extension UIImageView {
    func load(URLAddress: String) {
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
extension UIColor {
  static let purpleColor: UIColor = UIColor(named: "Purple")!
}

