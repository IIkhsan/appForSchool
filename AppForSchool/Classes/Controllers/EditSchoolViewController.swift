//
//  EditSchoolViewController.swift
//  AppForSchool
//
//  Created by Ilyas on 26.07.2018.
//  Copyright © 2018 itis. All rights reserved.
//

import UIKit

class EditSchoolViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    let services = APIServices()
    var school: School?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let school = school {
            textField.text = school.name
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveSchool(_ sender: Any) {
        if let school = school {
            services.createSchool(schoolID: school.id, name: textField.text!) { (school, error) in
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
        } else {
            print("lol")
        }
    }
}
