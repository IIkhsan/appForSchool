//
//  LessonsViewController.swift
//  AppForSchool
//
//  Created by Ilyas on 15.07.2018.
//  Copyright © 2018 itis. All rights reserved.
//

import UIKit

class LessonsViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    var schoolID : Int?
    var lessons = [Lesson]()
    lazy var service = APIServices()
    

    var addButton: UIBarButtonItem = UIBarButtonItem(title: "New", style: .done, target: self, action: #selector(newLesson))

    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.tintColor = .white
        navigationItem.rightBarButtonItem = addButton
        var token = UserDefaults.standard.string(forKey: "token")
        token = "HohPynyWQNjQsfcEYUf2dJKy"
        service.getAllLessons(schoolID:  nil, authorization: token!) { (lessons, error) in
            if let error = error {
                self.presentAlert(withTitle: "Error", message: "\(error)")
            } else {
                self.lessons = lessons!
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func newLesson() {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddNewLesson")
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LessonsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = lessons[indexPath.row].name
        cell.detailTextLabel?.text = lessons[indexPath.row].start_time
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Tests")
        navigationController?.pushViewController(vc, animated: true)
    }
}
