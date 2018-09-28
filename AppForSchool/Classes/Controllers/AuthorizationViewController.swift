//
//  AuthorizationViewController.swift
//  SchoolApp
//
//  Created by Ilyas on 11.07.2018.
//  Copyright © 2018 itis. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AuthorizationViewController: UIViewController {

    @IBOutlet weak var emailTextField : SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField : SkyFloatingLabelTextField!
    
    lazy var services = APIServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func tapToEnterButton(_ sender: Any) {
        autharizationUser(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction func tapToRegistration(_ sender: Any) {
        navigateToSignUpViewController()
    }
    
    func autharizationUser(email: String, password: String) {
        if validateCredintails(email: email, password: password) {
            services.signIn(
            email: email,
            password: password
            ) { (token, error) in
                if error != nil {
                    self.presentAlert(withTitle: "Ошибка", message: "Ошибка авторизации")
                } else {
                    UserDefaults.standard.set(token?.token, forKey: "token")
                    UserDefaults.standard.set(token?.id, forKey: "uid")
                    UserDefaults.standard.synchronize()
                    self.navigateToProfileViewController()
                }
            }
        } else {
            presentAlert(withTitle: "Invalidate data", message: "Please, check your password and email lenght")
        }
    }
    
    func validateCredintails(email: String, password: String) -> Bool {
        if doCredintailsExceedMinLenghth(email: email, password: password) {
            return true
        }
        presentAlert(withTitle: "Invalidate data", message: "Please, check your password and email lenght")
        return false
    }
    
    func doCredintailsExceedMinLenghth(email: String, password: String) -> Bool {
        return (
            email.count >= Constants.minEmailLenght &&
                password.count >= Constants.minPasswordLenght
        )
    }
    
    func navigateToSignUpViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Registration")
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
