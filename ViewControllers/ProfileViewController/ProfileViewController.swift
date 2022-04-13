//
//  ProfileViewController.swift
//  Swimmy
//
//  Created by 伊藤寛人 on 2021/06/20.
//
import UIKit
import Nuke
import FirebaseStorage
import FirebaseAuth
import Firebase
import FirebaseAnalytics

class ProfileViewController: UIViewController {
    
    private var users = [User]()
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    

    var user: User?
//    {
//        didSet {
//            usernameLabel.text = user?.username
//            
//            if let url = URL(string: user?.profileImageUrl ?? "") {
//                Nuke.loadImage(with: url, into: userImageView)
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "プロフィール"
        navigationController?.navigationBar.barTintColor = .orange

        
        let rightbarbutton = UIBarButtonItem(title: "ログアウト", style: .plain, target: self, action: #selector(tappedLogoutButton))
        navigationItem.rightBarButtonItem = rightbarbutton
        
        let leftbarbutton = UIBarButtonItem(title: "編集", style: .plain, target: self, action: #selector(tappedEditButton))
        navigationItem.leftBarButtonItem = leftbarbutton
        fetchProfile()
        
    }
   
    
    private func fetchProfile() {
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
                    self.usernameLabel.text = user.username
    
                    if let url = URL(string: user.profileImageUrl ) {
                        Nuke.loadImage(with: url, into: self.userImageView)
                    }
                    return
                }
            })
            
        }}
                                         
                                         
                                         
                                         
   @objc private func tappedEditButton() {
    let  storyboard = UIStoryboard(name: "ProfileEdit", bundle: nil)
        let ProfileEditViewController = storyboard.instantiateViewController(identifier: "ProfileEditViewController")
//        loginViewController.modalPresentationStyle = .fullScreen
        self.present(ProfileEditViewController, animated: true, completion: nil)
    }
    
    
    @objc private func tappedLogoutButton() {
    let  storyboard = UIStoryboard(name: "Login", bundle: nil)
        let LoginViewController = storyboard.instantiateViewController(identifier: "LoginViewController")
        //        loginViewController.modalPresentationStyle = .fullScreen
        self.present(LoginViewController, animated: true, completion: nil)
    }
    
}


