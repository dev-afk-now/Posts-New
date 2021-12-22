//
//  CollectionCellReusable.swift
//  Posts.demo
//
//  Created by devmac on 22.12.2021.
//

import UIKit

protocol CollectionCellReusable: AnyObject {}

extension CollectionCellReusable {
    static func cell<T: UITableViewCell>(in tableView: UITableView, for indexPath: IndexPath, _ : T.Type) -> T? {
        return tableView.dequeueReusableCell(withIdentifier: String(describing: T.self),
                                             for: indexPath) as? T
    }
}
