//
//  CreateSchoolViewController.swift
//  AppForSchool
//
//  Created by Ilyas on 22.07.2018.
//  Copyright © 2018 itis. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class CreateSchoolViewController: UIViewController {
    
    @IBOutlet weak var schoolNameTextField : SkyFloatingLabelTextField!
    var service = APIServices()

    @IBAction func addSchoolButtonTap(_ sender: Any) {
        if let name = schoolNameTextField.text {
            service.createSchool(schoolID: nil, name: name) { (school, error) in
                if error != nil {
                    self.presentAlert(withTitle: "Ошибка", message: "Школа не создана из-за ошибки сервера")
                } else {
                    self.presentAlert(withTitle: "Сообщение", message: "Школа создана")
                }
            }
        } else {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
