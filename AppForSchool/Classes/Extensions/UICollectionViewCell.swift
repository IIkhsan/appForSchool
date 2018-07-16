//
//  UICollectionViewCell.swift
//  Evo
//
//  Created by Ленар Гилязов on 13.01.18.
//  Copyright © 2018 Evo. All rights reserved.
//

import UIKit

extension UICollectionViewCell{
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
