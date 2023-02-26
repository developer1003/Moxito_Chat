//
//  LoginVC.swift
//  MoxitoChat
//
//  Created by Mirsaidov Bekzod on 16/12/22.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    
    @IBOutlet weak var logEmailTF: UITextField!
    @IBOutlet weak var logPasswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    @IBAction func logInBtnPressed(_ sender: UIButton) {
        if let email = logEmailTF.text, let password = logPasswordTF.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let e = error {
                    print(e)
                } else {
                    let vc = ChatVC(nibName: K.VCNames.nChatVC, bundle: nil)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
