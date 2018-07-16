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
    var addButton: UIBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTestResults))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        addButton.tintColor = .white
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func saveTestResults() {
        
    }

}

extension TestsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TestsTableViewCell
        cell.valueLabel.text = String(cell.valueChangeSlider.value)
        cell.titleLabel.text = "Уровень приспособленности к жизни"
        return cell
    }
    
    
}
