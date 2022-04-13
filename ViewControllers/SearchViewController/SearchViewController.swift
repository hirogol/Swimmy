//
//  SearchViewController.swift
//  Swimmy
//
//  Created by 伊藤寛人 on 2021/06/20.
//

import Foundation
import UIKit
import Nuke
import Firebase
import FirebaseFirestore
import FirebaseStorage


class SearchViewController: UIViewController,UISearchBarDelegate {

    
    private var posts = [Post]()
    var searchResult = [Post]()
    
    
    
    
    @IBOutlet weak var searchItem: UISearchBar?
    @IBOutlet weak var searchTable: UITableView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchItem?.delegate = self
        searchTable.dataSource = self
        searchTable.delegate = self
        searchItem?.showsCancelButton = true
        searchTable.keyboardDismissMode = .onDrag
        navigationController?.navigationBar.barTintColor = .orange
        fetchposts()
      //  searchResult = posts
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
            self.searchResult.append(post)
            self.searchTable.reloadData()
//            print("posts".posts)
        }
    }
}
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResult = []
        var filterdArr: [Post] = []
                if searchText == "" {
                    searchResult = posts
                    searchTable.reloadData()
                } else {
                    //||$0.name.contains(searchtext) あるゴリラAPI
                    filterdArr = posts.filter{$0.content.contains(searchText)}
//                    filterdArr = posts.filter({ Post in
//                        Post.content.contains(searchText)
//                    })
                    searchResult = filterdArr
                    self.searchTable.reloadData()
                }

    }

}


extension SearchViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 80
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTable.dequeueReusableCell(withIdentifier: "celledId", for:indexPath)as! ChoiceTableViewCell
      cell.post = searchResult[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped table view")
        let storyboard = UIStoryboard.init(name: "AppealCard", bundle: nil)
        let AppealCardViewController = storyboard.instantiateViewController(identifier: "AppealCardViewController") as! AppealCardViewController
        AppealCardViewController.post = searchResult[indexPath.row]
        navigationController?.pushViewController(AppealCardViewController, animated: true)
    }
}


class ChoiceTableViewCell: UITableViewCell {
  
    
    
    var post: Post? {
        didSet{
            if let post = post {
                choiceTitle.text = post.content
                if let url = URL(string: post.postImageUrl ?? "") {
                Nuke.loadImage(with: url, into: choiceImage)
                }
            }
        }
    }
    
    @IBOutlet weak var choiceTitle: UILabel!
    @IBOutlet weak var choiceImage: UIImageView!
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}



