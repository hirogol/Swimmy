//
//  AppelLIstCell.swift
//  Swimmy
//
//  Created by 伊藤寛人 on 2021/06/20.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import PKHUD
import Nuke


class AppealListCell: UICollectionViewCell {
        
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var progressLabel: UIProgressView!
    
    private var posts = [Post]()
    private var users = [User]()
    
    
    var post:Post? {
            didSet {
                if let post = post {
                    if let url = URL(string: post.postImageUrl ?? "") {
                    Nuke.loadImage(with: url, into: mainImageView)
                        
                        let pasentage = Float((post.progressTarget ) - (post.target ))/Float(post.progressTarget )
                        self.progressLabel.setProgress((pasentage), animated: true)
                }
            }
        }
    }
    var user:User? {
        didSet {
           if let user = user {
               guard let url = URL(string: user.profileImageUrl ) else { return }
            Nuke.loadImage(with: url, into: profileImage)
            }
                }
            }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = 13
        progressLabel.progressTintColor = .red
        fetchUserInfoFromFirestore()
    }
    
    private func fetchUserInfoFromFirestore() {
        
        Firestore.firestore().collection("users").getDocuments { (snapshots, err) in
            if let err = err {
                print("user情報の取得に失敗しました。\(err)")
                return
            }
            
            snapshots?.documents.forEach({ (snapshot) in
                let dic = snapshot.data()
                let user = User.init(dic: dic)
                user.uid = snapshot.documentID
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                if uid == snapshot.documentID {
                    return
                }
                
                self.users.append(user)
            })
        }
    }
    
    
    
    private func dateFormatterForDateLabel(date: Date) -> String {
           let formatter = DateFormatter()
           formatter.dateStyle = .full
           formatter.timeStyle = .short
           formatter.locale = Locale(identifier: "ja_JP")
           return formatter.string(from: date)
       }
    
    
    
}


