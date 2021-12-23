//
//  TableCellReusable.swift
//  Posts.demo
//
//  Created by devmac on 22.12.2021.
//

import UIKit

protocol TableCellReusable: AnyObject {}

extension TableCellReusable {
    static func cell(in tableView: UITableView,
                                         for indexPath: IndexPath) -> Self {
        return tableView.dequeueReusableCell(withIdentifier: String(describing: self),
                                             for: indexPath) as! Self
    }
}
