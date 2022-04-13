//
//  ViewController.swift
//  Swimmy
//
//  Created by 伊藤寛人 on 2021/06/20.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import PKHUD
import Nuke


class MainViewController: UIViewController {

    @IBOutlet weak var AppealListCollectionView: UICollectionView!
 
    
    
    private var posts = [Post]()
    private var users = [User]()
    
    var isExpanded: Bool = true
    var database: Firestore!
    var auth: Auth!
    
    private let cellId = "cellId"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Swimmy"
        navigationController?.navigationBar.barTintColor = .orange
        
        auth = Auth.auth()
        AppealListCollectionView.backgroundColor = .white
        AppealListCollectionView.dataSource = self
        AppealListCollectionView.delegate = self
//       AppealListCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        AppealListCollectionView.register(UINib(nibName: "AppealListCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        confirmLoggedInUser()
        let rightbarbutton = UIBarButtonItem(title: "ログアウト", style: .plain, target: self, action: #selector(tappedLogoutButton))
        navigationItem.rightBarButtonItem = rightbarbutton
        
        
        fetchposts()
        fetchUser()
        confirmLoggedInUser()
    }
    
    func fetchUser() {
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
                self.AppealListCollectionView.reloadData()
            })
        }
    }
    private func fetchposts() {
        let db = Firestore.firestore()
        
        db.collection("posts").getDocuments { snapshots, error in
            if let error = error {
                print(error)
            }
            guard let snapshot  = snapshots?.documents else { return }
            snapshot.forEach { QueryDocumentSnapshot in
                let dic = QueryDocumentSnapshot.data()
               print("firebasepost",dic)
                var post = Post(data: dic)
                if post.userId != "" {
                    
                    db.collection("users").document(post.userId).getDocument { snapshot, error in
                        if let error = error {
                            print(error)
                        }
                        let dic = snapshot?.data()
                        post.user = User.init(dic: dic ?? [:])
                        self.posts.append(post)
                        self.AppealListCollectionView.reloadData()
                    }
                    
                    print("post",post)
                    
                } else {
                    self.posts.append(post)
                    self.AppealListCollectionView.reloadData()
                }
                
    
                
                
                print("posts",self.posts)
            }
        }
    }
    
    
    
    
    //postViewControllerに飛ぶ
    @IBAction func postJunpButton(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "Post", bundle: nil)
        let PostViewController = storyboard.instantiateViewController(identifier: "PostViewController")
        navigationController?.pushViewController(PostViewController, animated: true)
    }
    
   

//ログアウトの機能
    @objc private func tappedLogoutButton() {
   print("signout")
     do {
         try Auth.auth().signOut()
         pushLoginViewController()
        print("ログアウトできました")
     } catch {
         print("ログアウトに失敗しました。 \(error)")
        //
     }
 }
    
    //ログイン中であればMainViewControllerに
    private func confirmLoggedInUser() {
           if Auth.auth().currentUser?.uid == nil {
               pushLoginViewController()
           }
    }
    private func pushLoginViewController() {
        print("サインインして")
        let  storyboard = UIStoryboard(name: "Login", bundle: nil)
        let LoginViewController = storyboard.instantiateViewController(identifier: "LoginViewController")

        self.present(LoginViewController, animated: true, completion: nil)
        }
}


extension MainViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "AppealCard", bundle: nil)
        let AppealCardViewController = storyboard.instantiateViewController(identifier: "AppealCardViewController") as! AppealCardViewController
        AppealCardViewController.post = posts[indexPath.row]
        
        
        navigationController?.pushViewController(AppealCardViewController, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = self.view.frame.width
            
            return .init(width: width, height: width)
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = AppealListCollectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! AppealListCell
        
        cell.user = posts[indexPath.row].user
        cell.titleLabel.text = posts[indexPath.row].content
        cell.dateLabel.text = posts[indexPath.row].atention
        cell.post = posts[indexPath.row]
        return cell
    }
}

