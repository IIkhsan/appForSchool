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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setRightBarButton(UIBarButtonItem(title: "New lesson", style: .done, target: self, action: #selector(newLesson)), animated: true)
        navigationItem.rightBarButtonItem?.tintColor = .white
        service.getAllLessons(schoolID: schoolID) { (lessons, error) in
            if let error = error {
                self.presentAlert(withTitle: "Error", message: "\(error)")
            } else {
                self.lessons = lessons!
                print(lessons)
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func newLesson() {
        let vc = CreateLessonViewController(nibName: "CreateLessonViewController", bundle: nil)
        vc.schoolID = schoolID
        self.navigationController?.pushViewController(vc, animated: true)
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
        let vc = storyboard.instantiateViewController(withIdentifier: "Tests") as! TestsViewController
        vc.criteryID = lessons[indexPath.row].id
        navigationController?.pushViewController(vc, animated: true)
    }
}
