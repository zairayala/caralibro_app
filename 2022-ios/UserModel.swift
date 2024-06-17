//
//  UserModel.swift
//  2022-ios
//
//  Created by user190700 on 7/18/22.
//

class UserModel {
    
    var name: String?
    var lastName: String?
    var userImageUrl: String?
    var email: String?
    var uid: String?
    
    init(name: String?, lastName: String?, userImageUrl: String?, email: String?, uid: String?){
        self.name = name
        self.lastName = lastName
        self.userImageUrl = userImageUrl
        self.email = email
        self.uid = uid
    }
}
