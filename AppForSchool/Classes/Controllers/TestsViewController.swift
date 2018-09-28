//
//  TestsViewController.swift
//  AppForSchool
//
//  Created by Ilyas on 15.07.2018.
//  Copyright © 2018 itis. All rights reserved.
//

import UIKit

class TestsViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    lazy var services = APIServices()
    var criteryID: Int?
    var criteryes = [Critery]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        navigationItem.setRightBarButtonItems([UIBarButtonItem(title: "Новый критерий", style: .done, target: self, action: #selector(newTests)), UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveTestResults))], animated: true)
        navigationItem.rightBarButtonItem?.tintColor = .white
        services.getAllCriteries(lessonID: criteryID!) { (criteryes, error) in
            self.criteryes = criteryes!
            self.tableView.reloadData()
        }
    }
    
    @objc func newTests() {
        let vc = CreateTestsViewController(nibName: "CreateTestsViewController", bundle: nil)
        vc.lessonID = criteryID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func saveTestResults() {
        let uid = UserDefaults.standard.integer(forKey: "uid")
        for (index, critery) in criteryes.enumerated() {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! TestsTableViewCell
            services.sendCriteryInfo(criterionID: critery.id, lessonID: critery.lesson_id, userID: uid, mark: Int(cell.valueChangeSlider.value)) { (response, error) in
                if let error = error {
                    self.presentAlert(withTitle: "Error", message: "\(error)")
                } else {
                    print(response?.lesson_id)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

}

extension TestsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return criteryes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TestsTableViewCell
        cell.valueLabel.text = String(cell.valueChangeSlider.value)
        cell.titleLabel.text = criteryes[indexPath.row].name
        return cell
    }
    
    
}
