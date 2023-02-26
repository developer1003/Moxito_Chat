//
//  AppDelegate.swift
//  MoxitoChat
//
//  Created by Mirsaidov Bekzod on 16/12/22.
//

import UIKit
import FirebaseCore


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        let vc = WelcomeVC(nibName: K.VCNames.nWelcomeVC, bundle: nil)
        let nav = UINavigationController(rootViewController: vc)
        
        window?.makeKeyAndVisible()
        window?.rootViewController =  nav
        
        FirebaseApp.configure()
        return true
    }
    
    
    
}

