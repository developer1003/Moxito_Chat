//
//  WelcomeVC.swift
//  MoxitoChat
//
//  Created by Mirsaidov Bekzod on 16/12/22.
//

import UIKit
import SSNeumorphicView

class WelcomeVC: UIViewController {
    
    @IBOutlet weak var ChatEntranceLbl: UILabel!
    @IBOutlet weak var registerBtn: SSNeumorphicButton!
    @IBOutlet weak var loginBtn: SSNeumorphicButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
        chatEntrance()
        
    }
    
    //MARK: -setup functions
    
    func setupButtons() {
        registerBtn.btnDepthType = .outerShadow
        registerBtn.tintColor = .clear
        loginBtn.btnDepthType = .outerShadow
        loginBtn.tintColor = .clear
        
    }
    
    public func chatEntrance() {
        ChatEntranceLbl.text = ""
        let titleText = K.appName
        var charIndex = 0
        for letter in titleText {
            
            Timer.scheduledTimer(withTimeInterval: 0.1  * Double(charIndex), repeats: false) { timer in
                self.ChatEntranceLbl.text?.append(letter)
            }
            charIndex += 1
        }
    }
    
    
    //MARK: - button actions
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        let vc = RegisterVC(nibName: K.VCNames.nRegisterVC, bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        let vc = LoginVC(nibName: K.VCNames.nLogVC, bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
