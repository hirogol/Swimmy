//
//  PostViewController.swift
//  Swimmy
//
//  Created by 伊藤寛人 on 2021/06/20.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PKHUD


class  PostViewController: UIViewController {
    
    @IBOutlet weak var postImageButton: UIButton!
    @IBOutlet weak var titleTextLabel: UITextField!
    @IBOutlet weak var atentionText: UITextView!
    @IBOutlet weak var targetNumberLabel: UITextField!
    @IBOutlet weak var postButton: UIButton!
    
    var database: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "投稿"
        navigationController?.navigationBar.barTintColor = .orange

        database = Firestore.firestore()
        titleTextLabel.delegate = self
        atentionText.delegate = self
        targetNumberLabel.delegate = self
        postImageButton.addTarget(self, action: #selector(tappedPostImageButton), for: .touchUpInside)
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tapGR.cancelsTouchesInView = false
                self.view.addGestureRecognizer(tapGR)
        postButton.isEnabled = false
        postButton.backgroundColor = .rgb(red: 100, green: 100, blue: 100)
    }
    
    //キーボードを閉じる
    @objc func dismissKeyboard() {
            self.view.endEditing(true)
        }
    
    
    @objc override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
               self.view.endEditing(true)
        }
    //写真のアップロード
    @objc func tappedPostImageButton() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    
    //投稿ボタンを押したとき
    @IBAction func postButton(_ sender: Any) {
        guard let image = postImageButton.imageView?.image else { return }
        guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }
        
        HUD.show(.progress)
        
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("post_image").child(fileName)
                
                storageRef.putData(uploadImage, metadata: nil) { (matadata, err) in
                    if let err = err {
                        print("Firestorageへの情報の保存に失敗しました。\(err)")
                        HUD.hide()
                        return
                    }
                    print("情報の保存に成功しました")
                    HUD.hide()
                    storageRef.downloadURL { (url, err) in
                        if let err = err {
                            print("Firestorageからのダウンロードに失敗しました。\(err)")
                            HUD.hide()
                            return
                        }
                        guard let urlString = url?.absoluteString else { return }
                        self.postFirestore(postImageUrl: urlString)
                    }
                }
    }
        
       private func postFirestore(postImageUrl:String) {
    
        guard let content = titleTextLabel.text else { return }
        guard let atention =  atentionText.text else { return }
           
           guard let target = Int (targetNumberLabel.text ?? "0" ) else { return }
           guard let progressTarget = Int(targetNumberLabel.text ?? "0") else { return }
           guard let uid = Auth.auth().currentUser?.uid else { return }
           
           
           
            let saveDocument = Firestore.firestore().collection("posts").document()
            saveDocument.setData([
                "content": content,
                "atention": atention,
                "target": target,
                "progressTarget":progressTarget,
                "postImageUrl":postImageUrl,
                "postID": saveDocument.documentID,
                "createdAt": FieldValue.serverTimestamp(),
                "updatedAt": FieldValue.serverTimestamp(),
                "userId": uid
            ])
      { (err) in
                if let err = err {
                    print("Firestoreへの保存に失敗しました。\(err)")
                    HUD.hide()
                    return
            }
                    print("Firestoreへの情報の保存が成功しました。")
                    HUD.hide()
          let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
          let MainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
          self.navigationController?.pushViewController(MainViewController, animated: true)
            }
    }
    }

    //全て記入するとボタンを押せる
    extension PostViewController: UITextFieldDelegate, UITextViewDelegate {
        func textFieldDidChangeSelection(_ textField: UITextField) {
            let titleTextEmpty = titleTextLabel.text?.isEmpty ?? false
            let atentionTextEmpty = atentionText.text?.isEmpty ?? false
            let targetNumberEmpty = targetNumberLabel.text?.isEmpty ?? false
            
            if titleTextEmpty || atentionTextEmpty || targetNumberEmpty {
                postButton.isEnabled = false
                postButton.backgroundColor = .rgb(red: 100, green: 100, blue: 100)
            } else {
                postButton.isEnabled = true
                postButton.backgroundColor = .rgb(red: 0, green: 0, blue: 0)
            }
        }
}

    extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        //写真アップロード
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editImage = info[.editedImage] as? UIImage {
                postImageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
            } else if let originalImage = info[.originalImage] as? UIImage {
                postImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            postImageButton.setTitle("", for: .normal)
            postImageButton.imageView?.contentMode = .scaleAspectFill
            postImageButton.contentHorizontalAlignment = .fill
            postImageButton.contentVerticalAlignment = .fill
            postImageButton.clipsToBounds = true
            dismiss(animated: true, completion: nil)
        }
        
        
    struct Post {
        let content: String
        let postID: String
        let senderID: String
        let createdAt: Timestamp
        let updatedAt: Timestamp

        init(data: [String: Any]) {
            content = data["content"] as! String
            postID = data["postID"] as! String
            senderID = data["senderID"] as! String
            createdAt = data["createdAt"] as! Timestamp
            updatedAt = data["updatedAt"] as! Timestamp
        }
    }
        struct User {
            
        }
    
    
    }
  
