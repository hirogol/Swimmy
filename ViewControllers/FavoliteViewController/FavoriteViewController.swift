//
//  FavoliteViewController.swift
//  Swimmy
//
//  Created by 伊藤寛人 on 2021/06/20.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Firebase
import Nuke


class FavoriteViewController: UIViewController {

    private var posts = [Post]()
    
    @IBOutlet weak var favoriteTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "お気に入り"
        navigationController?.navigationBar.barTintColor = .orange

        favoriteTable.delegate = self
        favoriteTable.dataSource = self
        fetchposts()
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
            let post = Post(data: dic)
            print("post",post)
            self.posts.append(post)
            self.favoriteTable.reloadData()
         //   print("posts".posts)
        }
    }
}
}


extension FavoriteViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoriteTable.dequeueReusableCell(withIdentifier: "favoriteCell", for:indexPath)as! FavoriteCell
      cell.post = posts[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped table view")
        let storyboard = UIStoryboard.init(name: "AppealCard", bundle: nil)
        let AppealCardViewController = storyboard.instantiateViewController(identifier: "AppealCardViewController") as! AppealCardViewController
        AppealCardViewController.post = posts[indexPath.row]
        navigationController?.pushViewController(AppealCardViewController, animated: true)
    }
    
}

class FavoriteCell: UITableViewCell {
    
    var post: Post? {
        didSet{
            if let post = post {
                favoriteTitle.text = post.content
                
                if let url = URL(string: post.postImageUrl ?? "") {
                Nuke.loadImage(with: url, into: favoriteImage)
                }
            }
        }
    }

    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var favoriteTitle: UILabel!
    @IBOutlet weak var dislikeButton: UIButton!
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
       // favoriteImage.layer.cornerRadius = 15
    }
}
