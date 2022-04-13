//
//  AppealCardViewController.swift
//  Swimmy
//
//  Created by 伊藤寛人 on 2021/06/24.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import PKHUD
import Nuke


class AppealCardViewController: UIViewController {
    
    
    @IBOutlet weak var appealProfileImage: UIImageView!
    @IBOutlet weak var appealTitleLabel: UILabel!
    @IBOutlet weak var appealImage: UIImageView!
    @IBOutlet weak var appealTotalLabel: UILabel!
    @IBOutlet weak var appealProgress: UIProgressView!
    @IBOutlet weak var appealExplaLabel: UILabel!
    @IBOutlet weak var appealSandButton: UIButton!
    @IBOutlet weak var appealLikeButton: UIButton!
    @IBOutlet weak var appealLikeLabel: UILabel!
    @IBOutlet weak var appealSignalLabel: UILabel!
    
    
    
    internal var post: Post?
    internal var user :User?
   
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
       
        navigationItem.title = "署名"
    
        self.appealExplaLabel.layer.borderColor = .init(red: 1, green: 1, blue: 1, alpha: 1)
        appealProfileImage.layer.cornerRadius = 20
      //  appealProfileImage.addTarget(self, action:#selector(tappedAppealProfileButton), for: .touchUpInside)
        appealSandButton.layer.cornerRadius = 20
        appealLikeLabel.textColor = .red
       
        fetchCard()
        fetchusers()
        progressview()
    }

    private func fetchusers(){
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
                    if let url = URL(string: user.profileImageUrl ) {
                        Nuke.loadImage(with: url, into: self.appealProfileImage)
                    }
                    return
                }
            })
        }
    }

    func fetchCard() {
        
        appealTitleLabel.text = post?.content
        appealExplaLabel.text = post?.atention
       
        let total: Int = post?.target ?? 0
        let str:String = String(total)
        appealTotalLabel.text = "目標まであと\(str)人"
        

        if let url = URL(string: post?.postImageUrl ?? "") {
        Nuke.loadImage(with: url, into:appealImage )
        }
    }

    @IBAction func tappedLikeButton(_ sender: UIButton) {
    
    sender.isEnabled = false
    appealLikeLabel.text = "お気に入り！"
    sender.flash()
        
    
    }
    
    
    
    @IBAction func tappedSandButton(_ sender: UIButton) {
        sender.isEnabled = false//ボタンを一度しか押せないようにする
        
        let payload: [String : Any] = [
                     "target": FieldValue.increment(-1.0),
                     "updatedAt": Timestamp()
                 ]
        guard let postId = post?.postID else {return}
        Firestore.firestore().collection("posts").document(postId).updateData(payload) {[unowned self] error in
                       if let error = error {
                          print(error)
                       }
            appealSignalLabel.text = "署名しました！！"
            post?.target -= 1
            let goal = 0
            let total: Int = self.post?.target ?? 0
            let str:String = String(total)
            appealTotalLabel.text = "目標まであと\(str)人"
            
            //目標までが０人になったとき遷移
            if str == String(goal){
                let storyboard = UIStoryboard.init(name: "Goal", bundle: nil)
                let GoalViewController = storyboard.instantiateViewController(identifier: "GoalViewController")
                navigationController?.pushViewController(GoalViewController, animated: true)
            }
            progressview()
            sender.flash()
        }
    }

    func progressview() {
        
        let pasentage = Float((post?.progressTarget ?? 0) - (post?.target ?? 0))/Float(post?.progressTarget ?? 0)
        self.appealProgress.setProgress((pasentage), animated: true)
    }
    
    @objc func tappedAppealProfileButton(){
        let storyboard = UIStoryboard.init(name: "PartnerUserProfile", bundle: nil)
        let PartnerUserProfileViewController = storyboard.instantiateViewController(identifier: "PartnerUserProfileViewController")
        navigationController?.pushViewController(PartnerUserProfileViewController, animated: true)
          }
}


extension UIButton {
    func flash(){
   // 光るボタン
           let flash = CABasicAnimation(keyPath: "opacity")
           flash.duration = 0.5
           flash.fromValue = 1
           flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
           flash.repeatCount = 2

           layer.add(flash, forKey: nil)
   }


}
