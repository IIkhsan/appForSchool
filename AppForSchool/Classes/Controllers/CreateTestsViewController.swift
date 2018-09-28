//
//  CreateTestsViewController.swift
//  AppForSchool
//
//  Created by Ilyas on 27.07.2018.
//  Copyright © 2018 itis. All rights reserved.
//

import UIKit

class CreateTestsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var criteries = [Critery]()
    let identifier = "Cell"
    let criteryIdentifier = "criteryCell"
    let services = APIServices()
    var lessonID: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "AddSchoolTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: criteryIdentifier)
    }
    
    @objc func addCritery(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indxPathCurrent = tableView.indexPathForRow(at: point)
        let cell = tableView.cellForRow(at: indxPathCurrent!) as! AddSchoolTableViewCell
        if let name = cell.textLabel?.text {
            services.createCriterios(criterionID: nil, lessonID: lessonID, name: name) { (lesson, error) in
                if let error = error {
                    self.presentAlert(withTitle: "Ошибка", message: "\(error)")
                } else {
                    let alert = UIAlertController(title: "Успешно", message: "Изменения сохранены", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
//                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

extension CreateTestsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return criteries.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row >= criteries.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! AddSchoolTableViewCell
            cell.addButton.target(forAction: #selector(addCritery(_:)), withSender: self)
            return cell
        } else {
            let criteryCell = UITableViewCell(style: .default, reuseIdentifier: criteryIdentifier)
            criteryCell.textLabel?.text = criteries[indexPath.row].name
            return criteryCell
        }
    }
    
}
