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
    @IBOutlet weak var tableVIew : UITableView!
    
    var addButton: UIBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logout))
    lazy var services = APIServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableVIew.isEditing = true
        addButton.tintColor = .white
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func logout() {
        let token = UserDefaults.standard.string(forKey: "token")
        services.logout(token: token!) { (status, error) in
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        cell.textLabel?.text = "School #121"
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
}
