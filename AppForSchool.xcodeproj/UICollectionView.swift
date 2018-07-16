//
//  CollectionView.swift
//  Evo
//
//  Created by Ленар Гилязов on 13.02.18.
//  Copyright © 2018 Evo. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    /// Устанавливает делегата и data source, после обновляет коллекцию
    ///
    /// - Parameter dataSourceDelegate: Класс, который наследуется от протоколов UICollectionViewDataSource и UICollectionViewDelegate
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDelegate & UICollectionViewDataSource>(_ dataSourceDelegate: D) {
        dataSource = dataSourceDelegate
        delegate = dataSourceDelegate
        reloadData()
    }
    
}
