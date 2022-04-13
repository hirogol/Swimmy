//
//  LoginViewController.swift
//  Swimmy
//hiro03.gol@gmail.com
//  Created by 伊藤寛人 on 2021/07/10.
//

import UIKit
import Firebase
import PKHUD
import FirebaseAuth

class LoginViewController: UIViewController {
    
    var auth: Auth!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dontHaveAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 8
        dontHaveAccountButton.addTarget(self, action: #selector(tappedDontHaveAccountButton), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(tappedLoginButton), for: .touchUpInside)
    }
//
    @objc private func tappedDontHaveAccountButton() {
        let storyboard: UIStoryboard = UIStoryboard(name: "SignUp", bundle: nil)
        guard let signvc = storyboard.instantiateInitialViewController() else { return }
        self.present(signvc, animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        print("サインイン")
    }

    @objc private func tappedLoginButton() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }

        HUD.show(.progress)

        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("ログインに失敗しました。\(err)")
                HUD.hide()
                return
            }

            HUD.hide()
            print("ログインに成功しました。")
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let MainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
            self.navigationController?.pushViewController(MainViewController, animated: true)
            
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


