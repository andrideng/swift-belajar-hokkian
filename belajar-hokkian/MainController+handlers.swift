//
//  MainController+handlers.swift
//  belajar-hokkian
//
//  Created by Andri Deng on 7/7/17.
//  Copyright © 2017 Andri Deng. All rights reserved.
//

import UIKit
import Firebase

extension MainController: UINavigationControllerDelegate {
    
    func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginCtrl = LoginController()
        loginCtrl.mainController = self
        present(loginCtrl, animated: true, completion: nil)
    }
}
