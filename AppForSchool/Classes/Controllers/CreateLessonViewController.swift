//
//  CreateLessonViewController.swift
//  AppForSchool
//
//  Created by Ilyas on 26.07.2018.
//  Copyright © 2018 itis. All rights reserved.
//

import UIKit

class CreateLessonViewController: UIViewController {

    @IBOutlet weak var lessonNameTextField: UITextField!
    @IBOutlet weak var startDatePickerView: UIDatePicker!
    @IBOutlet weak var endDatePickerView: UIDatePicker!
    @IBOutlet weak var teacherPicker: UIPickerView!
    
    let services = APIServices()
    var schoolID : Int!
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Save lesson", style: .done, target: self, action: #selector(saveLesson)), animated: true)
        services.getUsers { (users, error) in
            if let error = error {
                self.presentAlert(withTitle: "Ошибка", message: "\(error)")
            } else {
                if let users = users {
                    self.users = users
                    self.teacherPicker.reloadAllComponents()
                }
            }
        }
    }
    
    @objc func saveLesson() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let startTime = dateFormatter.string(from: startDatePickerView.date)
        let endTime = dateFormatter.string(from: endDatePickerView.date)
        let userID = (users[teacherPicker.selectedRow(inComponent: 0)].id)
        guard let name = lessonNameTextField.text else { return }
        print(name, endTime, startTime, userID)
            
        services.createLeson(name: name, startTime: startTime, endTime: endTime, schoolID: schoolID, teacherID: userID) { (lesson, error) in
            if let error = error {
                self.presentAlert(withTitle: "Ошибка", message: "\(error)")
            } else {
                let alert = UIAlertController(title: "Успешно", message: "Изменения сохранены", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension CreateLessonViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView {
        case teacherPicker:
            return 1
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case teacherPicker:
            return users.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case teacherPicker:
            return users[row].first_name
        default:
            return "Row"
        }
    }
    
}


