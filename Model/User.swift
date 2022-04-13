//
//  User.swift
//  Swimmy
//
//  Created by 伊藤寛人 on 2021/08/23.
//

//import Foundation
//import Firebase
//

import Foundation
import Firebase
import FirebaseFirestore

class User {
    
    let email: String
    let username: String
    let createdAt: Timestamp
    let profileImageUrl: String
    
    let nikName:String
    let sex: String
    let Name: String
    let age: String
    let address: String
    let likePost: String
    
    var uid: String?
    
    init(dic: [String: Any]) {
        self.email = dic["email"] as? String ?? ""
        self.username = dic["username"] as? String ?? ""
        self.nikName = dic["username"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.profileImageUrl = dic["profileImageUrl"] as? String ?? ""
        self.sex = dic["sex"] as? String ?? ""
        self.Name = dic["Name"] as? String ?? ""
        self.age = dic["age"] as? String ?? ""
        self.address = dic["address"] as? String ?? ""
        self.likePost = dic["likePost"] as? String ?? ""
    }
    
}
