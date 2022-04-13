//
//  SignUpViewController.swift
//  Swimmy
//  Created by 伊藤寛人 on 2021/06/20.
//
//
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

import PKHUD


class SignUpViewController: UIViewController {
    var auth: Auth!


    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var alreadyHaveAccountButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
   setupViews()

    }

    private func setupViews() {
        auth = Auth.auth()
        profileImageButton.layer.cornerRadius = 85
        profileImageButton.layer.borderWidth = 1
        registerButton.layer.cornerRadius = 15

        profileImageButton.addTarget(self, action: #selector(tappedImageButton), for:.touchUpInside)
        registerButton.addTarget(self, action: #selector(tappedRegisterButton), for: .touchUpInside)
        alreadyHaveAccountButton.addTarget(self, action: #selector(tappedalreadyHaveAccountButton), for: .touchUpInside)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.delegate = self

        registerButton.isEnabled = false
    }


    @objc private func tappedImageButton() {
//        print("tapped")
        //写真のアップロード
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }

//    ログイン画面への遷移
    @objc private func tappedalreadyHaveAccountButton() {
        print("ログイン画面")
        let  storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(identifier: "LoginViewController")
//
        self.present(loginViewController, animated: true, completion: nil)
    }


    @objc private func tappedRegisterButton() {

        guard let image = profileImageButton.imageView?.image else { return }
        guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }

        HUD.show(.progress)

        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_image").child(fileName)

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
                        self.createUserToFirestore(profileImageUrl: urlString)
                    }

                }

    }


    private func createUserToFirestore(profileImageUrl: String) {

        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }

        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
            print("認証情報の保存に失敗した\(err)")
            HUD.hide()
            return
        }
            print("認証情報に成功しました")
            HUD.hide()

            guard let uid = res?.user.uid else { return }
            guard let username = self.usernameTextField.text else { return }
                        let docData = [
                            "email": email,
                            "username": username,
                            "createdAt": Timestamp(),
                            "profileImageUrl": profileImageUrl
                            ] as [String : Any]

                        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
                            if let err = err {
                                print("Firestoreへの保存に失敗しました。\(err)")
                                HUD.hide()
                                return
                            }

                            print("Firestoreへの情報の保存が成功しました。")
                            HUD.hide()
                            self.dismiss(animated: true, completion: nil)
                        }
    }
    }
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
    }
}

//登録ボタンの色の変更
extension SignUpViewController:UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextField.text?.isEmpty ?? false
               let passwordIsEmpty = passwordTextField.text?.isEmpty ?? false
               let usernameIsEmpty = usernameTextField.text?.isEmpty ?? false

               if emailIsEmpty || passwordIsEmpty || usernameIsEmpty {
                   registerButton.isEnabled = false
                registerButton.backgroundColor = .red
               } else {
                   registerButton.isEnabled = true
                registerButton.backgroundColor = .blue
               }
    }
}
extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            profileImageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        profileImageButton.setTitle("", for: .normal)
        profileImageButton.imageView?.contentMode = .scaleAspectFill
        profileImageButton.contentHorizontalAlignment = .fill
        profileImageButton.contentVerticalAlignment = .fill
        profileImageButton.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
}
