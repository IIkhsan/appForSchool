//
//  UIViewController.swift
//  SchoolApp
//
//  Created by Ilyas on 13.07.2018.
//  Copyright © 2018 itis. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func navigateToProfileViewController() {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        present(vc!, animated: true, completion: nil)
    }
    
}
