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
    @IBOutlet weak var schoolListPicker : UIPickerView!
    @IBOutlet weak var teacherListPicker : UIPickerView!
    
    lazy var services = APIServices()
    var schoolsList = [School]()
    let teacher = ["teacher" ,"assistant_principal", "principal"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(tapToEnter(_:))), animated: true)
        services.getAllSchools { (schools, error) in
            if let error = error {
                self.presentAlert(withTitle: "Error", message: "\(error)")
            } else {
                self.schoolsList = schools!
                self.schoolListPicker.reloadAllComponents()
            }
        }
    }
    
    @objc func tapToEnter(_ sender : Any) {
        registrationUser(email: emailTextField.text!, password: passwordTextField.text!, replayPassword: replayPasswordTextField.text!, firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, patronymic: "", userType: teacher[teacherListPicker.selectedRow(inComponent: 0)], schoolID: schoolsList[schoolListPicker.selectedRow(inComponent: 0)].id)
    }
    
    func registrationUser(email: String, password: String, replayPassword: String, firstName: String, lastName: String, patronymic: String, userType: String, schoolID: Int) {
        if checkPasswords(password: password, replayPassword: replayPassword) {
            if checkTextFields(email: email, firstName: firstName, lastName: lastName) {
                services.signUp(email: email, password: password, firstName: firstName, lastName: lastName, userType: userType, patronymic: patronymic, schoolId: schoolID) { (token, error) in
                    if let error = error {
                        print(error)
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

extension RegistrationViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView {
        case schoolListPicker:
            return 1
        case teacherListPicker:
            return 1
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case schoolListPicker:
            return schoolsList.count
        case teacherListPicker:
            return teacher.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case schoolListPicker:
            return schoolsList[row].name
        case teacherListPicker:
            return teacher[row]
        default:
            return "No"
        }
    }
}
