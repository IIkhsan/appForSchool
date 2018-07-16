//
//  AddNewLessonViewController.swift
//  AppForSchool
//
//  Created by Ilyas on 15.07.2018.
//  Copyright © 2018 itis. All rights reserved.
//

import UIKit

class AddNewLessonViewController: UIViewController {
    
    var addButton: UIBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveNewLesson))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.tintColor = .white
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func saveNewLesson() {
        
    }
}
