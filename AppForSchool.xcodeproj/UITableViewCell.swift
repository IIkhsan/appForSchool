//
//  UITableView.swift
//  Evo
//
//  Created by Ленар Гилязов on 09.01.18.
//  Copyright © 2018 Evo. All rights reserved.
//

import UIKit

extension UITableViewCell{
    static var nib: UINib{
        return UINib(nibName: self.nibName, bundle: nil)
    }
    
    static var nibName: String{
        return String.init(describing: self.self)
    }
    
    static var cellIdentifier: String{
        return String.init(describing: self.self)
    }
}
