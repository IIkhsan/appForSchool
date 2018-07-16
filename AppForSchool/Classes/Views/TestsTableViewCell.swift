//
//  TestsTableViewCell.swift
//  AppForSchool
//
//  Created by Ilyas on 15.07.2018.
//  Copyright © 2018 itis. All rights reserved.
//

import UIKit

class TestsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var valueLabel : UILabel!
    @IBOutlet weak var valueChangeSlider : UISlider!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBAction func changeLabelValue(_ sender: Any) {
        valueLabel.text = String(Int(valueChangeSlider.value))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
