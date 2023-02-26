//
//  RegisterVC.swift
//  MoxitoChat
//
//  Created by Mirsaidov Bekzod on 25/02/23.
//

import UIKit
import FirebaseAuth


class RegisterVC: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func registerBtnPressed(_ sender: UIButton) {
        if let email = emailTF.text, let password = PasswordTF.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    let vc = ChatVC(nibName: K.VCNames.nChatVC, bundle: nil)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    
}
