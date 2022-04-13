//
//  PartnerUserProfile.swift
//  Swimmy
//
//  Created by 伊藤寛人 on 2022/02/03.
//

import Foundation
import Firebase
import UIKit
import Firebase
import Nuke
import FirebaseAuth
import FirebaseFirestore



class PartnerUserProfileViewController: UIViewController {
    
    
    
    private var user: User? {
        didSet {
            navigationItem.title = user?.username
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

    
}

    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
