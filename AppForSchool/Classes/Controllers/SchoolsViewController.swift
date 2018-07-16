//
//  SchoolsViewController.swift
//  AppForSchool
//
//  Created by Ilyas on 15.07.2018.
//  Copyright © 2018 itis. All rights reserved.
//

import UIKit

class SchoolsViewController: UIViewController {

    @IBOutlet weak var tableView : UITableView!
    lazy var services = APIServices()
    var schools = [School]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let token = UserDefaults.standard.string(forKey: "token")
        services.getAllSchools(header: token!) { (schools, error) in
            if let error = error {
                self.presentAlert(withTitle: "Error", message: "\(error)")
            } else {
                self.schools = schools!
                self.tableView.reloadData()
            }
        }
    }

}

extension SchoolsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = schools[indexPath.row].name
        cell.detailTextLabel?.text = schools[indexPath.row].created_at
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Lessons") as! LessonsViewController
        vc.schoolID = schools[indexPath.row].id
        navigationController?.pushViewController(vc, animated: true)
    }
}
