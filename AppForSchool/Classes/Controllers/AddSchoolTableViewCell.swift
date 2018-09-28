//
//  AddSchoolTableViewCell.swift
//  AppForSchool
//
//  Created by Ilyas on 26.07.2018.
//  Copyright © 2018 itis. All rights reserved.
//

import UIKit

class AddSchoolTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addButton : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
