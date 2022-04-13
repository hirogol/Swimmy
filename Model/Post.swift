//
//  Post.swift
//  Swimmy
//
//  Created by 伊藤寛人 on 2021/08/26.
//

import Foundation
import Firebase

struct Post {
    let content: String
    let atention: String
    var target: Int
    var progressTarget: Int
    let postID: String
    let senderID: String
    let postImageUrl: String?
    let createdAt: Timestamp
    let updatedAt: Timestamp
    let userId: String
    
    var user: User?
    
    init(data: [String: Any]) {
        content = data["content"] as? String ?? ""
        atention = data["atention"]as? String ?? ""
        target = data["target"] as? Int ?? 0
        progressTarget = data["progressTarget"] as? Int ?? 0
        postID = data["postID"] as? String ?? ""
        senderID = data["senderID"] as? String ?? ""
        postImageUrl = data["postImageUrl"] as? String ?? ""
        createdAt = data["createdAt"] as? Timestamp ?? Timestamp()
        updatedAt = data["updatedAt"] as? Timestamp ?? Timestamp()
        userId = data["userId"] as? String ?? ""
    }
}
