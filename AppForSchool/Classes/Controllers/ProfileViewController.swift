//
//  ProfileViewController.swift
//  AppForSchool
//
//  Created by Ilyas on 15.07.2018.
//  Copyright © 2018 itis. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var firstNameLabel : UILabel!
    @IBOutlet weak var lastNameLabel : UILabel!
    @IBOutlet weak var patronymiclabel : UILabel!
    @IBOutlet weak var userTypeLabel : UILabel!
    @IBOutlet weak var tableView : UITableView!
    var refreshController = UIRefreshControl()
    
    lazy var services = APIServices()
    let id = UserDefaults.standard.integer(forKey: "uid")
    var schools = [School]()
    var user: User? {
        didSet {
            firstNameLabel.text = user?.first_name
            lastNameLabel.text = user?.last_name
            patronymiclabel.text = user?.user_type
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshController.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshController.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.addSubview(refreshController)
        
        services.getUser() { (user, error) in
            if let error = error {
                self.presentAlert(withTitle: "Error", message: "\(error)")
            } else {
                self.user = user
            }
        }
        self.loadSchoolsFromServer()
        
        tableView.register(UINib(nibName: "AddSchoolTableViewCell", bundle: nil), forCellReuseIdentifier: "AddSchoolTableViewCell")
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout)), animated: true)
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    @objc func refresh() {
        self.loadSchoolsFromServer()
    }
    
    func loadSchoolsFromServer() {
        services.getAllSchools() { (schools, error) in
            if let error = error {
                self.presentAlert(withTitle: "Error", message: "\(error)")
            } else if let schools = schools{
                self.schools = [School]()
                for school in schools {
                    if self.user?.school_id == school.id {
                        self.schools.append(school)
                    }
                }
            }
            if self.refreshController.isRefreshing {
                self.refreshController.endRefreshing()
            }
            self.tableView.reloadData()
        }
    }
    
    @objc func logout() {
        services.logout() { (status, error) in
            if let error = error {
                self.presentAlert(withTitle: "Error", message: "\(error)")
            } else if status {
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()
                self.present(vc!, animated: true, completion: nil)
            }
            
        }
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schools.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row >= schools.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddSchoolTableViewCell") as! AddSchoolTableViewCell
            cell.addButton.addTarget(self, action: #selector(addNewSchool), for: .touchUpInside)
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .clear
            cell.textLabel?.text = schools[indexPath.row].name
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row >= schools.count {
            return false
        }
        return true
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.services.deleteSchool(schoolID: self.schools[indexPath.row].id, completition: { (result, error) in
                if let error = error {
                    self.presentAlert(withTitle: "Ошибка", message: "\(error)")
                } else {
                    self.schools.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .left)
                    self.loadSchoolsFromServer()
                }
            })
        }
        
        let edite = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            let vc = EditSchoolViewController(nibName: nil, bundle: nil)
            vc.school = self.schools[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        edite.backgroundColor = .green
        return [delete, edite]
    }
    
    @objc func addNewSchool(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indxPathCurrent = tableView.indexPathForRow(at: point)
        let cell = tableView.cellForRow(at: indxPathCurrent!) as! AddSchoolTableViewCell
        if let schoolName = cell.nameTextField.text {
            services.createSchool(schoolID: nil, name: schoolName) { (school, error) in
                if let error = error {
                    self.presentAlert(withTitle: "Ошибка", message: "\(error)")
                } else {
                    self.loadSchoolsFromServer()
                    self.presentAlert(withTitle: "Успешно", message: "Школа сохранена")
                }
            }
        }
    }
}
