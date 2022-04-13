//
//  ProfileEdit.swift
//  Swimmy
//
//  Created by 伊藤寛人 on 2021/08/25.
//

import Foundation
import UIKit
import RxSwift
import PKHUD
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Nuke

class ProfileEditViewController: UIViewController {
    
   
   @IBOutlet weak var profileEditImageButton: UIButton!
    @IBOutlet weak var nikNameTextField: UITextField!
    @IBOutlet weak var sexField: UITextField!
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var keepButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        profileEditImageButton.addTarget(self, action: #selector(tappedProfileEdit), for: .touchUpInside)
        keepButton.addTarget(self, action: #selector(tappedKeepButton), for: .touchUpInside)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true)
    }
    
    @objc func tappedProfileEdit () {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }

  
        

    //編集内容の保存
    @objc func tappedKeepButton() {
        self.dismiss(animated: true, completion: nil)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let nikName = self.nikNameTextField.text else { return }
        guard let sex = self.sexField.text else { return }
        guard let Name = self.NameField.text else { return }
        guard let age = self.ageField.text else { return }
        guard let address = self.addressField.text else { return }
        
           let saveDocument :[String: Any] =
                (["nikName": nikName,
                "sex": sex,
                "Name": Name,
                "age": age,
                "address": address,
                "updatedAt": FieldValue.serverTimestamp()
            ])
        
        Firestore.firestore().collection("users").document(uid).updateData(saveDocument) { err in
            if let err = err {
                print("ユーザー情報の更新に失敗: ", err)
                return
            }
           
            print("ユーザー情報の更新に成功")
        }
    
    }
 

    
    
    
    
    
    //編集内容の取得
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
                
                    
                    self.nikNameTextField.text = user.nikName
                    self.sexField.text = user.sex
                    self.NameField.text = user.Name
                    self.ageField.text = user.age
                    self.addressField.text = user.address
                    return
                }
            })
        }
    }
    }
    
    



extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            
            profileEditImageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileEditImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        profileEditImageButton.setTitle("", for: .normal)
        profileEditImageButton.imageView?.contentMode = .scaleAspectFill
        profileEditImageButton.contentHorizontalAlignment = .fill
        profileEditImageButton.contentVerticalAlignment = .fill
        profileEditImageButton.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
}
