//
//  RegistrationViewController.swift
//  SchoolApp
//
//  Created by Ilyas on 11.07.2018.
//  Copyright © 2018 itis. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class RegistrationViewController: UIViewController {

    @IBOutlet weak var emailTextField : SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField : SkyFloatingLabelTextField!
    @IBOutlet weak var replayPasswordTextField : SkyFloatingLabelTextField!
    @IBOutlet weak var firstNameTextField : SkyFloatingLabelTextField!
    @IBOutlet weak var lastNameTextField : SkyFloatingLabelTextField!
    
    lazy var services = APIServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func tapToEnter(_ sender : Any) {
        registrationUser(email: emailTextField.text!, password: passwordTextField.text!, replayPassword: replayPasswordTextField.text!, firstName: firstNameTextField.text!, lastName: lastNameTextField.text!)
    }
    
    func registrationUser(email: String, password: String, replayPassword: String, firstName: String, lastName: String) {
        if checkPasswords(password: password, replayPassword: replayPassword) {
            if checkTextFields(email: email, firstName: firstName, lastName: lastName) {
                services.signUp(email: email, password: password, firstName: firstName, lastName: lastName, userType: "teacher") { (token, error) in
                    if let error = error {
                        self.presentAlert(withTitle: "Error", message: "Please, replay your request")
                    }
                    UserDefaults.standard.set(token?.token, forKey: "token")
                    UserDefaults.standard.set(token?.id, forKey: "uid")
                    self.navigateToProfileViewController()
                }
            } else {
                presentAlert(withTitle: "Warning", message: "Fill in all fields")
            }
        }
    }
    
    func checkTextFields(email: String, firstName: String, lastName: String) -> Bool {
        return (
            email.count >= Constants.minEmailLenght &&
                firstName.count >= Constants.minimalNamesLenght && lastName.count >= Constants.minimalNamesLenght
        )
    }
    
    func checkPasswords(password: String, replayPassword: String) -> Bool {
        if password.count >= Constants.minPasswordLenght && replayPassword.count >= Constants.minPasswordLenght && password == replayPassword {
            return true
        }
        presentAlert(withTitle: "Password do not match", message: "Please, enter the same password")
        return false
    }
    
    
}
