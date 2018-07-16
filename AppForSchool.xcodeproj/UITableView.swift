//
//  UITableView.swift
//  Evo
//
//  Created by Ленар Гилязов on 15.01.18.
//  Copyright © 2018 Evo. All rights reserved.
//

import UIKit

extension UITableView {
    /// Присваиваем таблице пустой футер, чтобы в конце не отрисовывались бесконечные сепараторы
    func assignEmptyTableFooterToHideEmptyCellsSeparators() {
        tableFooterView = UIView()
    }
    
    func scrollToLastCell() {
        if numberOfRows(inSection: numberOfSections - 1) != 0 {
            let indexPath = IndexPath(row: numberOfRows(inSection: numberOfSections - 1) - 1, section: numberOfSections - 1)
            scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    
    /// Устанавливает делегата и data source, после обновляет таблицу
    ///
    /// - Parameter dataSourceDelegate: Класс, который наследуется от протоколов UITableViewDelegate и UITableViewDataSource
    func setTableViewViewDataSourceDelegate<D: UITableViewDelegate & UITableViewDataSource>(_ dataSourceDelegate: D) {
        dataSource = dataSourceDelegate
        delegate = dataSourceDelegate
        reloadData()
    }

}
