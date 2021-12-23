//
//  CollectionCellReusable.swift
//  Posts.demo
//
//  Created by devmac on 22.12.2021.
//

import UIKit

protocol CollectionCellReusable: AnyObject {}

extension CollectionCellReusable {
    static func cell(in tableView: UICollectionView,
                                              for indexPath: IndexPath) -> Self {
        return tableView.dequeueReusableCell(withReuseIdentifier: String(describing: self),
                                             for: indexPath) as! Self
    }
}
